import 'dart:io';

import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';
import 'package:market/utils/apk.dart';
import 'package:market/utils/configs.dart';
import 'package:market/utils/encrypt_util.dart';

final xiaomi = _initXiaomi();

Xiaomi _initXiaomi() => Xiaomi._();

class Xiaomi {
  final _serverUrl = 'http://api.developer.xiaomi.com/devupload';
  final _pubKey = configs.pubKey;
  final _password = configs.password;
  final _userName = configs.username;

  Xiaomi._();

  ///
  ///更新
  ///
  Future update(File apk, String updateDesc) async {
    final json = await post(
      method: '/dev/push',
      files: {'apk': apk},
      params: {
        'synchroType': 1,
        'userName': _userName,
        'appInfo': {
          'appName': apk.appName,
          'packageName': apk.packageName,
          'updateDesc': updateDesc,
        },
      },
    );

    print('''
    -----小米-----
    ${json.rawString()}
    ''');
  }

  ///
  /// 查询应用信息
  ///
  Future query(String packageName) async {
    final json = await post(method: '/dev/query', params: {
      'packageName': packageName,
      'userName': _userName,
    });

    print('''
    -----小米-----
    ${json['message'].stringValue}
    ''');
  }

  ///
  /// POST 请求
  ///
  Future<JSON> post({
    String method,
    Map<String, dynamic> params,
    Map<String, File> files,
  }) async {
    final formMap = <String, dynamic>{};
    //参数转json字符串
    final requestData = JSON(params).rawString();
    formMap['RequestData'] = requestData;

    //参数签名
    final sigs = [
      {'name': 'RequestData', 'hash': MD5(requestData)}
    ];

    //获取文件MD5值,并将文件转换为MultipartFile添加到参数中
    if (files != null && files.isNotEmpty) {
      files.forEach((key, value) {
        //读取文件
        final fileBytes = value.readAsBytesSync();
        //添加到参数中
        formMap[key] = MultipartFile.fromBytes(fileBytes);
        //获取MD5值
        sigs.add({'name': key, 'hash': fileMD5(fileBytes)});
      });
    }

    //组装加密参数
    final sign = JSON({'password': _password, 'sig': sigs});

    //将组装好的加密参数进行RSA加密，并添加到最终参数中
    formMap['SIG'] = encryptRSA(sign.rawString(), _pubKey);

    try {
      final response = await Dio().post(
        _serverUrl + method,
        data: FormData.fromMap(formMap),
      );
      return JSON.parse(response.toString());
    } on Exception catch (e) {
      print('Xiaomi: $method 请求失败！\n$e');
      return JSON.nil;
    }
  }
}
