# ZDBleTool 使用示例

本文档提供了 ZDBleTool SDK 的详细使用示例。

## 1. 基础设置

### 1.1 导入头文件

```objc
#import <ZDBleTool/ZDBleTool.h>
```

### 1.2 权限配置

在您的 `Info.plist` 中添加蓝牙权限：

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>此应用需要使用蓝牙功能来连接和管理蓝牙设备</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>此应用需要使用蓝牙功能来连接和管理蓝牙设备</string>
```

## 2. 蓝牙功能使用

### 2.1 初始化蓝牙管理器

```objc
// 获取蓝牙管理器单例
ZDBleManagerTool *bleManager = [ZDBleManagerTool shareInstance];

// 设置扫描回调
bleManager.scanDataChangeBlock = ^(NSArray *scanDataArray) {
    NSLog(@"扫描到 %lu 个设备", (unsigned long)scanDataArray.count);
    for (ZDBleDataModelTool *model in scanDataArray) {
        NSLog(@"设备: %@, 信号强度: %@", model.peripheral.name, model.peripheral.identifier.UUIDString);
    }
};

// 设置连接成功回调
bleManager.connectSuccessBlock = ^(ZDBleDataModelTool *model) {
    NSLog(@"连接成功: %@", model.peripheral.name);
    // 连接成功后可以发送数据
    [bleManager sendCommandWithHex:@"01020304"];
};

// 设置断开连接回调
bleManager.disconnectBlock = ^(ZDBleDataModelTool *model) {
    NSLog(@"设备断开: %@", model.peripheral.name);
};

// 设置数据接收回调
bleManager.dataReceiveBlock = ^(ZDBleDataModelTool *model, NSString *data) {
    NSLog(@"收到数据: %@", data);
    // 处理接收到的数据
};
```

### 2.2 扫描和连接设备

```objc
// 开始扫描
[bleManager startScan];

// 停止扫描
[bleManager stopScan];

// 连接指定设备
ZDBleDataModelTool *targetDevice = scanDataArray.firstObject;
[bleManager bleConnectedWith:targetDevice];

// 断开连接
[bleManager bleDisConnectedWith:targetDevice];
```

### 2.3 发送数据

```objc
// 发送十六进制数据
[bleManager sendCommandWithHex:@"01020304"];

// 发送字符串数据（需要先转换为十六进制）
NSString *message = @"Hello";
NSString *hexMessage = [message zd_hexStringFromString];
[bleManager sendCommandWithHex:hexMessage];
```

## 3. 进制转换工具

### 3.1 NSString 进制转换

```objc
// 数字转字符串
NSString *str1 = [NSString zd_stringFromNumber:123]; // @"123"
NSString *str2 = [NSString zd_hexStringFromNumber:255]; // @"ff"
NSString *str3 = [NSString zd_binaryStringFromNumber:10]; // @"00001010"

// 字符串转十六进制
NSString *normalStr = @"Hello";
NSString *hexStr = [normalStr zd_hexStringFromString]; // @"48656c6c6f"

// 十六进制转字符串
NSString *hexInput = @"48656c6c6f";
NSString *resultStr = [hexInput zd_stringFromHexString]; // @"Hello"

// 十六进制转十进制
NSString *decimalStr = [hexInput zd_decimalStringFromHexString]; // @"1214609263"
NSInteger decimalInt = [hexInput zd_integerFromHexString]; // 1214609263

// 十进制转十六进制
NSString *decimalInput = @"255";
NSString *hexResult = [decimalInput zd_hexStringFromDecimalString]; // @"ff"

// 指定位数的十六进制
NSString *hexWithBits = [decimalInput zd_hexStringFromDecimalStringWithBitNumber:4]; // @"00ff"
```

### 3.2 NSData 进制转换

```objc
// 创建测试数据
NSString *testString = @"Hello";
NSData *testData = [testString dataUsingEncoding:NSUTF8StringEncoding];

// NSData 转各种格式
NSString *hexString = [testData zd_hexString]; // @"48656c6c6f"
NSString *decimalString = [testData zd_decimalString]; // @"1214609263"
NSInteger decimalInteger = [testData zd_decimalInteger]; // 1214609263
NSString *binaryString = [testData zd_binaryString]; // 二进制字符串
```

### 3.3 字符串与 NSData 互转

```objc
// 字符串转 NSData
NSString *str = @"Hello";
NSData *data1 = [str zd_dataFromNormalString]; // UTF8编码的NSData
NSData *data2 = [str zd_dataFromHexString]; // 如果str是十六进制字符串

// NSData 转字符串
NSString *result1 = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
NSString *result2 = [data1 zd_hexString]; // 转十六进制字符串
```

## 4. UI 工具

### 4.1 获取当前窗口和控制器

```objc
// 获取当前窗口
UIWindow *window = [NSObject zd_currentWindow];

// 获取当前控制器
UIViewController *currentVC = [NSObject zd_currentViewController];

// 获取当前导航控制器
UINavigationController *navController = (UINavigationController *)[NSObject zd_currentViewController];
```

### 4.2 延时执行

```objc
// 延时2秒执行
[NSObject zd_delay:2.0 block:^{
    NSLog(@"2秒后执行");
    // 在这里执行需要延时的代码
}];

// 延时执行并更新UI
[NSObject zd_delay:1.0 block:^{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.label.text = @"延时更新";
    });
}];
```

### 4.3 文字尺寸计算

```objc
NSString *text = @"这是一段测试文字，用于计算高度和宽度";

// 计算文字高度
CGFloat height = [text zd_heightWithLineSpacing:5.0 
                                          font:[UIFont systemFontOfSize:16] 
                                          width:200];

// 计算文字宽度
CGFloat width = [text zd_widthWithFont:[UIFont systemFontOfSize:16] 
                                height:50];

NSLog(@"文字高度: %.2f, 宽度: %.2f", height, width);
```

## 5. 车机数据模型

### 5.1 创建车机数据模型

```objc
// 创建车机数据模型
ZDCommonCarMerchineData *carData = [[ZDCommonCarMerchineData alloc] init];

// 设置音量
carData.volumn = [[ZDBleCommonModelTool alloc] init];
carData.volumn.value = 50;
carData.volumn.maxValue = 100;
carData.volumn.minValue = 0;
carData.volumn.name = @"音量";

// 设置EQ模式
carData.eqModel = [[ZDBleCommonModelTool alloc] init];
carData.eqModel.name = @"流行";
carData.eqModel.number = 1;

// 设置电源状态
carData.power = [[ZDBleCommonModelTool alloc] init];
carData.power.power = YES; // 开启状态

// 设置播放状态
carData.playOrPause = [[ZDBleCommonModelTool alloc] init];
carData.playOrPause.name = @"播放";
```

### 5.2 多段EQ设置

```objc
// 创建四段EQ
NSMutableArray *normalEqArray = [NSMutableArray array];
for (int i = 0; i < 4; i++) {
    ZDBleCommonModelTool *eqModel = [[ZDBleCommonModelTool alloc] init];
    eqModel.name = [NSString stringWithFormat:@"EQ%d", i + 1];
    eqModel.value = 0;
    eqModel.maxValue = 12;
    eqModel.minValue = -12;
    eqModel.number = i;
    [normalEqArray addObject:eqModel];
}
carData.normalEqArray = [normalEqArray copy];

// 创建七段EQ
NSMutableArray *eqArray2001 = [NSMutableArray array];
for (int i = 0; i < 7; i++) {
    ZDBleCommonModelTool *eqModel = [[ZDBleCommonModelTool alloc] init];
    eqModel.name = [NSString stringWithFormat:@"7段EQ%d", i + 1];
    eqModel.value = 0;
    eqModel.maxValue = 12;
    eqModel.minValue = -12;
    eqModel.number = i;
    [eqArray2001 addObject:eqModel];
}
carData.eqArray2001 = [eqArray2001 copy];
```

## 6. 实际应用场景

### 6.1 蓝牙耳机控制

```objc
// 连接蓝牙耳机
ZDBleManagerTool *bleManager = [ZDBleManagerTool shareInstance];

bleManager.connectSuccessBlock = ^(ZDBleDataModelTool *model) {
    NSLog(@"耳机连接成功");
    
    // 播放音乐
    [bleManager sendCommandWithHex:@"01"];
    
    // 暂停音乐
    [bleManager sendCommandWithHex:@"02"];
    
    // 下一首
    [bleManager sendCommandWithHex:@"03"];
    
    // 上一首
    [bleManager sendCommandWithHex:@"04"];
    
    // 调节音量
    NSString *volumeHex = [NSString zd_hexStringFromNumber:80];
    [bleManager sendCommandWithHex:volumeHex];
};
```

### 6.2 车载设备控制

```objc
// 车载设备数据模型
ZDCommonCarMerchineData *carData = [[ZDCommonCarMerchineData alloc] init];

// 设置音量
carData.volumn.value = 60;
NSString *volumeCommand = [NSString zd_hexStringFromNumber:carData.volumn.value];
[bleManager sendCommandWithHex:volumeCommand];

// 设置EQ模式
carData.eqModel.number = 2; // 摇滚模式
NSString *eqCommand = [NSString zd_hexStringFromNumber:carData.eqModel.number];
[bleManager sendCommandWithHex:eqCommand];

// 设置电源
carData.power.power = YES;
NSString *powerCommand = carData.power.power ? @"01" : @"00";
[bleManager sendCommandWithHex:powerCommand];
```

## 7. 错误处理

### 7.1 蓝牙状态检查

```objc
// 检查蓝牙是否可用
if (bleManager.centerManager.state == CBManagerStatePoweredOn) {
    NSLog(@"蓝牙可用");
    [bleManager startScan];
} else {
    NSLog(@"蓝牙不可用，状态: %ld", (long)bleManager.centerManager.state);
    // 提示用户开启蓝牙
}
```

### 7.2 连接超时处理

```objc
// 设置连接超时
[NSObject zd_delay:10.0 block:^{
    if (!bleManager.model.bleIsConnected) {
        NSLog(@"连接超时");
        [bleManager stopScan];
        // 提示用户连接失败
    }
}];
```

## 8. 性能优化建议

1. **及时停止扫描**：连接成功后及时调用 `stopScan`
2. **合理使用延时**：避免在主线程中使用长时间延时
3. **内存管理**：注意循环引用，使用 `__weak` 修饰符
4. **数据缓存**：对于频繁使用的转换结果进行缓存

```objc
// 避免循环引用
__weak typeof(self) weakSelf = self;
bleManager.connectSuccessBlock = ^(ZDBleDataModelTool *model) {
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (strongSelf) {
        // 处理连接成功
    }
};
```

这个SDK提供了完整的蓝牙设备管理和数据转换功能，可以满足大多数蓝牙应用的需求。 