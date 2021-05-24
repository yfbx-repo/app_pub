import 'dart:io';

import 'package:args/args.dart';
import 'package:market/markets/huawei.dart';
import 'package:market/utils/args_util.dart';
import 'package:market/utils/env.dart';
import 'package:market/utils/tools.dart';

void main(List<String> args) {
  final argParser = ArgParser();
  setCommonArgs(argParser);
  final result = argParser.parse(args);
  final help = result.getBool('help');
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

  huawei.update(apk, updateDesc);
}
