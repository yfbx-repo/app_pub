import 'dart:convert';

import 'package:crypto/crypto.dart';
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
String encryptRSA(String text, String cert) {
  final x509 = parsePem(cert).first as X509Certificate;
  final publicKey = x509.publicKey;
  final encrypter = publicKey.createEncrypter(algorithms.encryption.rsa.pkcs1);

  final data = utf8.encode(text);

  final result = <String>[];
  final size = 10;
  final groupSize = (data.length / size).ceil();
  for (var i = 0; i < groupSize; i++) {
    var start = i * size;
    var end = (i + 1) * size;
    end = end <= data.length ? end : data.length;
    final group = data.sublist(start, end);
    final encoded = encrypter.encrypt(group).data;
    final hex = encoded.map((e) => e.toRadixString(16).padLeft(2, '0')).join();
    result.add(hex);
  }

  return result.join();
}
