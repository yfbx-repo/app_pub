import 'dart:io';

import 'package:app_pub/markets/huawei.dart';
import 'package:app_pub/markets/vivo.dart';
import 'package:app_pub/markets/xiaomi.dart';

void main(List<String> args) {
  final apk = File('d:\\demos\\app_pub\\Yuxiaor_8.1.6_8704.apk');
  final hwAppId = '100354477';
  final updateDesc = '修复已知问题，优化用户体验';

  //huawei.update(apk, hwAppId, updateDesc);

  //xiaomi.update(apk, updateDesc);

  vivo.update(apk, updateDesc);
}
