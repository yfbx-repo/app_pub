# 一键发布APP到应用市场


目前支持VIVO、华为、小米（WIP:加密方法存在问题）


### dart 插件  
1. 激活插件
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
    
### native 可执行程序  

```
# 在main.dart同级目录下生成 main.exe
> dart2native  bin\main.dart

# 也可以指定输出文件路径和文件名，或者手动修改文件名
> dart2native  bin\main.dart -o apk.exe
```

