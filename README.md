# 一键发布APP到应用市场


目前支持VIVO、华为、小米（WIP:加密方法存在问题）.    
根据configs.dart自行配置各平台信息    


### 方式一  
1. 下载项目，修改配置，激活插件
```
pub global activate --source path ./
```

2. 运行脚本,测试命令
```
> app --help

Usage: app <command> [arguments]
...
Run "app help <command>" for more information about a command.
```
    
### 方式二
1. 生成可执行程序
```
> dart2native  bin\main.dart
```
windows下会在main.dart同级目录下生成 main.exe,文件名可修改    
其他系统可查看dart2native命令生成对应的可执行文件

2. 在可执行程序同级目录运行命令，或者配置环境变量    
```
> app --help

Usage: app <command> [arguments]
...
Run "app help <command>" for more information about a command.
```
如文件名为main.exe,则命令为`main --help`,如文件名为app_pub.exe,则命令为`app_pub --help`