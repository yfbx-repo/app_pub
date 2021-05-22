import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';
import 'package:x509/x509.dart';

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
String RSAEncode(String text, String cert) {
  final x509Cert = parsePem(cert).first as X509Certificate;
  final publicKey = x509Cert.publicKey;
  final encrypter = publicKey.createEncrypter(algorithms.encryption.rsa.pkcs1);
  final encoded = encrypter.encrypt(utf8.encode(text)).data;
  return HEX.encode(encoded);
}
