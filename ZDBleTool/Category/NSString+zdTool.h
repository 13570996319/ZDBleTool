//
//  NSString+zdTool.h
//  ZDBleTool
//
//  Created by 徐伟新 on 2025/6/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (zdTool)

#pragma mark - 类方法
/**
 * 将NSInteger转换为字符串
 * @param number 要转换的数字
 * @return 转换后的字符串
 */
+ (NSString *)zd_stringFromNumber:(NSInteger)number;

/**
 * 将NSInteger转换为十六进制字符串
 * @param number 要转换的数字
 * @return 转换后的十六进制字符串
 */
+ (NSString *)zd_hexStringFromNumber:(NSInteger)number;

/**
 * 将NSInteger转换为NSData
 * @param number 要转换的数字
 * @return 转换后的NSData
 */
+ (NSData *)zd_dataFromNumber:(NSInteger)number;

/**
 * 获取当前APP的版本号
 * @return 版本号字符串
 */
+ (NSString *)zd_appVersion;

/**
 * 根据输入的秒数转化成时间格式字符串
 * @param seconds 秒数
 * @return 时间格式字符串 (HH:mm:ss 或 mm:ss)
 */
+ (NSString *)zd_timeStringFromSeconds:(NSInteger)seconds;

/**
 * 将NSInteger转换为二进制字符串
 * @param number 要转换的数字
 * @return 转换后的二进制字符串 (8位或8位的倍数)
 */
+ (NSString *)zd_binaryStringFromNumber:(NSInteger)number;

#pragma mark - 实例方法
/**
 * 将普通字符串转换为十六进制字符串
 * @return 转换后的十六进制字符串
 */
- (NSString *)zd_hexStringFromString;

/**
 * 将十六进制字符串转换为普通字符串
 * @return 转换后的普通字符串
 */
- (NSString *)zd_stringFromHexString;

/**
 * 将十六进制字符串转换为十进制字符串
 * @return 转换后的十进制字符串
 */
- (NSString *)zd_decimalStringFromHexString;

/**
 * 将十六进制字符串转换为NSInteger
 * @return 转换后的NSInteger
 */
- (NSInteger)zd_integerFromHexString;

/**
 * 将十进制字符串转换为十六进制字符串
 * @return 转换后的十六进制字符串
 */
- (NSString *)zd_hexStringFromDecimalString;

/**
 * 将十进制字符串转换为指定位数的十六进制字符串
 * @param bitNumber 十六进制字符串的位数
 * @return 转换后的十六进制字符串
 */
- (NSString *)zd_hexStringFromDecimalStringWithBitNumber:(NSInteger)bitNumber;

/**
 * 将十六进制字符串转换为NSData
 * @return 转换后的NSData
 */
- (NSData *)zd_dataFromHexString;

/**
 * 将普通字符串转换为十六进制字符串
 * @return 转换后的十六进制字符串
 */
- (NSString *)zd_hexStringFromNormalString;

/**
 * 将普通字符串转换为NSData
 * @return 转换后的NSData
 */
- (NSData *)zd_dataFromNormalString;

/**
 * 根据行间隔、字体和宽度获取文字高度
 * @param lineSpacing 行间隔
 * @param font 字体
 * @param width 宽度
 * @return 文字高度
 */
- (CGFloat)zd_heightWithLineSpacing:(CGFloat)lineSpacing font:(UIFont *)font width:(CGFloat)width;

/**
 * 根据字体和高度获取宽度
 * @param font 字体
 * @param height 高度
 * @return 文字宽度
 */
- (CGFloat)zd_widthWithFont:(UIFont *)font height:(CGFloat)height;

/**
 * 根据NSRange获取对应的字符串，防空处理
 * @param range 范围
 * @return 对应的字符串
 */
- (NSString *)zd_substringWithRange:(NSRange)range;

/**
 * 根据起点获取对应的字符串，防空处理
 * @param fromIndex 起点索引
 * @return 对应的字符串
 */
- (NSString *)zd_substringFromIndex:(NSInteger)fromIndex;

/**
 * 根据终点获取对应的字符串，防空处理
 * @param toIndex 终点索引
 * @return 对应的字符串
 */
- (NSString *)zd_substringToIndex:(NSInteger)toIndex;

/**
 * 将十进制字符串转换为二进制字符串
 * @return 转换后的二进制字符串 (8位或8位的倍数)
 */
- (NSString *)zd_binaryStringFromDecimalString;

/**
 * 将十六进制字符串转换为二进制字符串
 * @return 转换后的二进制字符串 (8位或8位的倍数)
 */
- (NSString *)zd_binaryStringFromHexString;

@end

NS_ASSUME_NONNULL_END
