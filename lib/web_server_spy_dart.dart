import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'folder_content_type_enum.dart';
import 'to_utils/is_ok_modal.dart';

Future<IsOkModal<String>> getActionResponse(
    {required String action, required String fileName}) async {
  http.Response response = await http.get(
      Uri.https('esjayassociates.com', '/project/villa/', {action: fileName}));
  if (response.statusCode == 200) {
    return IsOkModal(true, response.body);
  } else {
    return IsOkModal(
        false, 'Request failed with status: ${response.statusCode}.');
  }
}

Future<IsOkModal<String>> getScanResponse([String fileName = 'Main']) {
  return getActionResponse(action: 'scan', fileName: fileName);
}

IsOkModal<String> getFirstHtmlComment(String htmlText) {
  try {
    return IsOkModal(
        true, ((parse(htmlText).nodes[0]) as Comment).data!.trim());
  } on Exception catch (exception) {
    return IsOkModal(false, exception.toString());
  }
}

Future<IsOkModal<FolderContentType>> getFolderContentType(
    String fileAbsolutePath) async {
  var actionResult =
      await getActionResponse(action: 'type', fileName: fileAbsolutePath);
  if (actionResult.status) {
    var folderContentTypeData = getFirstHtmlComment(actionResult.data!);
    if (folderContentTypeData.status) {
      if (folderContentTypeData.data == '$fileAbsolutePath is a file.') {
        return IsOkModal(true, FolderContentType.file);
      }
      if (folderContentTypeData.data == '$fileAbsolutePath is a folder.') {
        return IsOkModal(true, FolderContentType.folder);
      }
      if (folderContentTypeData.data == '$fileAbsolutePath is a link.') {
        return IsOkModal(true, FolderContentType.link);
      }
    }
  }
  return IsOkModal(false);
}
