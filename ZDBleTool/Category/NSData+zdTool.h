//
//  NSData+zdTool.h
//  ZDBleTool
//
//  Created by 徐伟新 on 2025/6/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (zdTool)

#pragma mark - 实例方法
/// NSData转16进制字符串
- (NSString *)zd_hexString;

/// NSData转十进制字符串
- (NSString *)zd_decimalString;

/// NSData转十进制NSInteger
- (NSInteger)zd_decimalInteger;

/// NSData转二进制字符串（8位或8的倍数）
- (NSString *)zd_binaryString;



@end

NS_ASSUME_NONNULL_END
