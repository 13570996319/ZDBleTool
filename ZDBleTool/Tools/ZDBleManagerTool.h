//
//  ZDBleManagerTool.h
//  ZDBleTool
//
//  Created by 徐伟新 on 2025/6/24.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ZDBleDataModelTool.h"
#import "NSString+zdTool.h"
#import "NSData+zdTool.h"
#import "NSObject+zdTool.h"

typedef void(^ZDBleScanDataChangeBlock)(NSArray * _Nullable scanDataArray);
typedef void(^ZDBleScanStartBlock)(void);
typedef void(^ZDBleScanStopBlock)(void);
typedef void(^ZDBleConnectSuccessBlock)(ZDBleDataModelTool * _Nonnull model);
typedef void(^ZDBleDisconnectBlock)(ZDBleDataModelTool * _Nonnull model);
typedef void(^ZDBleDataReceiveBlock)(ZDBleDataModelTool * _Nonnull model, NSString * _Nonnull data);

NS_ASSUME_NONNULL_BEGIN

@interface ZDBleManagerTool : NSObject
#pragma mark - 类方法
/// 单例方法
+ (instancetype)shareInstance;

#pragma mark - 实例方法
/// 初始方法，单例的时候要调用
- (void)initFunction;
/// 开始扫描
- (void)startScan;
/// 结束扫描
- (void)stopScan;
/// 蓝牙连接
- (void)bleConnectedWith:(ZDBleDataModelTool *)model;
/// 断开蓝牙
- (void)bleDisConnectedWith:(ZDBleDataModelTool *)model;
/// 已连接的设备发送协议
- (void)sendCommandWithHex:(NSString *)command;


/// 蓝牙断开
#pragma mark - 属性
/// 蓝牙中心设备
@property (nonatomic, strong) CBCentralManager *centerManager;
/// 扫描结果，要包括已经连接的设备
@property (nonatomic, strong) NSMutableArray <ZDBleDataModelTool *>*peripheralModelArray;
/// 在peripheralModelArray获取已经连接的设备数据对象
@property (nonatomic, strong) NSArray <ZDBleDataModelTool *>*connectedPeripheralArray;
/// 用以同步的数据模型,由connectedPeripheralArray中获取第一个对象，如果没有则创建一个对象
@property (nonatomic, strong) ZDBleDataModelTool *model;
/// 是否第一次扫描
@property (nonatomic, assign) BOOL isFirstScan;
/// 是否手动断开
@property (nonatomic, assign) BOOL isHandDisconnected;
/// 广播头判断返回对应的EQ模式数组
@property (nonatomic, strong) NSArray *eqModalNameArray;
@property (nonatomic, strong) NSString *gobalAdvString;
@property (nonatomic, assign) NSInteger f0CommandType;
@property (nonatomic, strong) NSArray *eqFrequencyNameArray;
/// 判断有多少CH通道
@property (nonatomic, assign) NSInteger moreEqChannelNumbers;



#pragma mark - block
@property (nonatomic, copy) ZDBleScanDataChangeBlock scanDataChangeBlock;
@property (nonatomic, copy) ZDBleScanStartBlock scanStartBlock;
@property (nonatomic, copy) ZDBleScanStopBlock scanStopBlock;
@property (nonatomic, copy) ZDBleConnectSuccessBlock connectSuccessBlock;
@property (nonatomic, copy) ZDBleDisconnectBlock disconnectBlock;
@property (nonatomic, copy) ZDBleDataReceiveBlock dataReceiveBlock;

@end

NS_ASSUME_NONNULL_END
