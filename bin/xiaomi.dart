import 'package:app_pub/markets/xiaomi_runner.dart';
import 'package:args/args.dart';

void main(List<String> arguments) {
  final argParser = ArgParser();
  argParser.addOption(
    'name',
    abbr: 'n',
    help: 'APP name in xiaomi market.',
  );
  argParser.addOption(
    'package',
    abbr: 'p',
    help: 'Package name of your APP.',
  );
  
  XiaomiRunner(argParser).run(arguments);
}
