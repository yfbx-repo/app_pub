import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:market/markets/huawei.dart';
import 'package:market/markets/vivo.dart';
import 'package:market/markets/xiaomi.dart';
import 'package:market/utils/args_util.dart';

class QueryCommand extends Command {
  @override
  String get description => 'query app status';

  @override
  String get name => 'query';

  QueryCommand() {
    argParser.addOption(
      'package',
      abbr: 'p',
      help: 'package name of you app',
    );
    argParser.addOption(
      'appId',
      abbr: 'i',
      help: 'huawei app id',
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

    final package = argResults.getString('package');
    final appId = argResults.getString('appId');
    huawei.query(appId);
    xiaomi.query(package);
    vivo.query(package);
  }
}
