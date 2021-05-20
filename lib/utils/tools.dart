import 'dart:io';

import 'package:g_json/g_json.dart';

import 'shell.dart';

///
/// 获取APK签名信息
/// MD5、SHA1、SHA256
///
String getCertInfo(FileSystemEntity apk, {String type = 'MD5'}) {
  final filter = Platform.isWindows ? '|findStr /i $type' : '|grep -i $type';
  final cmd = 'keytool -list -printcert -jarfile ${apk.path} $filter';
  final result = runSync(cmd, './');
  final info = result.stdout.toString().trim();
  print(info);
  // MD5:  8E:CA:92:37:87:DF:E6:86:DA:E7:58:FC:3F:A3:73:78
  return info.replaceFirst('$type:', '').trim();
}

///
/// 获取APK信息
/// 需要配置aapt环境变量，位于AndroidSDK\build-tools目录下
///
JSON getPackageInfo(FileSystemEntity apk) {
  final filter = Platform.isWindows ? '|findStr package' : '|grep package';
  final result = runSync('aapt dump badging ${apk.path} $filter', './');
  final info = result.stdout.toString().trim();
  print(info);
  //package: name='com.yuxiaor' versionCode='8599' versionName='8.1.3' compileSdkVersion='29' compileSdkVersionCodename='10'
  final firstLine = info.split('\n').first.replaceFirst('package:', '');
  final array = firstLine.split(' ');
  final map = {};
  for (var it in array) {
    final pair = it.split('=');
    final key = pair.first.trim();
    final value = pair.last.replaceAll('\'', '').trim();
    map[key] = value;
  }
  return JSON(map);
}
