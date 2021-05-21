import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:g_json/g_json.dart';
import 'package:market/utils/configs.dart';

final xiaomi = _initXiaomi();

Xiaomi _initXiaomi() => Xiaomi._();

class Xiaomi {
  final _serverUrl = 'http://api.developer.xiaomi.com/devupload';
  final _pubKey = configs.pubKey;
  final _password = configs.password;
  final _userName = configs.username;

  Xiaomi._();

  ///
  /// 查询应用信息
  ///
  void query(String packageName) async {
    final json = await post(method: '/dev/query', args: {
      'packageName': packageName,
      'userName': _userName,
    });

    print(json['message'].stringValue);
  }

  ///
  /// POST 请求
  ///
  Future<JSON> post({
    String method,
    Map<String, dynamic> args, //参数为Json String
    Map<String, File> files,
  }) async {
    final sigs = [];
    //将每一个参数进行MD5加密
    args.forEach((key, value) {
      sigs.add({
        'name': key,
        'hash': md5.convert(utf8.encode(value)).toString(),
      });
    });

    //获取文件MD5值,并将文件转换为MultipartFile添加到参数中
    if (files != null && files.isNotEmpty) {
      files.forEach((key, value) {
        //读取文件
        final fileBytes = value.readAsBytesSync();
        //添加到参数中
        args[key] = MultipartFile.fromBytes(fileBytes);
        //获取MD5值
        sigs.add({
          'name': key,
          'hash': md5.convert(fileBytes).toString(),
        });
      });
    }

    //组装加密参数
    final sign = JSON({'password': _password, 'sig': sigs});

    //将组装好的加密参数进行RSA加密，并添加到最终参数中
    args['SIG'] = RSAEncode(sign.rawString(), _pubKey);

    try {
      final response = await Dio().post(
        _serverUrl + method,
        data: FormData.fromMap(args),
      );
      return JSON.parse(response.toString());
    } on Exception catch (e) {
      print('Xiaomi: $method 请求失败！\n$e');
      return JSON.nil;
    }
  }

  ///
  /// RSA 加密
  ///
  String RSAEncode(String text, String pubKey) {
    final publicKey = RSAKeyParser().parse(pubKey);
    final encrypter = Encrypter(RSA(publicKey: publicKey));
    return encrypter.encrypt(text).base64;
  }
}
