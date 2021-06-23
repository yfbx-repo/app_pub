# 一键发布APP到应用市场


目前支持VIVO、华为、小米.    
根据configs.dart自行配置各平台信息    


## 使用方法：
1. 下载项目，修改配置，激活插件
```
pub global activate --source path ./
```

2. 运行脚本,测试命令：
```
# 查询app状态
> xiaomi -p <package name>
> vivo -p <package name>
> huawei -i <huawei appId>

# 发布
> xiaomi --publish <args>
> vivo --publish <args>
> huawei --publish <args>

```
    