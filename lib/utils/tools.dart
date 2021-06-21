import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as _path;
import 'package:x509/x509.dart';

///
/// 在当前工作目录下查找APK文件
///
File findApkInCurrentDir() {
  return Directory('./')
      .listSync(
        recursive: false, //递归到子目录
        followLinks: false, //不包含链接
      )
      .firstWhere(
        (file) => _path.extension(file.path) == '.apk',
        orElse: () => null,
      );
}

String readFile(String path) {
  if (path == null || path.isEmpty) return '';
  final txtFile = File(path);
  if (txtFile.existsSync()) {
    return txtFile.readAsStringSync();
  }
  return '';
}

///
/// 文件MD5
///
String encryptMD5(List<int> data) {
  return md5.convert(data).toString();
}

///
/// RSA 加密
///
String x509RSA(String text, String cert) {
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
