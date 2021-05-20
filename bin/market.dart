import 'dart:io';

import 'package:market/markets/vivo.dart';

void main(List<String> arguments) {
  final apk = File('C:\\Users\\Administrator\\Desktop\\Yuxiaor_8.1.4_8622.apk');
  final updateDesc = '''
智能电表全面升级：
1. 支持一键绑定电表 (仅榉树品牌)
2. 允许远程管理，包括读表、通断电、设备解绑及更新集中器
3. 可配置电价、租客电费账户及充值
4. 方便查询用电、读表和充值等记录
''';

  vivo.update(apk, updateDesc);
}
