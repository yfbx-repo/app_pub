import 'dart:io';

import 'package:market/markets/vivo.dart';
import 'package:market/utils/env.dart';

void main() {
  //查询
  vivo.query('com.yuxiaor');
}

//更新
void update() {
  //APK文件
  final apk = File('${env.currentPath}Yuxiaor_8.1.4_8622.apk');
  //更新文案
  final updateDesc = File('${env.currentPath}update.txt').readAsStringSync();
  vivo.update(apk, updateDesc);
}
