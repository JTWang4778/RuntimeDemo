//
//  UIViewController+MethodSwizzling.m
//  RunTimeTest
//
//  Created by 王锦涛 on 2018/3/14.
//  Copyright © 2018年 JTWang. All rights reserved.
//

#import "UIViewController+MethodSwizzling.h"
#import <objc/runtime.h>

@implementation UIViewController (MethodSwizzling)


/**
 类加载进内存的时候 调用一次load方法
 */
+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSel = @selector(viewWillAppear:);
        SEL swizzlingSel = @selector(jt_viewWillAppear:);
        Method originalMethod = class_getInstanceMethod(class, originalSel);
        Method swizzlingMethod = class_getInstanceMethod(class, swizzlingSel);
        
        BOOL addMethodSuccess = class_addMethod(class, originalSel, method_getImplementation(swizzlingMethod), method_getTypeEncoding(swizzlingMethod));
        if (addMethodSuccess) {
            class_replaceMethod(class, swizzlingSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else{
            method_exchangeImplementations(originalMethod, swizzlingMethod);
        }
        
    });
    
}


/**
 方法交换，交换了控制器的viewWillAppear： 方法，

 @param animated <#animated description#>
 */
- (void)jt_viewWillAppear:(BOOL)animated{
    [self jt_viewWillAppear:animated];
    NSLog(@"%@控制器显示了",[self class]);
}

@end
