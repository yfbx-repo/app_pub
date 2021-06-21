import 'package:app_pub/markets/huawei_runner.dart';
import 'package:args/args.dart';

void main(List<String> arguments) {
  final argParser = ArgParser();
  argParser.addOption(
    'id',
    abbr: 'i',
    help: 'APP id in huawei market.',
  );
  HuaweiRunner(argParser).run(arguments);
}
