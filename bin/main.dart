import 'dart:io';

import 'package:args/args.dart';
import 'package:market/markets/huawei.dart';
import 'package:market/markets/vivo.dart';
import 'package:market/markets/xiaomi.dart';
import 'package:market/utils/args_util.dart';
import 'package:market/utils/env.dart';
import 'package:market/utils/tools.dart';

void main(List<String> args) {
  final argParser = ArgParser();
  argParser.addCommand('publish', subCommand());
  argParser.addCommand('query');
  final result = argParser.parse(args);

  final help = result.getBool('help');
  final onlyVivo = result.getBool('vivo');
  final onlyHuawei = result.getBool('huawei');
  final onlyXiaomi = result.getBool('xiaomi');

  final file = result.getString('file');
  final desc = result.getString('desc');
  final txt = result.getString('txt');

  if (help == true) {
    print(argParser.usage);
    return;
  }

  if (!env.isConfigsExist) {
    return;
  }

  final apk = file.isEmpty ? findApkInCurrentDir() : File(file);
  if (!apk.existsSync()) {
    print('Apk file not found.Try to use "-f <file path>"');
    return;
  }

  final updateDesc = desc.isEmpty ? readFile('$txt') : '$desc';

  if (onlyVivo) {
    vivo.update(apk, updateDesc);
    return;
  }
  if (onlyHuawei) {
    huawei.update(apk, updateDesc);
    return;
  }
  if (onlyXiaomi) {
    xiaomi.update(apk, updateDesc);
    return;
  }

  //all
  update(apk, updateDesc);
}

void update(File apk, String updateDesc) async {
  print('\n--> huawei');
  await huawei.update(apk, updateDesc);
  print('\n--> vivo');
  await vivo.update(apk, updateDesc);
  print('\n--> xiaomi');
  await xiaomi.update(apk, updateDesc);
}

ArgParser subCommand() {
  final pubArgs = getCommonArgs();
  pubArgs.addFlag(
    'vivo',
    negatable: false,
    help: 'only publish to vivo market',
  );
  pubArgs.addFlag(
    'huawei',
    negatable: false,
    help: 'only publish to huawei market',
  );
  pubArgs.addFlag(
    'xiaomi',
    negatable: false,
    help: 'only publish to xiaomi market',
  );
  return pubArgs;
}
