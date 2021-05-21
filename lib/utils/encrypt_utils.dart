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
String RSAEncode(String text, String pubKey) {
  final key = pubKey.replaceAll('CERTIFICATE', 'RSA PUBLIC KEY');
  final publicKey = RSAKeyParser().parse(key) as RSAPublicKey;
  final encrypter = Encrypter(RSA(publicKey: publicKey));
  return encrypter.encrypt(text).base64;
}
