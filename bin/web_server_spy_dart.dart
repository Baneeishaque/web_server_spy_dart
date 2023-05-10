import 'package:web_server_spy_dart/folder_content_type_enum.dart';
import 'package:web_server_spy_dart/to_utils/is_ok_modal.dart';
import 'package:web_server_spy_dart/web_server_spy_dart.dart'
    as web_server_spy_dart;

Future<void> main(List<String> arguments) async {
  IsOkModal<String> mainScanData = await web_server_spy_dart.getScanResponse();
  if (mainScanData.status) {
    var websiteFolderData =
        web_server_spy_dart.getFirstHtmlComment(mainScanData.data!);
    if (websiteFolderData.status) {
      print('Website Folder : ${websiteFolderData.data}');
      // TODO : Continue Check

      RegExp regExp = RegExp(r'(\/home\d*\/[a-z0-9]+\/)');
      String? homeFolder = regExp.firstMatch(websiteFolderData.data!)?.group(0);
      if (homeFolder != null) {
        print('Home Folder : $homeFolder');
        // TODO : Continue Check

        IsOkModal<String> homeFolderContentsHtml =
            await web_server_spy_dart.getScanResponse(homeFolder);
        if (homeFolderContentsHtml.status) {
          IsOkModal<String> homeFolderContentsData = web_server_spy_dart
              .getFirstHtmlComment(homeFolderContentsHtml.data!);
          if (homeFolderContentsData.status) {
            List<String>? homeFolderContents =
                homeFolderContentsData.data!.split('\n').sublist(2);
            print('Home Folder Contents : $homeFolderContents');
            // TODO : Continue Check

            for (String folderContent in homeFolderContents) {

              String folderContentAbsolutePath = '$homeFolder$folderContent';
              var folderContentTypeData = await web_server_spy_dart
                  .getFolderContentType(folderContentAbsolutePath);
              if (folderContentTypeData.status) {

                switch (folderContentTypeData.data!) {
                  case FolderContentType.file:
                    print('$folderContentAbsolutePath is a file');
                    break;
                  case FolderContentType.folder:
                    print('$folderContentAbsolutePath is a folder');
                    break;
                  case FolderContentType.link:
                    print('$folderContentAbsolutePath is a link');
                    break;
                  default:
                    print('Error : week of backends');
                }
              } else {
                print('Error : week of backends');
              }
            }
          } else {
            print('Error : week of backends');
          }
        } else {
          print('Error : week of backends');
        }
      } else {
        print('Error : week of backends');
      }
    } else {
      print('Error : week of backends');
    }
  } else {
    print(mainScanData.data);
  }
}
