# ZDBleTool

ZDBleTool 是一个 Objective-C 工具库，包含蓝牙相关工具、NSString 和 NSData 的多种进制转换、UI便捷方法等。

## 功能特色

- **蓝牙管理**：完整的蓝牙设备扫描、连接、数据收发功能
- **进制转换**：NSString 和 NSData 的十进制、十六进制、二进制互转
- **UI工具**：获取当前 UIWindow、UIViewController，延时执行方法
- **文字计算**：根据字体和尺寸计算文字高度/宽度
- **车机数据模型**：完整的车载设备数据模型支持

## 系统要求

- iOS 9.0+
- Xcode 12.0+
- Objective-C

## 安装

### CocoaPods

在您的 `Podfile` 中添加：

```ruby
pod 'ZDBleTool', :git => 'https://github.com/13570996319/ZDBleTool.git', :tag => '0.1.0'
```

然后运行：

```bash
pod install
```

### 手动安装

1. 下载项目源码
2. 将 `ZDBleTool` 文件夹拖入您的项目
3. 添加 `CoreBluetooth.framework` 依赖
4. 在 Info.plist 中添加蓝牙权限声明

## 权限配置

在您的 `Info.plist` 中添加以下权限：

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>此应用需要使用蓝牙功能来连接和管理蓝牙设备</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>此应用需要使用蓝牙功能来连接和管理蓝牙设备</string>
```

## 使用示例

### 1. 进制转换工具

```objc
#import <ZDBleTool/ZDBleTool.h>

// NSString 进制转换
NSString *hexStr = [NSString zd_hexStringFromNumber:255]; // @"ff"
NSString *binStr = [NSString zd_binaryStringFromNumber:10]; // @"00001010"
NSString *decStr = [NSString zd_stringFromNumber:123]; // @"123"

// 字符串与十六进制互转
NSString *normalStr = @"Hello";
NSString *hexFromStr = [normalStr zd_hexStringFromString]; // @"48656c6c6f"
NSString *strFromHex = [hexFromStr zd_stringFromHexString]; // @"Hello"

// NSData 进制转换
NSData *data = [@"Hello" dataUsingEncoding:NSUTF8StringEncoding];
NSString *hex = [data zd_hexString]; // @"48656c6c6f"
NSString *bin = [data zd_binaryString]; // 二进制字符串
```

### 2. 蓝牙管理

```objc
#import <ZDBleTool/ZDBleTool.h>

// 获取蓝牙管理器单例
ZDBleManagerTool *bleManager = [ZDBleManagerTool shareInstance];

// 设置回调
bleManager.scanDataChangeBlock = ^(NSArray *scanDataArray) {
    NSLog(@"扫描到设备：%@", scanDataArray);
};

bleManager.connectSuccessBlock = ^(ZDBleDataModelTool *model) {
    NSLog(@"连接成功：%@", model.peripheral.name);
};

bleManager.dataReceiveBlock = ^(ZDBleDataModelTool *model, NSString *data) {
    NSLog(@"收到数据：%@", data);
};

// 开始扫描
[bleManager startScan];

// 连接设备
ZDBleDataModelTool *deviceModel = scanDataArray.firstObject;
[bleManager bleConnectedWith:deviceModel];

// 发送数据
[bleManager sendCommandWithHex:@"01020304"];

// 断开连接
[bleManager bleDisConnectedWith:deviceModel];
```

### 3. UI工具

```objc
#import <ZDBleTool/ZDBleTool.h>

// 获取当前窗口和控制器
UIWindow *window = [NSObject zd_currentWindow];
UIViewController *vc = [NSObject zd_currentViewController];

// 延时执行
[NSObject zd_delay:2.0 block:^{
    NSLog(@"2秒后执行");
}];

// 文字尺寸计算
NSString *text = @"这是一段测试文字";
CGFloat height = [text zd_heightWithLineSpacing:5.0 
                                          font:[UIFont systemFontOfSize:16] 
                                          width:200];
CGFloat width = [text zd_widthWithFont:[UIFont systemFontOfSize:16] 
                                height:50];
```

### 4. 车机数据模型

```objc
#import <ZDBleTool/ZDBleTool.h>

// 创建车机数据模型
ZDCommonCarMerchineData *carData = [[ZDCommonCarMerchineData alloc] init];

// 设置音量
carData.volumn = [[ZDBleCommonModelTool alloc] init];
carData.volumn.value = 50;
carData.volumn.maxValue = 100;

// 设置EQ模式
carData.eqModel = [[ZDBleCommonModelTool alloc] init];
carData.eqModel.name = @"流行";
carData.eqModel.number = 1;
```

## API 文档

详细的API文档请参考项目中的头文件：

- `ZDBleManagerTool.h` - 蓝牙管理器
- `ZDBleDataModelTool.h` - 数据模型
- `NSString+zdTool.h` - 字符串工具
- `NSData+zdTool.h` - 数据工具
- `NSObject+zdTool.h` - 通用工具

## 详细使用示例

更多详细的使用示例请参考 [Example.md](Example.md) 文件，包含：

- 完整的蓝牙设备管理示例
- 进制转换工具使用示例
- UI工具使用示例
- 车机数据模型示例
- 实际应用场景示例
- 错误处理和性能优化建议

## 测试

运行测试：

```bash
# 使用 CocoaPods
pod lib lint ZDBleTool.podspec

# 运行单元测试
xcodebuild test -workspace ZDBleTool.xcworkspace -scheme ZDBleTool -destination 'platform=iOS Simulator,name=iPhone 14'
```

## 版本历史

- **0.1.0** - 初始版本，包含基础蓝牙功能和工具方法

## 贡献

欢迎提交 Issue 和 Pull Request！

## License

MIT License - 详见 [LICENSE](LICENSE) 文件 