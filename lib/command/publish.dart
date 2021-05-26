import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:market/markets/huawei.dart';
import 'package:market/markets/vivo.dart';
import 'package:market/markets/xiaomi.dart';
import 'package:market/utils/args_util.dart';
import 'package:market/utils/tools.dart';

class PublishCommand extends Command {
  @override
  String get description => 'publish app to app market';

  @override
  String get name => 'publish';

  PublishCommand() {
    setCommonArgs(argParser);
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
  }

  @override
  FutureOr<bool> run() {
    _runCommand();
    return true;
  }

  void _runCommand() {
    final args = argResults.arguments;
    if (args == null || args.isEmpty) {
      printUsage();
      return;
    }

    final onlyVivo = argResults.getBool('vivo');
    final onlyHuawei = argResults.getBool('huawei');
    final onlyXiaomi = argResults.getBool('xiaomi');
    final file = argResults.getString('file');
    final appId = argResults.getString('appId');
    final desc = argResults.getString('desc');
    final txt = argResults.getString('txt');

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
}
