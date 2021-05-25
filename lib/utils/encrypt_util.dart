import 'dart:convert';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
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
  final rows = cert.split(RegExp(r'\r\n?|\n'));
  final keyText = rows
      .skipWhile((row) => row.startsWith('-----BEGIN'))
      .takeWhile((row) => !row.startsWith('-----END'))
      .map((row) => row.trim())
      .join('');

  final keyBytes = Uint8List.fromList(base64.decode(keyText));
  final asn1Parser = ASN1Parser(keyBytes);

  final sequence = ASN1Sequence.fromBytes(asn1Parser.nextObject().encodedBytes);
  final s0 = sequence.elements[0].encodedBytes;
  final s1 = sequence.elements[1].encodedBytes;
  final modulus = ASN1Integer.fromBytes(s0).valueAsBigInteger;
  final exponent = ASN1Integer.fromBytes(s1).valueAsBigInteger;

  final publicKey = RSAPublicKey(modulus, exponent);

  return RSA(publicKey: publicKey).encrypt(utf8.encode(text)).base16;
}
