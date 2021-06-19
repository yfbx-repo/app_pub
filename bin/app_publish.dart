import 'dart:io';

import 'package:app_pub/markets/huawei.dart';
import 'package:app_pub/markets/vivo.dart';
import 'package:app_pub/markets/xiaomi.dart';
import 'package:app_pub/utils/tools.dart';
import 'package:args/args.dart';

void main(List<String> args) {
  final argParser = ArgParser();
  argParser.addOption(
    'file',
    abbr: 'f',
    help: 'APK file path',
  );
  argParser.addOption(
    'appId',
    abbr: 'i',
    help: 'huawei app id',
  );
  argParser.addOption(
    'desc',
    abbr: 'd',
    help: 'Description of new features about this update',
  );
  argParser.addOption(
    'txt',
    abbr: 't',
    help: 'Description of new features about this update in txt file',
  );
  argParser.addFlag(
    'vivo',
    negatable: false,
    help: 'only publish to vivo market',
  );
  argParser.addFlag(
    'huawei',
    negatable: false,
    help: 'only publish to huawei market',
  );
  argParser.addFlag(
    'xiaomi',
    negatable: false,
    help: 'only publish to xiaomi market',
  );

  final argResults = argParser.parse(args);
  final onlyVivo = argResults.getBool('vivo');
  final onlyHuawei = argResults.getBool('huawei');
  final onlyXiaomi = argResults.getBool('xiaomi');
  final file = argResults.getString('file');
  final appId = argResults.getString('appId');
  final desc = argResults.getString('desc');
  final txt = argResults.getString('txt');

  if (args == null || args.isEmpty) {
    print(argParser.usage);
    return;
  }

  //check apk file
  final apk = file.isEmpty ? findApkInCurrentDir() : File(file);
  if (!apk.existsSync()) {
    print('Apk file not found.Try to use "-f <file path>"');
    return;
  }

  //check update desc
  final updateDesc = desc.isEmpty ? readFile('$txt') : '$desc';

  // publish to only one platform
  if (onlyVivo) {
    vivo.update(apk, updateDesc);
    return;
  }
  if (onlyHuawei) {
    huawei.update(apk, appId, updateDesc);
    return;
  }
  if (onlyXiaomi) {
    xiaomi.update(apk, updateDesc);
    return;
  }

  //publish to all platform
  updateAll(apk, appId, updateDesc);
}

void updateAll(File apk, String appId, String updateDesc) async {
  print('\n--> huawei');
  await huawei.update(apk, appId, updateDesc);
  print('\n--> vivo');
  await vivo.update(apk, updateDesc);
  print('\n--> xiaomi');
  await xiaomi.update(apk, updateDesc);
}
