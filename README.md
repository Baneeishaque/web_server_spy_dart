# Web Server Spy Dart

[![Dart](https://github.com/Baneeishaque/web_server_spy_dart/actions/workflows/dart.yml/badge.svg)](https://github.com/Baneeishaque/web_server_spy_dart/actions/workflows/dart.yml)
[![Dart Version](https://img.shields.io/badge/Dart-%5E3.0.0--400.0.dev-blue)](https://dart.dev)
[![Version](https://img.shields.io/badge/version-1.0.0-green)](https://github.com/Baneeishaque/web_server_spy_dart)

A Dart command-line application for scanning and analyzing web server directory structures. This tool makes HTTP requests to a web server endpoint and parses HTML responses to discover and categorize files, folders, and symbolic links.

---

## Table of Contents

- [Features](#features)
- [Technical Overview](#technical-overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [API Reference](#api-reference)
- [Project Structure](#project-structure)
- [Development](#development)
- [Testing](#testing)
- [CI/CD](#cicd)
- [Contributing](#contributing)
- [Changelog](#changelog)

---

## Features

- 🔍 **Directory Scanning**: Recursively scan web server directories
- 📁 **Content Type Detection**: Identify files, folders, and symbolic links
- 🧩 **HTML Parsing**: Extract structured data from HTML comments
- ⚡ **Async Operations**: Non-blocking HTTP requests using Dart's `Future` API
- 🛠️ **Modular Design**: Reusable library functions for custom implementations
- 📦 **Type-Safe**: Generic `IsOkModal<T>` for consistent result handling

---

## Technical Overview

### Core Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| [`html`](https://pub.dev/packages/html) | ^0.15.2 | HTML parsing and DOM manipulation |
| [`http`](https://pub.dev/packages/http) | ^0.13.5 | HTTP client for making web requests |

### Dev Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| [`lints`](https://pub.dev/packages/lints) | ^2.0.0 | Recommended Dart linting rules |
| [`test`](https://pub.dev/packages/test) | ^1.21.0 | Testing framework |

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    CLI Entry Point                          │
│                  (bin/web_server_spy_dart.dart)             │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    Core Library                              │
│                (lib/web_server_spy_dart.dart)               │
│  ┌───────────────────┐  ┌───────────────────────────────┐  │
│  │ getActionResponse │  │ getScanResponse               │  │
│  │ getFirstHtmlComment│  │ getFolderContentType         │  │
│  └───────────────────┘  └───────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    Utility Models                            │
│  ┌─────────────────────┐  ┌──────────────────────────────┐ │
│  │ IsOkModal<T>        │  │ FolderContentType            │ │
│  │ (Result wrapper)    │  │ (file, folder, link)         │ │
│  └─────────────────────┘  └──────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

## Prerequisites

- **Dart SDK**: Version 3.0.0-400.0.dev or higher
- **Git**: For cloning the repository
- **Internet Connection**: Required for HTTP requests to the target server

### Installing Dart

#### macOS (using Homebrew)
```bash
brew tap dart-lang/dart
brew install dart
```

#### Linux
```bash
sudo apt-get update
sudo apt-get install apt-transport-https
wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
sudo apt-get update
sudo apt-get install dart
```

#### Windows (using Chocolatey)
```bash
choco install dart-sdk
```

---

## Installation

### Clone the Repository

```bash
git clone https://github.com/Baneeishaque/web_server_spy_dart.git
cd web_server_spy_dart
```

### Install Dependencies

```bash
dart pub get
```

---

## Usage

### Running the CLI Application

```bash
dart run bin/web_server_spy_dart.dart
```

### Expected Output

The application will:
1. Scan the main website folder
2. Extract the home folder path using regex pattern matching
3. List contents of the home folder
4. Identify the type of each item (file, folder, or link)

**Sample Output:**
```
Website Folder : /home1/example/public_html/project/villa
Home Folder : /home1/example/
Home Folder Contents : [.bashrc, public_html, mail, ...]
/home1/example/.bashrc is a file
/home1/example/public_html is a folder
/home1/example/mail is a link
```

### Using as a Library

You can import the library in your own Dart project:

```dart
import 'package:web_server_spy_dart/web_server_spy_dart.dart';

void main() async {
  // Scan a specific directory
  var result = await getScanResponse('/path/to/scan');
  
  if (result.status) {
    print('Scan successful: ${result.data}');
  } else {
    print('Scan failed: ${result.data}');
  }
  
  // Check content type
  var typeResult = await getFolderContentType('/path/to/item');
  
  if (typeResult.status) {
    switch (typeResult.data) {
      case FolderContentType.file:
        print('It\'s a file!');
        break;
      case FolderContentType.folder:
        print('It\'s a folder!');
        break;
      case FolderContentType.link:
        print('It\'s a symbolic link!');
        break;
    }
  }
}
```

---

## API Reference

### Core Functions

#### `getActionResponse`
```dart
Future<IsOkModal<String>> getActionResponse({
  required String action,
  required String fileName,
})
```
Makes an HTTP GET request with the specified action and filename as query parameters.

**Parameters:**
- `action`: The action to perform (e.g., 'scan', 'type')
- `fileName`: The target file or directory path

**Returns:** `IsOkModal<String>` containing the response body on success

---

#### `getScanResponse`
```dart
Future<IsOkModal<String>> getScanResponse([String fileName = 'Main'])
```
Scans a directory and returns its contents.

**Parameters:**
- `fileName`: The directory path to scan (default: 'Main')

**Returns:** `IsOkModal<String>` with HTML content containing directory information

---

#### `getFirstHtmlComment`
```dart
IsOkModal<String> getFirstHtmlComment(String htmlText)
```
Extracts the first HTML comment from the provided HTML text.

**Parameters:**
- `htmlText`: Raw HTML string to parse

**Returns:** `IsOkModal<String>` with the trimmed comment content

---

#### `getFolderContentType`
```dart
Future<IsOkModal<FolderContentType>> getFolderContentType(
  String fileAbsolutePath,
)
```
Determines whether a path points to a file, folder, or symbolic link.

**Parameters:**
- `fileAbsolutePath`: The absolute path to check

**Returns:** `IsOkModal<FolderContentType>` indicating the content type

---

### Models

#### `IsOkModal<T>`
A generic result wrapper for consistent error handling.

```dart
class IsOkModal<T> {
  final bool status;   // true if operation succeeded
  final T? data;       // result data (null on failure)
  
  const IsOkModal(this.status, [this.data]);
}
```

#### `FolderContentType`
Enum representing the type of content in a folder.

```dart
enum FolderContentType { file, folder, link }
```

---

## Project Structure

```
web_server_spy_dart/
├── bin/
│   └── web_server_spy_dart.dart    # CLI entry point
├── lib/
│   ├── web_server_spy_dart.dart    # Core library functions
│   ├── folder_content_type_enum.dart # FolderContentType enum
│   └── to_utils/
│       └── is_ok_modal.dart        # Generic result wrapper
├── test/
│   └── .gitkeep                    # Test directory placeholder
├── .github/
│   └── workflows/
│       └── dart.yml                # GitHub Actions CI workflow
├── analysis_options.yaml           # Dart static analysis config
├── pubspec.yaml                    # Package configuration
├── CHANGELOG.md                    # Version history
├── renovate.json                   # Renovate bot configuration
└── README.md                       # This file
```

---

## Development

### Setting Up Your Development Environment

1. **Clone and install dependencies:**
   ```bash
   git clone https://github.com/Baneeishaque/web_server_spy_dart.git
   cd web_server_spy_dart
   dart pub get
   ```

2. **Open in your preferred IDE:**
   - **VS Code**: Install the [Dart extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code)
   - **IntelliJ IDEA / Android Studio**: Install the Dart plugin
   - The project includes `.idea/` configuration for JetBrains IDEs

### Code Style

This project uses the recommended Dart lint rules from `package:lints/recommended.yaml`.

**Format your code:**
```bash
dart format .
```

**Analyze your code:**
```bash
dart analyze
```

**Run both format check and analysis:**
```bash
dart format --output=none --set-exit-if-changed . && dart analyze
```

---

## Testing

### Running Tests

```bash
dart test
```

### Writing Tests

Add your test files in the `test/` directory. Example:

```dart
import 'package:test/test.dart';
import 'package:web_server_spy_dart/web_server_spy_dart.dart';

void main() {
  group('getFirstHtmlComment', () {
    test('extracts comment from HTML', () {
      var html = '<!-- This is a comment --><html></html>';
      var result = getFirstHtmlComment(html);
      
      expect(result.status, isTrue);
      expect(result.data, equals('This is a comment'));
    });
    
    test('handles missing comment gracefully', () {
      var html = '<html></html>';
      var result = getFirstHtmlComment(html);
      
      expect(result.status, isFalse);
    });
  });
}
```

---

## CI/CD

This project uses **GitHub Actions** for continuous integration.

### Workflow Overview

The CI pipeline (`.github/workflows/dart.yml`) runs on:
- Push to `master` branch
- Pull requests targeting `master` branch

### Pipeline Steps

| Step | Description |
|------|-------------|
| Checkout | Clone the repository |
| Setup Dart | Install Dart SDK 3.0.0-400.0.dev |
| Install Dependencies | Run `dart pub get` |
| Verify Formatting | Check code formatting with `dart format` |
| Analyze Source | Run static analysis with `dart analyze` |

### Running CI Checks Locally

```bash
# Install dependencies
dart pub get

# Check formatting
dart format --output=none --set-exit-if-changed .

# Run static analysis
dart analyze

# Run tests
dart test
```

---

## Contributing

We welcome contributions! Please follow these guidelines:

### Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/web_server_spy_dart.git
   cd web_server_spy_dart
   ```
3. **Create a feature branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```
4. **Install dependencies:**
   ```bash
   dart pub get
   ```

### Development Workflow

1. **Make your changes** following the code style guidelines
2. **Format your code:**
   ```bash
   dart format .
   ```
3. **Run static analysis:**
   ```bash
   dart analyze
   ```
4. **Write/update tests** for your changes
5. **Run tests:**
   ```bash
   dart test
   ```
6. **Commit your changes:**
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

### Commit Message Convention

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

### Submitting a Pull Request

1. **Push your branch:**
   ```bash
   git push origin feature/your-feature-name
   ```
2. **Open a Pull Request** on GitHub
3. **Describe your changes** in the PR description
4. **Wait for CI checks** to pass
5. **Address review feedback** if any

### Reporting Issues

When reporting bugs, please include:
- Dart SDK version (`dart --version`)
- Operating system
- Steps to reproduce
- Expected vs actual behavior
- Error messages or logs

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and release notes.

---

## Dependency Management

This project uses [Renovate](https://renovatebot.com/) for automated dependency updates. The configuration is in `renovate.json`.

---

## Support

- 📖 [Dart Documentation](https://dart.dev/guides)
- 💬 [Dart Community](https://dart.dev/community)
- 🐛 [Report Issues](https://github.com/Baneeishaque/web_server_spy_dart/issues)

---

<p align="center">
  Made with ❤️ using <a href="https://dart.dev">Dart</a>
</p>
