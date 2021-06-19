import 'dart:io';

import 'package:app_pub/markets/huawei.dart';

void main(List<String> args) {
  if (args == null || args.length < 2) {
    printUsage();
    return;
  }

  final command = args[0];
  if (command == 'query') {
    final appId = args[1];
    huawei.query(appId);
    return;
  }

  if (command == 'publish') {
    if (args.length < 4) {
      printUsage();
      return;
    }
    final appId = args[1];
    final apk = args[2];
    final desc = args[3];

    if (!apk.endsWith('apk')) {
      printUsage();
    }
    huawei.update(File(apk), appId, desc);
  }
}

void printUsage() {
  print('''
    usage:
         huawei query <appId>
         huawei publish <appId> <apk> <desc>
    ''');
}
