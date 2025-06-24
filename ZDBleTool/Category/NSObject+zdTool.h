//
//  NSObject+zdTool.h
//  ZDBleTool
//
//  Created by 徐伟新 on 2025/6/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (zdTool)
#pragma mark - 类方法
/// 获取当前UIWindow
+ (nullable UIWindow *)zd_currentWindow;

/// 获取当前UIViewController
+ (nullable UIViewController *)zd_currentViewController;

/// 封装延时方法，输入秒数和block
+ (void)zd_delay:(CGFloat)seconds block:(void(^)(void))block;
@end

NS_ASSUME_NONNULL_END
