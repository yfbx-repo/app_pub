import 'dart:io';

import 'package:args/src/arg_parser.dart';
import 'package:market/markets/huawei.dart';
import 'package:market/markets/vivo.dart';
import 'package:market/markets/xiaomi.dart';
import 'package:market/utils/tools.dart';

import 'cmd_base.dart';

class PublishCommand extends BaseCmd {
  @override
  String get description => 'publish app to app market';

  @override
  String get name => 'publish';

  @override
  void buildArgs(ArgParser argParser) {
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
  }

  bool get onlyVivo => getBool('vivo');
  bool get onlyHuawei => getBool('huawei');
  bool get onlyXiaomi => getBool('xiaomi');
  String get file => getString('file');
  String get appId => getString('appId');
  String get desc => getString('desc');
  String get txt => getString('txt');

  @override
  void runCommand() {
    final args = argResults.arguments;
    if (args == null || args.isEmpty) {
      printUsage();
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
}
