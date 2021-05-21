//测试环境

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';
import 'package:market/utils/configs.dart';
import 'package:market/utils/tools.dart';
import 'package:path/path.dart' as path;

final vivo = _initVivo();

VIVO _initVivo() => VIVO._();

class VIVO {
  final _serverUrl = 'https://developer-api.vivo.com.cn/router/rest';
  final _accessKey = configs.accessKey;
  final _accessSecret = configs.accessSecret;

  VIVO._();

  ///
  /// 更新
  ///
  void update(File apk, String updateDesc) async {
    print('------------------------VIVO START----------------------');
    final apkName = path.basename(apk.path);
    final filePart = await MultipartFile.fromFile(apk.path, filename: apkName);
    print('获取文件MD5:');
    final md5Code = md5.convert(apk.readAsBytesSync()).toString();
    print(md5Code);
    print('解析Package信息:');
    final pkgInfo = getPackageInfo(apk);
    final packageName = pkgInfo['packageName'].stringValue;
    final versionCode = pkgInfo['versionCode'];

    print('上传APK...');
    final json = await post(
      method: 'app.upload.apk.app',
      file: filePart,
      args: {
        'packageName': packageName,
        'fileMd5': md5Code,
      },
    );

    //上传结果
    if (json['code'].integer != 0 || json['subCode'].string != '0') {
      print('VIVO: ${json['msg']}');
      return;
    }

    print('APK上传成功');

    print('更新应用信息...');

    final serialNumber = json['data']['serialnumber'].stringValue;

    //应用更新
    final response = await post(
      method: 'app.sync.update.app',
      args: {
        'packageName': packageName,
        'versionCode': versionCode,
        'apk': serialNumber,
        'fileMd5': md5Code,
        'onlineType': 1, //1  实时上架 ；2  定时上架
        'updateDesc': updateDesc, //新版说明（长度要求，5~200个字符）
      },
    );

    print(response['msg'].stringValue);

    print('------------------------VIVO END----------------------');
  }

  ///
  /// 查询当前状态
  ///
  void query(String packageName) async {
    final json = await post(
      method: 'app.query.task.status',
      args: {
        'packageName': packageName,
        'packetType': 0,
      },
    );
    print('VIVO:');
    print(json['msg'].stringValue);
  }

  ///
  /// POST 请求
  ///
  Future<JSON> post({
    String method,
    Map<String, dynamic> args,
    MultipartFile file,
  }) async {
    ///公共参数
    final formMap = {
      'v': '1.0',
      'method': method,
      'target_app_key': 'developer',
      'sign_method': 'hmac',
      'access_key': _accessKey,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    //业务参数
    formMap.addAll(args);
    //签名参数
    formMap['sign'] = sign(formMap, _accessSecret);

    if (file != null) {
      formMap['file'] = file;
    }

    try {
      final response = await Dio().post(
        _serverUrl,
        data: FormData.fromMap(formMap),
      );
      return JSON.parse(response.toString());
    } on Exception catch (e) {
      print('VIVO: $method 请求失败！\n$e');
      return JSON.nil;
    }
  }

  ///
  /// 验签加密
  ///
  String sign(Map<String, dynamic> paramsMap, String secret) {
    // 第一步：参数排序
    final params = getUrlParamsFromMap(paramsMap);
    // 第二步：使用HMAC加密
    final key = utf8.encode(secret);
    final data = utf8.encode(params);
    return Hmac(sha256, key).convert(data).toString();
  }

  ///
  /// 按ascii码排序的参数键值对
  ///
  String getUrlParamsFromMap(Map<String, dynamic> paramsMap) {
    final keysList = paramsMap.keys.toList();
    keysList.sort();
    final paramList = <String>[];
    for (var key in keysList) {
      final value = paramsMap[key];
      paramList.add('$key=$value');
    }
    return paramList.join('&');
  }
}
