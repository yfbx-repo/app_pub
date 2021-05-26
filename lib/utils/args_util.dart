import 'package:args/args.dart';

void setCommonArgs(ArgParser argParser) {
  argParser.addOption(
    'file',
    abbr: 'f',
    help: 'APK file path',
  );
  argParser.addOption(
    'appId',
    abbr: 'i',
    help: 'huawei app id',
  );
  argParser.addOption(
    'desc',
    abbr: 'd',
    help: 'Description of new features about this update',
  );
  argParser.addOption(
    'txt',
    abbr: 't',
    help: 'Description of new features about this update in txt file',
  );
}

///
/// Extension
///
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
