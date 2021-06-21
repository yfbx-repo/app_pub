import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as _path;

import '../base_runner.dart';
import '../utils/configs.dart';
import '../utils/tools.dart';

class XiaomiRunner extends BaseRunner {
  final _serverUrl = 'http://api.developer.xiaomi.com/devupload';
  final _pubKey = configs.pubKey;
  final _password = configs.password;
  final _userName = configs.username;

  XiaomiRunner(ArgParser parser) : super(parser);

  @override
  void runCommand() {
    if (package.isEmpty) {
      print('Error: package name is required!');
      printUsage();
    }

    ///query
    if (!publish) {
      query(package);
      return;
    }

    /// publish
    if (name.isEmpty) {
      print('Error: APP name is required!');
      printUsage();
      return;
    }

    if (isArgsValid()) {
      update(File(apk), name, package, updateDesc);
    }
  }

  ///
  ///更新
  ///
  Future update(
    File apk,
    String appName,
    String package,
    String updateDesc,
  ) async {
    final json = await post(
      method: '/dev/push',
      apk: apk,
      params: {
        'userName': _userName,
        'synchroType': 1,
        'appInfo': {
          'appName': appName,
          'packageName': package,
          'updateDesc': updateDesc,
        },
      },
    );

    print('''
    -----小米-----
    ${json['message'].stringValue}
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
    message：${json['message'].stringValue}
    versionName: ${json['packageInfo']['versionName'].stringValue}
    是否允许版本更新: ${json['updateVersion'].stringValue}
    ''');
  }

  ///
  /// POST 请求
  ///
  Future<JSON> post({
    String method,
    Map<String, dynamic> params,
    File apk,
  }) async {
    final formMap = <String, dynamic>{};
    final sigs = [];

    //参数转json字符串
    final requestData = JSON(params).rawString();
    formMap['RequestData'] = requestData;
    sigs.add({
      'name': 'RequestData',
      'hash': encryptMD5(utf8.encode(requestData)),
    });

    //APK
    if (apk != null) {
      final fileBytes = apk.readAsBytesSync();
      formMap['apk'] = MultipartFile.fromBytes(
        fileBytes,
        filename: _path.basename(apk.path),
        contentType: MediaType.parse('application/octet-stream'),
      );
      sigs.add({'name': 'apk', 'hash': encryptMD5(fileBytes)});
    }

    //组装加密参数
    final sign = JSON({'password': _password, 'sig': sigs});

    //将组装好的加密参数进行RSA加密，并添加到最终参数中
    formMap['SIG'] = x509RSA(sign.rawString(), _pubKey);

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
