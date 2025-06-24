//
//  NSObject+zdTool.m
//  ZDBleTool
//
//  Created by 徐伟新 on 2025/6/24.
//

#import "NSObject+zdTool.h"

@implementation NSObject (zdTool)
#pragma mark - 类方法

+ (nullable UIWindow *)zd_currentWindow {
    UIWindow *window = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                window = windowScene.windows.firstObject;
                if (window) break;
            }
        }
    } else {
        window = [UIApplication sharedApplication].keyWindow;
    }
    return window;
}

+ (nullable UIViewController *)zd_currentViewController {
    UIWindow *window = [self zd_currentWindow];
    UIViewController *vc = window.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    if ([vc isKindOfClass:[UINavigationController class]]) {
        vc = [(UINavigationController *)vc topViewController];
    }
    if ([vc isKindOfClass:[UITabBarController class]]) {
        vc = [(UITabBarController *)vc selectedViewController];
    }
    return vc;
}

+ (void)zd_delay:(CGFloat)seconds block:(void(^)(void))block {
    if (!block) return;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}
@end
