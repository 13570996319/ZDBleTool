Pod::Spec.new do |s|
  s.name         = 'ZDBleTool'
  s.version      = '0.1.0'
  s.summary      = '蓝牙工具及字符串、NSData扩展'
  s.description  = <<-DESC
    ZDBleTool 是一个包含蓝牙工具、NSString 和 NSData 多种进制转换、UI便捷方法的 Objective-C 工具库。
  DESC
  s.homepage     = 'https://github.com/13570996319/ZDBleTool'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'xuweixin' => '13570996319@163.com' }
  s.source       = { :git => 'https://github.com/13570996319/ZDBleTool.git', :tag => s.version }
  s.platform     = :ios, '12.0'
  
  # 包含所有源文件
  s.source_files = 'ZDBleTool/**/*.{h,m}'
  s.public_header_files = 'ZDBleTool/**/*.h'
  
  # 依赖框架
  s.frameworks = 'CoreBluetooth', 'Foundation', 'UIKit'
  
  # 权限声明
  s.info_plist = {
    'NSBluetoothAlwaysUsageDescription' => '此应用需要使用蓝牙功能来连接和管理蓝牙设备',
    'NSBluetoothPeripheralUsageDescription' => '此应用需要使用蓝牙功能来连接和管理蓝牙设备'
  }
  
  s.requires_arc = true
  
  # 测试配置
  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'ZDBleToolTests/**/*.{h,m}'
    test_spec.frameworks = 'XCTest'
  end
end 