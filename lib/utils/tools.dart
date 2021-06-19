import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as _path;

///
/// 在当前工作目录下查找APK文件
///
File findApkInCurrentDir() {
  return Directory('./')
      .listSync(
        recursive: false, //递归到子目录
        followLinks: false, //不包含链接
      )
      .firstWhere(
        (file) => _path.extension(file.path) == '.apk',
        orElse: () => null,
      );
}

String readFile(String path) {
  if (path == null || path.isEmpty) return '';
  final txtFile = File(path);
  if (txtFile.existsSync()) {
    return txtFile.readAsStringSync();
  }
  return '';
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
