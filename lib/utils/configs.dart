import 'dart:io';

import 'package:g_json/g_json.dart';

import 'env.dart';

///
/// 配置信息
///
class Configs {
  JSON _json;

  Configs._() {
    final filePath = 'D:\\demos\\app_pub\\configs.json';
    final jsonStr = File(filePath).readAsStringSync();
    _json = JSON.parse(jsonStr);
  }

  ///VIVO
  String get accessKey => _json['vivo']['accessKey'].stringValue;
  String get accessSecret => _json['vivo']['accessSecret'].stringValue;

  ///Xiaomi
  String get username => _json['xiaomi']['username'].stringValue;
  String get password => _json['xiaomi']['password'].stringValue;
  String get pubKey =>
      File('${env.currentPath}xiaomi_pub_key.cer').readAsStringSync();

  ///Huawei
  // String get appId => _json['huawei']['appId'].stringValue;
  String get clientId => _json['huawei']['clientId'].stringValue;
  String get clientSecret => _json['huawei']['clientSecret'].stringValue;
}

final configs = _initConfigs();

Configs _initConfigs() => Configs._();
