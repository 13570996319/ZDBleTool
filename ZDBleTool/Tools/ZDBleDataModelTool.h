//
//  ZDBleDataModelTool.h
//  ZDBleTool
//
//  Created by 徐伟新 on 2025/6/24.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "NSString+zdTool.h"

@class ZDBleCommonModelTool;
@class ZDCommonCarMerchineData;
@class ZDBleCommonMoreEqData;
@class ZDBleCommonChannelData;
@class ZDBleCommonChannelFrequencyData;
NS_ASSUME_NONNULL_BEGIN

@interface ZDBleDataModelTool : NSObject
/// 蓝牙设备
@property (nonatomic, strong) CBPeripheral *peripheral;
/// 写的特征通道
@property (nonatomic, strong) NSMutableArray *writeChaArray;
/// 设备的16进制广播信息
@property (nonatomic, strong) NSString *bleAdvHex;
/// 蓝牙是否已连接
@property (nonatomic, assign) BOOL bleIsConnected;
/// 蓝牙是否允许发送信息
@property (nonatomic, assign) BOOL isCanSend;
/// 蓝牙设备是否允许多连
@property (nonatomic, assign) BOOL isGroupConnected;
/// 指定写的蓝牙特征
@property (nonatomic, strong) NSString *chaUuid;
@property (nonatomic, strong) ZDCommonCarMerchineData *carMerchine;
@end


@interface ZDBleCommonModelTool : NSObject
@property (nonatomic, strong) NSArray *advTagArray;
@property (nonatomic, assign) BOOL power;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSInteger maxValue;
@property (nonatomic, assign) NSInteger minValue;
@property (nonatomic, assign) NSInteger progressValue;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger number;
@end



@interface ZDCommonCarMerchineData : NSObject
/// 开关
@property (nonatomic, strong) ZDBleCommonModelTool *power;
/// 播放/暂停状态
@property (nonatomic, strong) ZDBleCommonModelTool *playOrPause;
/// 风扇开关
@property (nonatomic, strong) ZDBleCommonModelTool *fanPower;
/// loud开关
@property (nonatomic, strong) ZDBleCommonModelTool *loud;
/// 车机模式
@property (nonatomic, strong) ZDBleCommonModelTool *carModel;
/// mute状态与开关
@property (nonatomic, strong) ZDBleCommonModelTool *mute;
@property (nonatomic, strong) ZDBleCommonModelTool *bas;
@property (nonatomic, strong) ZDBleCommonModelTool *tre;
@property (nonatomic, strong) ZDBleCommonModelTool *bal;
@property (nonatomic, strong) ZDBleCommonModelTool *fad;
/// EQ模式
@property (nonatomic, strong) ZDBleCommonModelTool *eqModel;
/// 当前FM/AM频率
@property (nonatomic, strong) ZDBleCommonModelTool *currentFm;
/// 当前FM台号 1~3为FM，4~5为AM
@property (nonatomic, strong) ZDBleCommonModelTool *currentFmBandNumber;
/// 音量
@property (nonatomic, strong) ZDBleCommonModelTool *volumn;
/// 按键背景颜色
@property (nonatomic, strong) ZDBleCommonModelTool *btnRgb;
/// 车机屏幕颜色
@property (nonatomic, strong) ZDBleCommonModelTool *screenRgb;
/// dab频率
@property (nonatomic, strong) ZDBleCommonModelTool *dabFreuency;
/// dab台号
@property (nonatomic, strong) ZDBleCommonModelTool *dabPlatNum;
/// dab信息
@property (nonatomic, strong) ZDBleCommonModelTool *dabMsg;
/// 四段EQ
@property (nonatomic, strong) NSArray <ZDBleCommonModelTool *>*normalEqArray;
/// 七段EQ
@property (nonatomic, strong) NSArray <ZDBleCommonModelTool *>*eqArray2001;
/// 十段EQ
@property (nonatomic, strong) NSArray <ZDBleCommonModelTool *>*eqArray0a;
/// 三十一段EQ
@property (nonatomic, strong) NSArray <ZDBleCommonMoreEqData *>*eqArray89;
@property (nonatomic, strong) NSArray <ZDBleCommonMoreEqData *>*channelArray89;

/// 三十一段EQ
@property (nonatomic, strong) NSArray <ZDBleCommonMoreEqData *>*eqArrayaa;
@property (nonatomic, strong) NSArray <ZDBleCommonMoreEqData *>*channelArrayaa;


@end


@interface ZDBleCommonMoreEqData : NSObject
/// gain
@property (nonatomic, strong) ZDBleCommonModelTool *gain;
/// Q值
@property (nonatomic, strong) ZDBleCommonModelTool *qValue;
/// FRE值
@property (nonatomic, strong) ZDBleCommonModelTool *frequency;
/// number
@property (nonatomic, assign) NSInteger number;

@end


@interface ZDBleCommonChannelData : NSObject
/// gain
@property (nonatomic, strong) ZDBleCommonModelTool *gain;
/// delay
@property (nonatomic, strong) ZDBleCommonModelTool *delay;
/// phase
@property (nonatomic, strong) ZDBleCommonModelTool *phase;
/// highFrequency
@property (nonatomic, strong) ZDBleCommonChannelFrequencyData *highFrequency;
/// highFrequency
@property (nonatomic, strong) ZDBleCommonChannelFrequencyData *lowFrequency;
/// number
@property (nonatomic, assign) NSInteger number;
@end

@interface ZDBleCommonChannelFrequencyData : NSObject
@property (nonatomic, strong) ZDBleCommonModelTool *freqency;
@property (nonatomic, strong) ZDBleCommonModelTool *highPower;
@property (nonatomic, strong) ZDBleCommonModelTool *lowPower;
@property (nonatomic, strong) ZDBleCommonModelTool *slope;
@property (nonatomic, assign) NSInteger number;

@end


NS_ASSUME_NONNULL_END
