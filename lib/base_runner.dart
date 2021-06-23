import 'dart:io';

import 'package:args/args.dart';

abstract class BaseRunner {
  final ArgParser parser;
  ArgResults args;

  BaseRunner(this.parser) {
    parser.addOption(
      'apk',
      abbr: 'a',
      help: 'APK file path.',
    );
    parser.addOption(
      'desc',
      abbr: 'd',
      help: 'Description of new features about this update.',
    );
    parser.addOption(
      'txt',
      abbr: 't',
      help: 'Description of new features about this update in txt file.',
    );
    parser.addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage info.',
    );
    parser.addFlag(
      'publish',
      negatable: false,
      help:
          'true: Publish app to app market. false: Query app info from market.',
    );
  }

  bool get help => args.getBool('help');
  bool get publish => args.getBool('publish');
  String get name => args.getString('name');
  String get package => args.getString('package');
  String get apk => args.getString('apk');
  String get _desc => args.getString('desc');
  String get _txt => args.getString('txt');
  String get appId => args.getString('id');
  String get versionCode => args.getString('version');

  String get updateDesc =>
      _desc.isEmpty ? File(_txt).readAsStringSync() : _desc;

  void run(List<String> arguments) {
    if (arguments == null || arguments.isEmpty) {
      printUsage();
      return;
    }

    args = parser.parse(arguments);

    if (help) {
      printUsage();
      return;
    }

    runCommand();
  }

  void runCommand();

  bool isArgsValid() {
    if (apk.isEmpty || !apk.endsWith('apk')) {
      print('Error: please check APK file path!');
      printUsage();
      return false;
    }

    if (_desc.isEmpty && _txt.isEmpty) {
      print('Error: description is required!');
      printUsage();
      return false;
    }
    return true;
  }

  void printUsage() {
    print(parser.usage);
  }
}

extension Args on ArgResults {
  String getString(String key, {String defaultValue = ''}) {
    final value = this[key];
    return value ?? defaultValue;
  }

  bool getBool(String key, {bool defaultValue = false}) {
    final value = this[key];
    return value ?? defaultValue;
  }
}
