import 'dart:io';

import 'package:dio/dio.dart';
import 'package:g_json/g_json.dart';
import 'package:market/utils/configs.dart';

final huawei = _initHuawei();

Huawei _initHuawei() => Huawei._();

class Huawei {
  final _serverUrl = 'https://connect-api.cloud.huawei.com/api';
  var _token = '';
  Huawei._();

  Future update(File apk, String updateDesc) async {
    _token = await _getToken();
    if (_token == null || _token.isEmpty) {
      print('token 获取失败');
      return;
    }
    print('token: $_token');

    //获取上传地址
    final urlReply = await _getUploadUrl();
    if (urlReply['ret']['code'].integer != 0) {
      print(urlReply['ret']['msg'].stringValue);
      return;
    }
    final uploadUrl = urlReply['uploadUrl'].stringValue;
    final authCode = urlReply['authCode'].stringValue;
    //上传APK
    final apkReply = await _uploadApk(apk, uploadUrl, authCode);
    final ifSuccess = apkReply['UploadFileRsp']['ifSuccess'].integerValue == 1;
    print('huawei apk： 上传${ifSuccess ? '成功' : '失败'}');
    if (!ifSuccess) return;
    final fileInfoList = apkReply['UploadFileRsp']['fileInfoList'].listObject;
    //刷新APK
    final refreshReply = await _refreshApk(fileInfoList);
    if (refreshReply['ret']['code'].integer != 0) {
      print(refreshReply['ret']['msg'].stringValue);
      return;
    }
    //更新文案
    final descReply = await _updateInfo(updateDesc);
    if (descReply['ret']['code'].integer != 0) {
      print(descReply['ret']['msg'].stringValue);
      return;
    }
    final result = await _publish();
    print(result['msg'].stringValue);
  }

  ///
  /// 查询
  ///
  Future query() async {
    _token = await _getToken();
    if (_token == null || _token.isEmpty) {
      print('token 获取失败');
      return;
    }
    print('token: $_token');

    final json = await _request(
      method: 'get',
      path: '/publish/v2/app-info',
      params: {'lang': 'zh-CN'},
    );

    if (json['ret']['code'].integer != 0) {
      print(json['ret']['msg'].stringValue);
      return;
    }

    final states = {
      0: '已上架',
      1: '上架审核不通过',
      2: '已下架（含强制下架）',
      3: '待上架，预约上架',
      4: '审核中',
      5: '升级中',
      6: '申请下架',
      7: '草稿',
      8: '升级审核不通过',
      9: '下架审核不通过',
      10: '应用被开发者下架',
      11: '撤销上架',
    };
    final releaseState = json['appInfo']['releaseState'].integerValue;
    final auditOpinion = json['auditInfo']['auditOpinion'].stringValue;
    print(states[releaseState]);
    print(auditOpinion);
  }

  ///
  /// 获取Token
  ///
  Future<String> _getToken() async {
    final response = await Dio().post(
      '$_serverUrl/oauth2/v1/token',
      data: JSON({
        'client_id': configs.clientId,
        'client_secret': configs.clientSecret,
        'grant_type': 'client_credentials',
      }).rawString(),
    );
    final json = JSON.parse(response.toString());
    return json['access_token'].stringValue;
  }

  ///
  /// 获取上传文件地址
  ///
  Future<JSON> _getUploadUrl() async {
    return _request(
      method: 'get',
      path: '/publish/v2/upload-url',
      params: {'suffix': 'apk'},
    );
  }

  ///
  /// 上传APK
  ///
  Future<JSON> _uploadApk(File apk, String url, String authCode) async {
    final response = await Dio().post(
      url,
      data: FormData.fromMap({
        'authCode': authCode,
        'fileCount': 1,
        'file': MultipartFile.fromFileSync(apk.path),
      }),
    );
    return JSON.parse(response.toString());
  }

  ///
  /// 刷新应用文件信息
  ///
  Future<JSON> _refreshApk(List fileInfoList) async {
    return _request(
      method: 'put',
      path: '/publish/v2/app-file-info',
      data: {
        'fileType': 5,
        'files': fileInfoList,
      },
    );
  }

  ///
  ///更新文案
  ///
  Future<JSON> _updateInfo(String updateDesc) async {
    return _request(
      method: 'put',
      path: '/publish/v2/app-language-info',
      data: {'newFeatures': updateDesc},
    );
  }

  ///
  /// 提交发布
  ///
  Future<JSON> _publish() async {
    return _request(method: 'post', path: '/publish/v2/app-submit');
  }

  Future<JSON> _request({
    String method,
    String path,
    data,
    Map<String, dynamic> params,
  }) async {
    final response = await Dio().request(
      '$_serverUrl$path',
      data: data,
      queryParameters: {
        'appId': configs.appId,
        if (params != null) ...params,
      },
      options: Options(
        method: method,
        headers: {
          'client_id': configs.clientId,
          'Authorization': 'Bearer $_token',
        },
      ),
    );
    return JSON.parse(response.toString());
  }
}
