import 'dart:io';

import 'package:app_pub/markets/vivo.dart';

void main(List<String> args) {
  if (args == null || args.length < 2) {
    printUsage();
    return;
  }

  final command = args[0];
  if (command == 'query') {
    final package = args[1];
    vivo.query(package);
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
    vivo.update(File(apk), desc);
  }
}

void printUsage() {
  print('''
    usage:
         vivo query <package>
         vivo publish <apk> <desc>
    ''');
}
