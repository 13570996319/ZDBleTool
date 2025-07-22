# ZDBleTool 部署指南

本文档提供了 ZDBleTool SDK 的完整部署流程和注意事项。

## 📋 部署前检查清单

在部署之前，请确保以下项目都已正确配置：

### ✅ 基础文件检查
- [ ] `ZDBleTool.podspec` 文件存在且配置正确
- [ ] `README.md` 文件包含完整的使用说明
- [ ] `LICENSE` 文件存在
- [ ] 所有源文件（.h 和 .m）都存在
- [ ] 测试文件存在

### ✅ 代码质量检查
- [ ] 所有头文件都有适当的 nullability 声明
- [ ] 代码没有编译警告
- [ ] 内存管理正确（ARC 模式）
- [ ] 没有循环引用问题

### ✅ 配置检查
- [ ] iOS 最低版本设置正确（iOS 12.0+）
- [ ] 依赖框架配置正确（CoreBluetooth, Foundation, UIKit）
- [ ] 权限声明配置正确
- [ ] 源文件路径配置正确

## 🚀 部署步骤

### 1. 代码审查

在部署之前，请进行以下代码审查：

```bash
# 运行部署检查脚本
./deploy_check.sh
```

确保所有检查项都通过。

### 2. 版本管理

```bash
# 确保代码已提交
git add .
git commit -m "准备发布版本 0.1.0"

# 创建版本标签
git tag 0.1.0

# 推送到远程仓库
git push origin main
git push origin 0.1.0
```

### 3. CocoaPods 验证

```bash
# 验证 podspec 文件
pod lib lint ZDBleTool.podspec --allow-warnings

# 如果验证通过，可以推送到 CocoaPods 官方仓库（可选）
pod trunk push ZDBleTool.podspec
```

### 4. 测试集成

在目标项目中测试集成：

```ruby
# Podfile
pod 'ZDBleTool', :git => 'https://github.com/13570996319/ZDBleTool.git', :tag => '0.1.0'
```

```bash
# 安装依赖
pod install
```

## 📱 集成到目标项目

### 1. 添加依赖

在目标项目的 `Podfile` 中添加：

```ruby
target 'YourApp' do
  use_frameworks!
  
  # 从 Git 仓库安装
  pod 'ZDBleTool', :git => 'https://github.com/13570996319/ZDBleTool.git', :tag => '0.1.0'
  
  # 或者等推送到 CocoaPods 官方后
  # pod 'ZDBleTool'
end
```

### 2. 安装依赖

```bash
pod install
```

### 3. 导入头文件

```objc
#import <ZDBleTool/ZDBleTool.h>
```

### 4. 配置权限

在 `Info.plist` 中添加蓝牙权限：

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>此应用需要使用蓝牙功能来连接和管理蓝牙设备</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>此应用需要使用蓝牙功能来连接和管理蓝牙设备</string>
```

## 🔧 常见问题解决

### 1. 编译错误

**问题**：找不到头文件
```
'Category/NSString+zdTool.h' file not found
```

**解决方案**：
- 检查 podspec 中的 `source_files` 配置
- 确保所有源文件都在正确的目录中
- 运行 `pod install` 重新安装

### 2. 链接错误

**问题**：找不到 CoreBluetooth 框架
```
Undefined symbols for architecture arm64: "_CBManagerStatePoweredOn"
```

**解决方案**：
- 确保在 podspec 中声明了 `CoreBluetooth` 框架
- 检查 iOS 最低版本设置

### 3. 权限问题

**问题**：蓝牙功能无法使用
```
Bluetooth is not available
```

**解决方案**：
- 检查 Info.plist 中的权限声明
- 确保用户已授权蓝牙权限
- 检查设备蓝牙是否开启

### 4. 版本兼容性

**问题**：iOS 版本兼容性警告
```
'CBManagerStatePoweredOn' is only available on iOS 10.0 or newer
```

**解决方案**：
- 将最低 iOS 版本设置为 12.0 或更高
- 使用 `@available` 检查进行版本适配

## 📊 性能监控

### 1. 内存使用

监控 SDK 的内存使用情况：

```objc
// 在适当的时候释放蓝牙管理器
ZDBleManagerTool *bleManager = [ZDBleManagerTool shareInstance];
[bleManager stopScan];
```

### 2. 电池消耗

蓝牙扫描会消耗电池，建议：

- 连接成功后及时停止扫描
- 设置合理的扫描间隔
- 在应用进入后台时停止扫描

### 3. 连接稳定性

监控连接状态：

```objc
bleManager.disconnectBlock = ^(ZDBleDataModelTool *model) {
    NSLog(@"连接断开，尝试重连");
    // 实现重连逻辑
};
```

## 🔄 版本更新

### 1. 版本号管理

遵循语义化版本控制：

- **主版本号**：不兼容的 API 修改
- **次版本号**：向下兼容的功能性新增
- **修订号**：向下兼容的问题修正

### 2. 更新流程

```bash
# 1. 更新版本号
# 修改 ZDBleTool.podspec 中的 version

# 2. 提交代码
git add .
git commit -m "更新到版本 0.1.1"

# 3. 创建新标签
git tag 0.1.1
git push origin 0.1.1

# 4. 更新 README 中的版本号
```

### 3. 向后兼容性

- 保持公共 API 的稳定性
- 添加新功能时使用新的方法名
- 废弃旧方法时使用 `__deprecated` 标记

## 📞 技术支持

如果在部署过程中遇到问题，请：

1. 查看 [Example.md](Example.md) 中的使用示例
2. 检查 [README.md](README.md) 中的常见问题
3. 运行 `./deploy_check.sh` 进行诊断
4. 提交 Issue 到 GitHub 仓库

## 📝 发布记录

### v0.1.0 (2025-01-XX)
- 初始版本发布
- 支持蓝牙设备管理
- 支持进制转换工具
- 支持 UI 工具
- 支持车机数据模型

---

**注意**：部署前请确保所有测试都通过，并在多个设备上进行充分测试。 