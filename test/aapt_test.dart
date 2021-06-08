import 'dart:io';

import 'package:app_pub/utils/apk_file.dart';

void main(List<String> args) {
  /// aapt 在VSCode中无法运行，在命令行中可以运行？？？
  final apk = File('d:\\demos\\app_pub\\Yuxiaor_8.1.6_8704.apk');
  final pkgInfo = apk.packageInfo;
  print(pkgInfo);
}
