import 'dart:io';

import 'package:path/path.dart' as _path;

final env = _initEnv();

Env _initEnv() => Env._();

class Env {
  Env._();

  ///
  ///当前工作路径
  ///
  String get currentPath => '${_path.current}${_path.separator}';

  ///
  /// 配置文件是否存在
  ///
  bool get isConfigsExist {
    final file = File('${env.currentPath}configs.json');
    if (file.existsSync()) return true;
    print('"configs.json" is required to provide your platform private info');
    return false;
  }
}
