import 'dart:io';

import 'package:app_pub/markets/xiaomi.dart';

void main(List<String> args) {
  if (args == null || args.length < 2) {
    printUsage();
    return;
  }

  final command = args[0];
  if (command == 'query') {
    final package = args[1];
    xiaomi.query(package);
    return;
  }

  if (command == 'publish') {
    if (args.length < 3) {
      printUsage();
      return;
    }
    final apk = args[1];
    final desc = args[2];

    if (!apk.endsWith('apk')) {
      printUsage();
    }
    xiaomi.update(File(apk), desc);
  }
}

void printUsage() {
  print('''
    usage:
         xiaomi query <package>
         xiaomi publish <apk> <desc>
    ''');
}
