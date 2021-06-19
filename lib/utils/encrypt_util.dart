import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';

///
/// 字符串MD5
///
String MD5(String text) {
  return md5.convert(utf8.encode(text)).toString();
}

///
/// 文件MD5
///
String fileMD5(List<int> data) {
  return md5.convert(data).toString();
}

///
/// RSA 加密
///
String encryptRSA(String text, String cert) {
  //先用java解析出x509 证书信息
  final modulus = BigInt.parse(
      '135090026948590332353610241808864827515542187405730679816726960995419071353097731519215612833191591843890664799534377711916226218650242911169283411202905621747116733474585832634831329600663013807934341865448703861683642843895034752118635000167468166695509661594261904306880905769297928159391608493244522466941');
  final exponent = BigInt.parse('65537');
  final publicKey = RSAPublicKey(modulus, exponent);
  final rsa = RSA(publicKey: publicKey);
  final data = utf8.encode(text);

  final result = <String>[];
  final size = 10;
  final groupSize = (data.length / size).ceil();
  for (var i = 0; i < groupSize; i++) {
    var start = i * size;
    var end = (i + 1) * size;
    end = end <= data.length ? end : data.length;
    final group = data.sublist(start, end);
    result.add(rsa.encrypt(group).base16);
  }

  return result.join();
}
