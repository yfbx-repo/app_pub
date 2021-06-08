import 'dart:async';
import 'dart:io';

///
/// 执行命令，并实时打印输出
///
Future<void> shell(String command, String workDir) async {
  final process = await Process.start(
    command,
    [],
    workingDirectory: workDir,
    runInShell: true,
  );

  final completer = Completer();
  process.stdout.listen(
    (event) {
      print(String.fromCharCodes(event));
    },
    onDone: () => completer.complete(),
  );

  return completer.future;
}

///
/// 需要获取命令执行结果
///
ProcessResult runSync(String command, String workDir) {
  return Process.runSync(
    command,
    [],
    workingDirectory: workDir,
    runInShell: true,
  );
}
