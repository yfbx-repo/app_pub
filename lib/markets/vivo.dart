//测试环境

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';
import 'package:path/path.dart' as _path;

import '../utils/apk_file.dart';
import '../utils/configs.dart';
import '../utils/encrypt_util.dart';

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
  Future update(File apk, String updateDesc) async {
    final apkName = _path.basename(apk.path);
    final filePart = await MultipartFile.fromFile(apk.path, filename: apkName);
    print('获取文件MD5:');
    final md5Code = fileMD5(apk.readAsBytesSync());
    print(md5Code);
    print('解析Package信息:');
    final pkgInfo = apk.packageInfo;
    final packageName = pkgInfo['packageName'];
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
  }

  ///
  /// 查询当前状态
  ///
  Future query(String packageName) async {
    final json = await post(
      method: 'app.query.details',
      args: {'packageName': packageName},
    );

    if (json['code'].integer != 0 || json['subCode'].string != '0') {
      print('''
    -----VIVO-----
    查询失败：${json['msg'].stringValue}
    ''');
      return;
    }
    final saleStatus = json['data']['saleStatus'].integerValue;
    final status = json['data']['status'].integerValue;
    final unPassReason = json['data']['unPassReason'].stringValue;

    print('''
    -----VIVO-----
    上架状态：${getSaleStatus(saleStatus)}
    审核状态：${getStatus(status)}
    审核意见：$unPassReason
    ''');
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

  String getStatus(int status) {
    switch (status) {
      case 1:
        return '草稿';
      case 2:
        return '待审核';
      case 3:
        return '审核通过';
      case 4:
        return '审核不通过';
      default:
        return '';
    }
  }

  String getSaleStatus(int status) {
    switch (status) {
      case 0:
        return '待上架';
      case 1:
        return '已上架';
      case 2:
        return '已下架';
      default:
        return '';
    }
  }
}
