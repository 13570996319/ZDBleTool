//
//  ZDBleDataModelTool.m
//  ZDBleTool
//
//  Created by 徐伟新 on 2025/6/24.
//

#import "ZDBleDataModelTool.h"

@implementation ZDBleDataModelTool

- (BOOL)bleIsConnected {
    if (self.peripheral && self.peripheral.state == CBPeripheralStateConnected) {
        return YES;
    }
    return NO;
}

- (BOOL)isCanSend {
    if (self.bleIsConnected && self.writeChaArray.count > 0) {
        return YES;
    }
    return NO;
    
    
}

- (NSMutableArray *)writeChaArray {
    if (!_writeChaArray) {
        _writeChaArray = [NSMutableArray array];
    }
    return _writeChaArray;
}

@end

@implementation ZDBleCommonModelTool

@end


@implementation ZDCommonCarMerchineData
- (ZDBleCommonModelTool *)power {
    if (!_power) {
        _power = [[ZDBleCommonModelTool alloc]init];
        _power.advTagArray = @[@"08"];
    }
    return _power;
}
- (ZDBleCommonModelTool *)playOrPause {
    if (!_playOrPause) {
        _playOrPause = [[ZDBleCommonModelTool alloc]init];
        _playOrPause.advTagArray = @[@"0102"];
    }
    return _playOrPause;
}

- (ZDBleCommonModelTool *)fanPower {
    if (!_fanPower) {
        _fanPower = [[ZDBleCommonModelTool alloc]init];
        _fanPower.advTagArray = @[@"030d"];
    }
    return _fanPower;
}

- (ZDBleCommonModelTool *)loud {
    if (!_loud) {
        _loud = [[ZDBleCommonModelTool alloc]init];
        _loud.advTagArray = @[@"0404"];
    }
    return _loud;
}

- (ZDBleCommonModelTool *)carModel {
    if (!_carModel) {
        _carModel = [[ZDBleCommonModelTool alloc]init];
        _carModel.advTagArray = @[@"0b",@"aa00",@"8900",@"2002"];
    }
    return _carModel;
}

- (ZDBleCommonModelTool *)bas {
    return self.normalEqArray[0];
}
- (ZDBleCommonModelTool *)tre {
    return self.normalEqArray[1];
}
- (ZDBleCommonModelTool *)bal {
    return self.normalEqArray[2];
}
- (ZDBleCommonModelTool *)fad {
    return self.normalEqArray[3];
}

- (ZDBleCommonModelTool *)mute {
    if (!_mute) {
        _mute = [[ZDBleCommonModelTool alloc]init];
        _mute.advTagArray = @[@"0900",@"0901"];
    }
    return _mute;
}

- (ZDBleCommonModelTool *)currentFm {
    if (!_currentFm) {
        _currentFm = [[ZDBleCommonModelTool alloc]init];
        _currentFm.advTagArray = @[@"0d01"];
    }
    return _currentFm;
}

- (ZDBleCommonModelTool *)currentFmBandNumber {
    if (!_currentFmBandNumber) {
        _currentFmBandNumber = [[ZDBleCommonModelTool alloc]init];
        _currentFmBandNumber.advTagArray = @[@"0d01",@"0d02"];
    }
    return _power;
}

- (ZDBleCommonModelTool *)volumn {
    if (!_volumn) {
        _volumn = [[ZDBleCommonModelTool alloc]init];
        _volumn.advTagArray = @[@"0403"];
    }
    return _volumn;
}


- (ZDBleCommonModelTool *)btnRgb {
    if (!_btnRgb) {
        _btnRgb = [[ZDBleCommonModelTool alloc]init];
        _btnRgb.advTagArray = @[@"0e00",@"0e01",@"0e02",@"0e03",@"0e04",@"0e06"];
    }
    return _btnRgb;
}


- (ZDBleCommonModelTool *)screenRgb {
    if (!_screenRgb) {
        _screenRgb = [[ZDBleCommonModelTool alloc]init];
        _screenRgb.advTagArray = @[@"0e05"];
    }
    return _screenRgb;
}


- (ZDBleCommonModelTool *)dabFreuency {
    if (!_dabFreuency) {
        _dabFreuency = [[ZDBleCommonModelTool alloc]init];
        _dabFreuency.advTagArray = @[@"1001"];
    }
    return _dabFreuency;
}


- (ZDBleCommonModelTool *)dabPlatNum {
    if (!_dabPlatNum) {
        _dabPlatNum = [[ZDBleCommonModelTool alloc]init];
        _dabPlatNum.advTagArray = @[@"1001"];
    }
    return _dabPlatNum;
}


- (ZDBleCommonModelTool *)dabMsg {
    if (!_dabMsg) {
        _dabMsg = [[ZDBleCommonModelTool alloc]init];
        _dabMsg.advTagArray = @[@"1002"];
    }
    return _dabMsg;
}

- (NSArray<ZDBleCommonModelTool *> *)normalEqArray {
    
    if (_normalEqArray.count == 0) {
        NSMutableArray *array = [NSMutableArray array];
        NSArray *nameArray = @[@"BAS",@"TRE",@"BAL",@"FAD"];
        for (NSInteger i = 0; i < nameArray.count; i++) {
            ZDBleCommonModelTool *model = [[ZDBleCommonModelTool alloc]init];
            model.name = nameArray[i];
            model.number = i;
            NSString *hexTag = [NSString stringWithFormat:@"0a0%ld",i+1];
            model.advTagArray = @[hexTag];
            model.maxValue = 14;
            model.minValue = 0;
            [array addObject:model];
            
        }
        _normalEqArray = array;
        
    }
    return _normalEqArray;
    
}

- (NSArray<ZDBleCommonModelTool *> *)eqArray2001 {
    if (_eqArray2001.count == 0) {
        NSMutableArray *array = [NSMutableArray array];
        NSArray *nameArray = @[@"60",@"330",@"630",@"1000",@"3000",@"6000",@"10000"];
        for (NSInteger i = 0; i < nameArray.count; i++) {
            ZDBleCommonModelTool *model = [[ZDBleCommonModelTool alloc]init];
            model.name = [nameArray[i] zd_thousandDecimalStringFromdecimalString];
            model.number = i;
            NSString *hexTag = [NSString stringWithFormat:@"2001%@",[NSString zd_hexStringFromNumber:i]];
            model.advTagArray = @[hexTag];
            model.maxValue = 14;
            model.minValue = 0;
            [array addObject:model];
            
        }
        _eqArray2001 = array;
        
    }
    return _eqArray2001;
    
    
}

- (NSArray<ZDBleCommonModelTool *> *)eqArray0a {
    if (_eqArray0a.count == 0) {
        NSMutableArray *array = [NSMutableArray array];
        NSArray *nameArray = @[@"60",@"100",@"160",@"300",@"600",@"1000",@"3000",@"5000",@"10000",@"150000"];
        for (NSInteger i = 0; i < nameArray.count; i++) {
            ZDBleCommonModelTool *model = [[ZDBleCommonModelTool alloc]init];
            model.name = [nameArray[i] zd_thousandDecimalStringFromdecimalString];
            model.number = i;
            NSString *hexTag = [NSString stringWithFormat:@"0a05%@",[NSString zd_hexStringFromNumber:i]];
            model.advTagArray = @[hexTag,@"0a07"];
            model.maxValue = 14;
            model.minValue = 0;
            [array addObject:model];
            
        }
        _eqArray0a = array;
        
    }
    return _eqArray0a;
    
    
}

- (NSArray<ZDBleCommonMoreEqData *> *)eqArray89 {
    if (_eqArray89.count == 0) {
        NSMutableArray *array = [NSMutableArray array];
        NSArray *nameArray = @[@"60",@"100",@"160",@"300",@"600",@"1000",@"3000",@"5000",@"10000",@"150000"];
        for (NSInteger i = 0; i < nameArray.count; i++) {
            ZDBleCommonMoreEqData *model = [[ZDBleCommonMoreEqData alloc]init];
            
            model.number = i;
            model.gain.name = [nameArray[i] zd_thousandDecimalStringFromdecimalString];
            model.gain.maxValue = 24;
            model.gain.minValue = 0;
            model.gain.progressValue = 1;
            model.qValue.name = [nameArray[i] zd_thousandDecimalStringFromdecimalString];
            model.qValue.maxValue = 5000;
            model.qValue.minValue = 100;
            model.qValue.progressValue = 100;
            model.frequency.name = nameArray[i];
            model.frequency.value = [nameArray[i] integerValue];
            
            NSString *hexTag = [NSString stringWithFormat:@"8901%@",[NSString zd_hexStringFromNumber:i]];
            model.gain.advTagArray = @[hexTag,@"8900"];
            model.qValue.advTagArray = @[hexTag,@"8900"];
            [array addObject:model];
            
        }
        _eqArray89 = array;
        
    }
    return _eqArray89;
    
    
}

- (NSArray<ZDBleCommonMoreEqData *> *)eqArrayaa {
    if (_eqArrayaa.count == 0) {
        NSMutableArray *array = [NSMutableArray array];
        NSArray *nameArray = @[@"60",@"100",@"160",@"300",@"600",@"1000",@"3000",@"5000",@"10000",@"150000"];
        for (NSInteger i = 0; i < nameArray.count; i++) {
            ZDBleCommonMoreEqData *model = [[ZDBleCommonMoreEqData alloc]init];
            
            model.number = i;
            model.gain.name = [nameArray[i] zd_thousandDecimalStringFromdecimalString];
            model.gain.maxValue = 32;
            model.gain.minValue = 0;
            model.gain.progressValue = 1;
            model.qValue.name = [nameArray[i] zd_thousandDecimalStringFromdecimalString];
            model.qValue.maxValue = 120;
            model.qValue.minValue = 1;
            model.qValue.progressValue = 10;
            model.frequency.name = nameArray[i];
            model.frequency.value = [nameArray[i] integerValue];
            
            NSString *hexTag = [NSString stringWithFormat:@"aa01%@",[NSString zd_hexStringFromNumber:i]];
            model.gain.advTagArray = @[hexTag,@"aa00"];
            model.qValue.advTagArray = @[hexTag,@"aa00"];
            [array addObject:model];
            
        }
        _eqArrayaa = array;
        
    }
    return _eqArrayaa;
    
    
}




@end

@implementation ZDBleCommonMoreEqData
- (ZDBleCommonModelTool *)gain {
    if (!_gain) {
        _gain = [[ZDBleCommonModelTool alloc]init];
        _gain.name = @"增益";
    }
    return _gain;
}

- (ZDBleCommonModelTool *)qValue {
    if (!_qValue) {
        _qValue = [[ZDBleCommonModelTool alloc]init];
        _qValue.name = @"Q值";
    }
    return _qValue;
}

- (ZDBleCommonModelTool *)frequency {
    if (!_frequency) {
        _frequency = [[ZDBleCommonModelTool alloc]init];
        _frequency.name = @"频率";
    }
    return _frequency;
}

- (void)setNumber:(NSInteger)number {
    _number = number;
    self.gain.number = number;
    self.qValue.number = number;
    self.frequency.number = number;
}


@end


@implementation ZDBleCommonChannelData
- (ZDBleCommonModelTool *)gain {
    if (!_gain) {
        _gain = [[ZDBleCommonModelTool alloc]init];
        
    }
    return _gain;
}
- (ZDBleCommonModelTool *)delay {
    if (!_delay) {
        _delay = [[ZDBleCommonModelTool alloc]init];
    }
    return _delay;
}
- (ZDBleCommonModelTool *)phase {
    if (!_phase) {
        _phase = [[ZDBleCommonModelTool alloc]init];
    }
    return _phase;
}

- (ZDBleCommonChannelFrequencyData *)highFrequency {
    if (!_highFrequency) {
        _highFrequency = [[ZDBleCommonChannelFrequencyData alloc]init];
    }
    return _highFrequency;
}

- (ZDBleCommonChannelFrequencyData *)lowFrequency {
    if (!_lowFrequency) {
        _lowFrequency = [[ZDBleCommonChannelFrequencyData alloc]init];
    }
    return _lowFrequency;
}

- (void)setNumber:(NSInteger)number {
    _number = number;
    self.gain.number = number;
    self.delay.number = number;
    self.phase.number = number;
    self.highFrequency.number = number;
    self.lowFrequency.number = number;
}


@end

@implementation ZDBleCommonChannelFrequencyData
- (ZDBleCommonModelTool *)freqency {
    if (!_freqency) {
        _freqency = [[ZDBleCommonModelTool alloc]init];
    }
    return _freqency;
}

- (ZDBleCommonModelTool *)highPower {
    if (!_freqency) {
        _freqency = [[ZDBleCommonModelTool alloc]init];
    }
    return _freqency;
}

- (ZDBleCommonModelTool *)lowPower {
    if (!_lowPower) {
        _lowPower = [[ZDBleCommonModelTool alloc]init];
    }
    return _lowPower;
}

- (ZDBleCommonModelTool *)slope {
    if (!_slope) {
        _slope = [[ZDBleCommonModelTool alloc]init];
    }
    return _slope;
}

- (void)setNumber:(NSInteger)number {
    _number = number;
    self.freqency.number = number;
    self.highPower.number = number;
    self.lowPower.number = number;
    self.slope.number = number;
}


@end

