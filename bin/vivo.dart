import 'package:app_pub/markets/vivo_runner.dart';
import 'package:args/args.dart';

void main(List<String> arguments) {
  final argParser = ArgParser();
  argParser.addOption(
    'version',
    abbr: 'v',
    help: 'APP version code.',
  );
  argParser.addOption(
    'package',
    abbr: 'p',
    help: 'Package name of your APP.',
  );
  VivoRunner(argParser).run(arguments);
}
