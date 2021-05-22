import 'package:market/markets/huawei.dart';
import 'package:market/markets/vivo.dart';
import 'package:market/markets/xiaomi.dart';

void main(List<String> args) {
  huawei.query();

  xiaomi.query('com.yuxiaor');

  vivo.query('com.yuxiaor');
}
