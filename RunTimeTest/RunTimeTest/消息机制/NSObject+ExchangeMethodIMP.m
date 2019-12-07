//
//  NSObject+ExchangeMethodIMP.m
//  RunTimeTest
//
//  Created by 王锦涛 on 2019/12/6.
//  Copyright © 2019 JTWang. All rights reserved.
//

#import "NSObject+ExchangeMethodIMP.h"

@implementation NSObject (ExchangeMethodIMP)

/// 交换指定类的两个方法
/// @param class 注意如果是实例方法 传入类对象  如果是类方法传入元类对象
+ (void)exchangeMethodWithClass: (Class)currentClass OriginalSel: (SEL)originalSel SwizzlingSel: (SEL)swizzlingSel IsClassMethod: (BOOL)isClassMethod{
    
    // 判断是否是类方法
    if (isClassMethod) {
        swizzlingClassMethod(currentClass, originalSel, swizzlingSel);
    }else{
        swizzlingInstanceMethod(currentClass, originalSel, swizzlingSel);
    }
}

// 交换两个类方法的实现
void swizzlingClassMethod(Class class, SEL originalSelector, SEL swizzledSelector) {

    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);

    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));

    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


// 交换两个对象方法的实现
void swizzlingInstanceMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));

    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
