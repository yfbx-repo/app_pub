import 'package:app_pub/markets/huawei.dart';
import 'package:app_pub/markets/vivo.dart';
import 'package:app_pub/markets/xiaomi.dart';

void main(List<String> args) {
  huawei.query('100354477');

  xiaomi.query('com.yuxiaor');

  vivo.query('com.yuxiaor');
}
