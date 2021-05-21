import 'dart:io';

import 'package:g_json/g_json.dart';

import 'env.dart';

///
/// 配置信息
///
class Configs {
  JSON _json;

  Configs._() {
    final filePath = '${env.currentPath}configs.json';
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
}

final configs = _initConfigs();

Configs _initConfigs() => Configs._();
