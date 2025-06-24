//
//  NSString+zdTool.m
//  ZDBleTool
//
//  Created by 徐伟新 on 2025/6/24.
//

#import "NSString+zdTool.h"

@implementation NSString (zdTool)

#pragma mark - 类方法

+ (NSString *)zd_stringFromNumber:(NSInteger)number {
    return [NSString stringWithFormat:@"%ld", (long)number];
}

+ (NSString *)zd_hexStringFromNumber:(NSInteger)number {
    return [NSString stringWithFormat:@"%lx", (long)number];
}

+ (NSData *)zd_dataFromNumber:(NSInteger)number {
    NSString *hexString = [self zd_hexStringFromNumber:number];
    return [self zd_dataFromHexString:hexString];
}

+ (NSString *)zd_appVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return appVersion ?: @"";
}

+ (NSString *)zd_timeStringFromSeconds:(NSInteger)seconds {
    if (seconds < 0) {
        return @"00:00";
    }
    
    NSInteger hours = seconds / 3600;
    NSInteger minutes = (seconds % 3600) / 60;
    NSInteger secs = seconds % 60;
    
    if (hours > 0) {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)secs];
    } else {
        return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)secs];
    }
}

+ (NSString *)zd_binaryStringFromNumber:(NSInteger)number {
    if (number == 0) {
        return @"00000000"; // 返回8位
    }
    
    NSMutableString *binaryString = [NSMutableString string];
    NSInteger tempNumber = labs(number); // 使用绝对值
    
    while (tempNumber > 0) {
        [binaryString insertString:(tempNumber % 2 == 0 ? @"0" : @"1") atIndex:0];
        tempNumber /= 2;
    }
    
    // 确保结果是8位或8位的倍数
    NSInteger currentLength = binaryString.length;
    NSInteger targetLength = ((currentLength - 1) / 8 + 1) * 8; // 向上取整到8的倍数
    
    while (binaryString.length < targetLength) {
        [binaryString insertString:@"0" atIndex:0];
    }
    
    return [binaryString copy];
}

#pragma mark - 实例方法

- (NSString *)zd_hexStringFromString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    const unsigned char *bytes = [data bytes];
    NSMutableString *hexString = [NSMutableString string];
    
    for (NSInteger i = 0; i < data.length; i++) {
        [hexString appendFormat:@"%02x", bytes[i]];
    }
    
    return [hexString copy];
}

- (NSString *)zd_stringFromHexString {
    NSData *data = [NSString zd_dataFromHexString:self];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)zd_decimalStringFromHexString {
    NSInteger decimalValue = [self zd_integerFromHexString];
    return [NSString stringWithFormat:@"%ld", (long)decimalValue];
}

- (NSInteger)zd_integerFromHexString {
    NSScanner *scanner = [NSScanner scannerWithString:self];
    unsigned int result = 0;
    [scanner scanHexInt:&result];
    return (NSInteger)result;
}

- (NSString *)zd_hexStringFromDecimalString {
    NSInteger decimalValue = [self integerValue];
    return [NSString zd_hexStringFromNumber:decimalValue];
}

- (NSString *)zd_hexStringFromDecimalStringWithBitNumber:(NSInteger)bitNumber {
    NSInteger decimalValue = [self integerValue];
    NSString *hexString = [NSString zd_hexStringFromNumber:decimalValue];
    
    // 如果十六进制字符串长度小于指定位数，在前面补0
    while (hexString.length < bitNumber) {
        hexString = [@"0" stringByAppendingString:hexString];
    }
    
    // 如果十六进制字符串长度大于指定位数，截取后面的位数
    if (hexString.length > bitNumber) {
        hexString = [hexString substringFromIndex:hexString.length - bitNumber];
    }
    
    return hexString;
}

- (NSData *)zd_dataFromHexString {
    return [NSString zd_dataFromHexString:self];
}

- (NSString *)zd_hexStringFromNormalString {
    return [self zd_hexStringFromString];
}

- (NSData *)zd_dataFromNormalString {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (CGFloat)zd_heightWithLineSpacing:(CGFloat)lineSpacing font:(UIFont *)font width:(CGFloat)width {
    if (!font || width <= 0) {
        return 0;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    
    NSDictionary *attributes = @{
        NSFontAttributeName: font,
        NSParagraphStyleAttributeName: paragraphStyle
    };
    
    CGRect boundingRect = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         attributes:attributes
                                            context:nil];
    
    return ceil(boundingRect.size.height);
}

- (CGFloat)zd_widthWithFont:(UIFont *)font height:(CGFloat)height {
    if (!font || height <= 0) {
        return 0;
    }
    
    NSDictionary *attributes = @{
        NSFontAttributeName: font
    };
    
    CGRect boundingRect = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         attributes:attributes
                                            context:nil];
    
    return ceil(boundingRect.size.width);
}

- (NSString *)zd_substringWithRange:(NSRange)range {
    if (range.location == NSNotFound || range.length == 0) {
        return @"";
    }
    
    if (range.location >= self.length) {
        return @"";
    }
    
    NSInteger endLocation = range.location + range.length;
    if (endLocation > self.length) {
        endLocation = self.length;
    }
    
    NSRange safeRange = NSMakeRange(range.location, endLocation - range.location);
    return [self substringWithRange:safeRange];
}

- (NSString *)zd_substringFromIndex:(NSInteger)fromIndex {
    if (fromIndex < 0 || fromIndex >= self.length) {
        return @"";
    }
    
    return [self substringFromIndex:fromIndex];
}

- (NSString *)zd_substringToIndex:(NSInteger)toIndex {
    if (toIndex <= 0 || toIndex > self.length) {
        return @"";
    }
    
    return [self substringToIndex:toIndex];
}

- (NSString *)zd_binaryStringFromDecimalString {
    NSInteger decimalValue = [self integerValue];
    return [NSString zd_binaryStringFromNumber:decimalValue];
}

- (NSString *)zd_binaryStringFromHexString {
    // 先转换为十进制，再转换为二进制
    NSInteger decimalValue = [self zd_integerFromHexString];
    return [NSString zd_binaryStringFromNumber:decimalValue];
}

#pragma mark - 私有辅助方法

+ (NSData *)zd_dataFromHexString:(NSString *)hexString {
    NSString *cleanHexString = [hexString stringByReplacingOccurrencesOfString:@" " withString:@""];
    cleanHexString = [cleanHexString stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    cleanHexString = [cleanHexString stringByReplacingOccurrencesOfString:@"0X" withString:@""];
    
    if (cleanHexString.length % 2 != 0) {
        cleanHexString = [@"0" stringByAppendingString:cleanHexString];
    }
    
    NSMutableData *data = [NSMutableData data];
    for (NSInteger i = 0; i < cleanHexString.length; i += 2) {
        NSString *byteString = [cleanHexString substringWithRange:NSMakeRange(i, 2)];
        unsigned char byte = (unsigned char)strtol([byteString UTF8String], NULL, 16);
        [data appendBytes:&byte length:1];
    }
    
    return [data copy];
}

@end
