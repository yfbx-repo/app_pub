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
  argParser.addCommand('publish', publishCommand());
  argParser.addCommand('query', queryCommand());
  argParser.addFlag(
    'help',
    abbr: 'h',
    negatable: false,
    help: 'Print this usage information',
  );
  final result = argParser.parse(args);
  final cmd = result.command;

  final help = cmd.getBool('help');
  final onlyVivo = cmd.getBool('vivo');
  final onlyHuawei = cmd.getBool('huawei');
  final onlyXiaomi = cmd.getBool('xiaomi');
  final file = cmd.getString('file');
  final desc = cmd.getString('desc');
  final txt = cmd.getString('txt');
  final package = cmd.getString('package');

  //print help info
  if (help == true) {
    print(argParser.usage);
    return;
  }

  //check configs
  if (!env.isConfigsExist) {
    return;
  }

  //query command
  if (cmd.name == 'query') {
    huawei.query();
    xiaomi.query(package);
    vivo.query(package);
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
    huawei.update(apk, updateDesc);
    return;
  }
  if (onlyXiaomi) {
    xiaomi.update(apk, updateDesc);
    return;
  }

  //publish to all platform
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

ArgParser publishCommand() {
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

ArgParser queryCommand() {
  final argParser = ArgParser();
  argParser.addOption(
    'package',
    abbr: 'p',
    help: 'package name of you app',
  );
  return argParser;
}
