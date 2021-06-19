import 'package:app_pub/markets/huawei.dart';
import 'package:app_pub/markets/vivo.dart';
import 'package:app_pub/markets/xiaomi.dart';
import 'package:app_pub/utils/tools.dart';
import 'package:args/args.dart';

void main(List<String> args) {
  final argParser = ArgParser();
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

  final argResults = argParser.parse(args);
  final package = argResults.getString('package');
  final appId = argResults.getString('appId');

  if (args == null || args.isEmpty) {
    print(argParser.usage);
    return;
  }

  huawei.query(appId);
  xiaomi.query(package);
  vivo.query(package);
}
