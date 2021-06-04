import 'package:args/src/arg_parser.dart';

import '../command/cmd_base.dart';
import '../markets/huawei.dart';
import '../markets/vivo.dart';
import '../markets/xiaomi.dart';

class QueryCommand extends BaseCmd {
  @override
  String get description => 'query app status';

  @override
  String get name => 'query';

  @override
  void buildArgs(ArgParser argParser) {
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

  String get package => getString('package');
  String get appId => getString('appId');

  @override
  void runCommand() {
    final args = argResults.arguments;
    if (args == null || args.isEmpty) {
      printUsage();
      return;
    }

    huawei.query(appId);
    xiaomi.query(package);
    vivo.query(package);
  }
}
