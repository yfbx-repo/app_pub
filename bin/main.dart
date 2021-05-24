import 'package:args/command_runner.dart';
import 'package:market/command/publish.dart';
import 'package:market/command/query.dart';

void main(List<String> args) {
  final runner = CommandRunner('app', '');
  runner.addCommand(PublishCommand());
  runner.addCommand(QueryCommand());
  runner.run(args);
}
