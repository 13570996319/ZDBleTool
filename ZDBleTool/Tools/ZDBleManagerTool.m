//
//  ZDBleManagerTool.m
//  ZDBleTool
//
//  Created by 徐伟新 on 2025/6/24.
//

#import "ZDBleManagerTool.h"

@interface ZDBleManagerTool () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) NSDictionary *localUUIDS;


@end

@implementation ZDBleManagerTool

#pragma mark - 单例方法
+ (instancetype)shareInstance {
    static ZDBleManagerTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZDBleManagerTool alloc] init];
        [instance initFunction];
    });
    return instance;
}

#pragma mark - 懒加载属性
- (CBCentralManager *)centerManager {
    if (!_centerManager) {
        _centerManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return _centerManager;
}

- (NSMutableArray<ZDBleDataModelTool *> *)peripheraModelArray {
    if (!_peripheralModelArray) {
        _peripheralModelArray = [NSMutableArray array];
    }
    return _peripheralModelArray;
}

- (ZDBleDataModelTool *)model {
    if (!_model) {
        _model = [[ZDBleDataModelTool alloc] init];
    }
    return _model;
}

#pragma mark - 初始化
- (void)initFunction {
    self.isFirstScan = YES;
    self.isHandDisconnected = NO;
    [self centerManager];
    [self peripheraModelArray];
}

#pragma mark - 扫描相关
- (void)startScan {
    if (self.centerManager.state == CBManagerStatePoweredOn) {
        if (!self.centerManager.isScanning) {
            NSMutableArray *array = [NSMutableArray array];
            [array addObjectsFromArray:self.connectedPeripheralArray];
            [self.peripheralModelArray removeAllObjects];
            [self.peripheralModelArray addObjectsFromArray:array];
            if (self.scanStartBlock) {
                self.scanStartBlock();
            }
            [self.centerManager scanForPeripheralsWithServices:nil options:nil];
        }
    }
}

- (void)stopScan {
    if (self.centerManager.isScanning) {
        if (self.scanStopBlock) {
            self.scanStopBlock();
        }
        [self.centerManager stopScan];
    }
}

#pragma mark - 连接/断开
- (void)bleConnectedWith:(ZDBleDataModelTool *)model {
        
    if (model.peripheral) {
        if (model.isGroupConnected) {
            if (!model.bleIsConnected) {
                [self.centerManager connectPeripheral:model.peripheral options:nil];

            }
        }else {
            if (self.model.bleIsConnected) {
                
                if ([self.model.peripheral.identifier isEqual:model.peripheral.identifier]) {
                    
                }else {
                    [self bleDisConnectedWith:self.model];
                    [NSObject zd_delay:0.3 block:^{
                        if (!model.bleIsConnected) {
                            [self.centerManager connectPeripheral:model.peripheral options:nil];

                        }
                    }];
                }
                
            }else {
                if (!model.bleIsConnected) {
                    [self.centerManager connectPeripheral:model.peripheral options:nil];

                }
                
                
            }
            
            
        }
    }
}

- (void)bleDisConnectedWith:(ZDBleDataModelTool *)model {
    if (model.bleIsConnected) {
        self.isHandDisconnected = YES;
        [self.centerManager cancelPeripheralConnection:model.peripheral];
    }
}

#pragma mark - 发送指令
- (void)sendCommandWithHex:(NSString *)command {
    
    NSData *data = [command zd_dataFromHexString];
    for (ZDBleDataModelTool *model in self.connectedPeripheralArray) {
        for (CBCharacteristic *cha in model.writeChaArray) {
            if (model.chaUuid.length > 0) {
                if ([cha.UUID.UUIDString.uppercaseString isEqualToString:model.chaUuid]) {
                    if (cha.properties & CBCharacteristicPropertyWriteWithoutResponse) {
                        [model.peripheral writeValue:data forCharacteristic:cha type:CBCharacteristicWriteWithoutResponse];
                    }else {
                        [model.peripheral writeValue:data forCharacteristic:cha type:CBCharacteristicWriteWithResponse];

                    }
                }
            }else {
                if (cha.properties & CBCharacteristicPropertyWriteWithoutResponse) {
                    [model.peripheral writeValue:data forCharacteristic:cha type:CBCharacteristicWriteWithoutResponse];
                }else {
                    [model.peripheral writeValue:data forCharacteristic:cha type:CBCharacteristicWriteWithResponse];

                }
            }
            
        }
    }

}

#pragma mark - CBCentralManagerDelegate 示例
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state != CBManagerStatePoweredOn) {
        NSLog(@"蓝牙不可用");
    } else {
        [self startScan];
    }
}

- (void)centralManager:(CBCentralManager *)central
  didDiscoverPeripheral:(CBPeripheral *)peripheral
      advertisementData:(NSDictionary<NSString *,id> *)advertisementData
                   RSSI:(NSNumber *)RSSI
{
    // 1. 去重：判断peripheraModelArray里是否已存在该peripheral
    BOOL alreadyExist = NO;
    for (ZDBleDataModelTool *model in self.peripheraModelArray) {
        if ([model.peripheral.identifier isEqual:peripheral.identifier]) {
            alreadyExist = YES;
            break;
        }
    }
    if (alreadyExist) {
        return;
    }

    // 2. 新建数据模型，加入数组
    ZDBleDataModelTool *model = [[ZDBleDataModelTool alloc] init];
    model.peripheral = peripheral;
    if ([advertisementData.allKeys containsObject:@"kCBAdvDataManufacturerData"]) {
        NSData *advData = advertisementData[@"kCBAdvDataManufacturerData"];
        NSString *advHex = [advData zd_hexString];
        model.bleAdvHex = advHex;

    }
    
    [self.peripheraModelArray addObject:model];
    if (self.scanDataChangeBlock) {
        self.scanDataChangeBlock(self.peripheralModelArray);
    }

    // 3. 如果是第一次扫描，且发现是已连接过的设备，自动连接
    // 假设有isFirstScan和previouslyConnectedUUIDs属性
    if (self.isFirstScan) {
        if ([self.localUUIDS.allKeys containsObject:peripheral.identifier.UUIDString]) {
            self.isFirstScan = NO;
            [self bleConnectedWith:model];
        }

    }else {
        
        if (!self.isHandDisconnected) {
            if ([self.localUUIDS.allKeys containsObject:peripheral.identifier.UUIDString]) {
                [self bleConnectedWith:model];
            }
        }
        
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    ZDBleDataModelTool *model = [self getDataModelFromUUID:peripheral.identifier.UUIDString];
    self.isFirstScan = NO;
    self.isHandDisconnected = NO;
    [self updateLocalUUIDSWith:peripheral.identifier.UUIDString];
    [model.writeChaArray removeAllObjects];
    peripheral.delegate = self;
    
    [peripheral discoverServices:nil];
    
    [self stopScan];
    
    if (self.connectSuccessBlock) {
        self.connectSuccessBlock(model);
    }
    // 这里可以设置peripheral.delegate = self; 并发现服务
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    ZDBleDataModelTool *model = [self getDataModelFromUUID:peripheral.identifier.UUIDString];
    // 处理断开逻辑
    if (!self.isHandDisconnected) {
        [self bleConnectedWith:model];
    }
    
    if (self.disconnectBlock) {
        self.disconnectBlock(model);
    }
}

#pragma mark - 发现服务
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    for (CBService *service in peripheral.services) {
        NSLog(@"服务:%@\n",service);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

#pragma mark - 发现服务特征
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    NSLog(@"%@",service);
    ZDBleDataModelTool *model = [self getDataModelFromUUID:peripheral.identifier.UUIDString];

    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"%@",characteristic);
        if (characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse || characteristic.properties & CBCharacteristicPropertyWrite) {
            [model.writeChaArray addObject:characteristic];
        }
        if (characteristic.properties & CBCharacteristicPropertyNotify) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];

        }
        
    }

    
    
}

#pragma mark - 读取特征返回信息
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    ZDBleDataModelTool *model = [self getDataModelFromUUID:peripheral.identifier.UUIDString];
    NSData * data = characteristic.value;
    NSString *hexString = [data zd_hexString];
    
    NSLog(@"返回数据：%@",hexString);

    if (self.dataReceiveBlock) {
        self.dataReceiveBlock(model, hexString);
    }
}



#pragma mark - 工具方法

/// 获取已经连接的设备数组
- (NSArray<ZDBleDataModelTool *> *)connectedPeripheralArray {
    NSMutableArray *result = [NSMutableArray array];
    for (ZDBleDataModelTool *model in self.peripheraModelArray) {
        if (model.bleIsConnected) {
            [result addObject:model];
        }
    }
    return [result copy];
}

- (NSDictionary *)localUUIDS {
    
    NSString *key = @"ZDlocalBleDeviceUUIDS";
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:key]isKindOfClass:[NSDictionary class]]) {
        _localUUIDS = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    }else {
        _localUUIDS = [NSDictionary dictionary];
    }
    return _localUUIDS;
}

- (void)setGobalAdvString:(NSString *)gobalAdvString {
    if ([_gobalAdvString isEqualToString:gobalAdvString]) {
        return;
    }
    _gobalAdvString = gobalAdvString;
    if ([gobalAdvString containsString:@"5a44000203"] || [gobalAdvString containsString:@"5a44000204"] || [gobalAdvString containsString:@"5a4400020a"] || [gobalAdvString containsString:@"5a4400020b"] || [gobalAdvString containsString:@"5a4400740101"]) {
        /// normal,pop,rock,jazz,classic,user
        self.eqModalNameArray = @[@"正常",@"流行",@"摇滚",@"爵士",@"经典",@"用户"];
    }else if ([gobalAdvString containsString:@"5a44000207"]) {
        self.eqModalNameArray = @[@"正常",@"流行",@"摇滚",@"爵士",@"经典",@"乡村",@"用户"];
    }else if ([gobalAdvString containsString:@"5a4400020003"]) {
        /// normal,pop,rock,jazz,classic,country,vocal,club,user
        self.eqModalNameArray = @[@"正常",@"流行",@"摇滚",@"爵士",@"经典",@"乡村",@"人声",@"俱乐部",@"用户"];
    }else if ([gobalAdvString containsString:@"5a4400050101"]) {
        self.eqModalNameArray = @[@"正常",@"流行",@"摇滚",@"爵士",@"经典",@"乡村",@"广场场景",@"音乐会场"];

        /// CarLive(20段)    维科    0x5a4400050101    EQ（0-7）：NORMAL,POP,ROCK,JAZZ,CLASS,COUNTRY,STADIUM(广场场景),CONCERT(音乐会场)
    }else if ([gobalAdvString containsString:@"5a4400050101"]) {
        self.eqModalNameArray = @[@"正常",@"流行",@"摇滚",@"爵士",@"经典",@"乡村",@"广场场景",@"音乐会场"];

        /// CarLive(20段)    维科    0x5a4400050101    EQ（0-7）：NORMAL,POP,ROCK,JAZZ,CLASS,COUNTRY,STADIUM(广场场景),CONCERT(音乐会场)
    }else {
        
        self.eqModalNameArray = @[@"正常",@"流行",@"摇滚",@"爵士",@"经典",@"乡村",@"用户"];

    }
    
    if ([gobalAdvString containsString:@"5a44000203"] || [gobalAdvString containsString:@"5a44000204"] || [gobalAdvString containsString:@"5a4400020b"] || [gobalAdvString containsString:@"5a4400020d"] || [gobalAdvString containsString:@"5a44000210"]) {
        /// 完整10段
        self.eqFrequencyNameArray = @[@"60",@"100",@"160",@"300",@"600",@"1000",@"3000",@"5000",@"10000",@"150000"];
    }else if ([gobalAdvString containsString:@"5a4400010101"]) {
        /// 七段
        self.eqFrequencyNameArray = @[@"60",@"100",@"160",@"300",@"600",@"1000",@"3000"];

    }else if ([gobalAdvString containsString:@"5a44017f0101"]) {
        /// 八段
        self.eqFrequencyNameArray = @[@"60",@"100",@"160",@"300",@"600",@"1000",@"3000",@"5000"];
    }else if ([gobalAdvString containsString:@"5a44000205"] || [gobalAdvString containsString:@"5a44000206"] || [gobalAdvString containsString:@"5a44000208"] || [gobalAdvString containsString:@"5a4400020e"] || [gobalAdvString containsString:@"5a4400020f"] || [gobalAdvString containsString:@"5a4400050101"]) {
        /// 二十段
        self.eqFrequencyNameArray = @[@"50",@"80",@"100",@"125",@"200",@"315",@"500",@"630",@"800",@"1000",@"1250",@"2000",@"2500",@"3150",@"4000",@"5000",@"6300",@"8000",@"12500",@"16000"];
    }else if ([gobalAdvString containsString:@"5a4400020e"] || [gobalAdvString containsString:@"5a44000211"] || [gobalAdvString containsString:@"5a44000212"]) {
        /// 三十一段 @"30,50,63,80,90,100,120,140,160,200,250,315,400,500,600,700,800,1000,1250,2000,2500,3150,4000,5000,6000,7000,8000,10000,12500,14000,16000"
        self.eqFrequencyNameArray = @[@"30",@"50",@"63",@"80",@"90",@"100",@"120",@"140",@"160",@"200",@"250",@"315",@"400",@"500",@"600",@"700",@"800",@"1000",@"1250",@"2000",@"2500",@"3150",@"4000",@"5000",@"6000",@"7000",@"8000",@"10000",@"12500",@"14000",@"16000"];

        
    }else {
        
        NSString *advTypeHexString = [gobalAdvString zd_substringWithRange:NSMakeRange(8, 4)];
        NSInteger advType = [advTypeHexString zd_integerFromHexString];
        if (advType == 1) {
            /// 七段
            self.eqFrequencyNameArray = @[@"60",@"330",@"630",@"1000",@"3000",@"6000",@"10000"];
        }else if (advType == 2) {
            self.eqFrequencyNameArray = @[@"50",@"80",@"100",@"125",@"200",@"315",@"500",@"630",@"800",@"1000",@"1250",@"2000",@"2500",@"3150",@"4000",@"5000",@"6300",@"8000",@"12500",@"16000"];

        }else if (advType == 3) {
            /// 完整10段
            self.eqFrequencyNameArray = @[@"60",@"100",@"160",@"300",@"600",@"1000",@"3000",@"5000",@"10000",@"150000"];
        }else if (advType == 5) {
            /// 31duan @"20,25,31,40,50,63,80,100,125,160,200,250,315,400,500,630,800,1000,1250,1600,2000,2500,3150,4000,5000,6300,8000,10000,12500,16000,20000"
            self.eqFrequencyNameArray = @[@"20",@"25",@"31",@"40",@"50",@"63",@"80",@"100",@"125",@"160",@"200",@"250",@"315",@"400",@"500",@"630",@"800",@"1000",@"1250",@"1600",@"2000",@"2500",@"3150",@"4000",@"5000",@"6300",@"8000",@"10000",@"12500",@"16000",@"20000"];

        }else {
            /// 完整10段
            self.eqFrequencyNameArray = @[@"60",@"100",@"160",@"300",@"600",@"1000",@"3000",@"5000",@"10000",@"150000"];
            
        }
        
        
        
    }
    
    
}

- (void)setF0CommandType:(NSInteger)f0CommandType {
    _f0CommandType = f0CommandType;
    if (f0CommandType == 1) {
        /// 七段
        self.eqFrequencyNameArray = @[@"60",@"330",@"630",@"1000",@"3000",@"6000",@"10000"];

    }else if (f0CommandType == 2) {
        /// 十三段
    }else if (f0CommandType == 3) {
        /// 二十段
        self.eqFrequencyNameArray = @[@"50",@"80",@"100",@"125",@"200",@"315",@"500",@"630",@"800",@"1000",@"1250",@"2000",@"2500",@"3150",@"4000",@"5000",@"6300",@"8000",@"12500",@"16000"];
        self.moreEqChannelNumbers = 5;
    }else if (f0CommandType == 4) {
        
    }else if (f0CommandType == 5) {
        
    }else if (f0CommandType == 6) {
        
    }else if (f0CommandType == 7) {
        
    }else if (f0CommandType == 8) {
        
    }
}
/**
 0x0(普通版本)
 0x1(七段DSP版本)
 0x2(DSP 13段EQ)
 0x3(Channel 5 增益0~44)
 0x4(是否有定位)
 0x5(Channel 5增益0~32)
 0x6(Channel 6)
 0x7(10段EQ)
 0x08（普通EQ）
 
 */

/**
 车载DSP遥控器    天域    0x5a44000203(无USB)    十段EQ    EQ(0-5):normal,pop,rock,jazz,classic,user
         0x5a44000204(有USB)    十段EQ
         0x5a44000205(6通道)    二十段EQ
         0x5a44000206(4通道)    二十段EQ
         0x5a44000207    三十一段EQ    EQ(0-6):normal,pop,rock,jazz,classic,country,user
         0x5a44000208(6通道+BT模式)    二十段EQ
         0x5a44000209(4通道+BT模式)    二十段EQ
         0x5a4400020a(有BT模式)    十段EQ    EQ(0-5):normal,pop,rock,jazz,classic,user
         0x5a4400020b(无USB,无BT模式,有风扇开关)    十段EQ
         0x5a4400020c    高通滤波器
         0x5a4400020d    十段EQ+高通滤波器    BY777两个旋钮
         0x5a4400020e(6通道+有风扇开关)    二十段EQ
         0x5a4400020f(4通道+有风扇开关)    二十段EQ
         0x5a44000210    十段EQ+CH1/CH2通道    BL一个旋钮
         0x5a44000211(6通道+有风扇开关)    31段EQ
         0x5a44000212(4通道+有风扇开关)    31段EQ
 车载收放机遥控（14段+前后，正常模式外不能调节EQ)    天域    0x5a4400020001    14+2车机
 车载收放机遥控（14段+前后，任何模式都能调节EQ)    天域    0x5a4400020002    14+2车机
 车载收放机遥控（40段)    天域    0x5a4400020003    DSP车机    EQ(0-8):normal,pop,rock,jazz,classic,country,vocal,club,user
 摩托车遥控器    天域    0x5a44000213（没有AUX声音选择）
         0x5a44000214（有AUX声音选择）
         0x5a44000215（TY-ZXD-6602-BLE-百分80-5BF9D1ED）
 邦贝摇摇椅    邦贝    0x5a(Z)    0x44(D)    0001（客户编号）        0x01机型    01(01车机，02灯类，03摇椅,04卷闸门,05化妆镜，06摩托车防盗器)    Mac地址
         0x5a(Z)    0x44(D)    0x00    0x4c    0x01（无动感，无声控）    0x03
         0x5a(Z)    0x44(D)    0x00    0x4c    0x02（有动感，无声控）    0x03
         0x5a(Z)    0x44(D)    0x00    0x4c    0x03（有声控，无动感）    0x03
 iLamp    国正    0x5a(Z)    0x44(D)    0x00    0x66    0x00    0x01
 iLamp    普声    0x5a(Z)    0x44(D)    0x00    0x16    0x00    0x01
 "CarLive（7段+前后)
 (TBE）"    中道    0x5a4400010101
 CarLive（8段+前后)    欣创益/盛欣益    0x5a44017f0101
 DR手机开门    东荣    0x5a(Z)    0x44(D)    0x01    0xc1    0x01    0x04
 中道化妆镜    中道    0x5a    0x44    0x00    0x01    0x00    0x05
 iLamp(摩托车 5a0c)    音业    0x5a    0x44    0x00    0x0c    0x01    0x06
 iLamp(摩托车 5a0b)    车利宝    0x5a    0x44    0x00    0x0B    0x01    0x06
 iLamp(荣浩DSP)    荣浩    0x5a    0x44    0x00    0x31    0x00    0x01
 iLamp(乐港)    荣浩    0x5a    0x44    0x00    0x79    0x00    0x01
 iLamp(东鸿鑫DSP)    东鸿鑫    0x5a    0x44    0x00    0xCF    0x00    0x01
 iLamp(稀美)    稀美    0x5a    0x44    0x00    0xa7    0x00    0x01
 ilamp    恒能（BLE单连测试）    0x5a    0x44    0x03    0x78    0x00    0x01
 media-link    俊量    0x5a    0x44    0x00    0x74    0x01    0x01    EQ(0-5):normal,pop,rock,jazz,classic,country
 CarLive(20段)    维科    0x5a    0x44    0x00    0x05    0x01    0x01    EQ（0-7）：NORMAL,POP,ROCK,JAZZ,CLASS,COUNTRY,STADIUM(广场场景),CONCERT(音乐会场)
 CarLive    维科    0x5a    0x44    0x00    0x05    0x02    0x01    RGB（1-9）：RED,GREEN,BLUE,YELLOW,CYAN,PURPLE,WHITE,AUTO,ORANGE
 
 
 */


- (void)updateLocalUUIDSWith:(NSString *)uuids {
    NSString *key = @"ZDlocalBleDeviceUUIDS";
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.localUUIDS];
    ZDBleDataModelTool *model = [self getDataModelFromUUID:uuids];
    if (model.bleAdvHex.length > 0) {
        [dic setObject:model.bleAdvHex forKey:key];
    }else {
        [dic setObject:@"123456" forKey:key];
    }
    [[NSUserDefaults standardUserDefaults]setObject:dic forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

- (ZDBleDataModelTool *)getDataModelFromUUID:(NSString *)uuid {
    ZDBleDataModelTool *model = [[ZDBleDataModelTool alloc]init];
    for (ZDBleDataModelTool *sModel in self.peripheralModelArray) {
        if ([sModel.peripheral.identifier.UUIDString isEqualToString:uuid]) {
            model = sModel;
            break;
        }
    }
    return model;
    
    
}

@end
