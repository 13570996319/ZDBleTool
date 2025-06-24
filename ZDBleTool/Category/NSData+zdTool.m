//
//  NSData+zdTool.m
//  ZDBleTool
//
//  Created by 徐伟新 on 2025/6/24.
//

#import "NSData+zdTool.h"

@implementation NSData (zdTool)

#pragma mark - 实例方法

- (NSString *)zd_hexString {
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
    if (!dataBuffer) return @"";
    NSMutableString *hexString = [NSMutableString stringWithCapacity:self.length * 2];
    for (NSInteger i = 0; i < self.length; ++i) {
        [hexString appendFormat:@"%02x", dataBuffer[i]];
    }
    return [hexString copy];
}

- (NSString *)zd_decimalString {
    if (self.length == 0) return @"0";
    unsigned long long value = 0;
    [self getBytes:&value length:MIN(self.length, sizeof(value))];
    return [NSString stringWithFormat:@"%llu", value];
}

- (NSInteger)zd_decimalInteger {
    if (self.length == 0) return 0;
    unsigned long long value = 0;
    [self getBytes:&value length:MIN(self.length, sizeof(value))];
    return (NSInteger)value;
}

- (NSString *)zd_binaryString {
    NSMutableString *binaryString = [NSMutableString string];
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
    if (!dataBuffer) return @"";
    for (NSInteger i = 0; i < self.length; ++i) {
        NSString *byteString = [NSString stringWithFormat:@"%08b", dataBuffer[i]];
        [binaryString appendString:byteString];
    }
    return [binaryString copy];
}

#pragma mark - 类方法



@end
