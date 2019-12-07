//
//  UnrecognizedMessageManager.m
//  RunTimeTest
//
//  Created by 王锦涛 on 2019/12/5.
//  Copyright © 2019 JTWang. All rights reserved.
//

#import "UnrecognizedMessageManager.h"
#import <objc/runtime.h>

// 要添加的处理未实现实例方法的方法
void instanceFunc(id self, SEL sel){
    
    UnrecognizedMessageManager *manager = [UnrecognizedMessageManager shareManager];
    NSString *className = NSStringFromClass([manager.currentInstance class]);
    NSString *funcName = NSStringFromSelector(sel);
    if (manager.isClassMethod) {
        NSLog(@"\n 🌹 +[%@ %@]:unrecognized selector sent to instance %p",className,funcName, manager.currentInstance);
    }else{
        NSLog(@"\n 🌹 -[%@ %@]:unrecognized selector sent to instance %p",className,funcName, manager.currentInstance);
    }
    
}

// 要添加的处理未实现实例方法的方法
void classFunc(id self, SEL sel){
    
    UnrecognizedMessageManager *manager = [UnrecognizedMessageManager shareManager];
    NSString *className = NSStringFromClass([manager.currentInstance class]);
    NSString *funcName = NSStringFromSelector(sel);
    NSLog(@"\n 🌹 +[%@ %@]:unrecognized selector sent to instance %p",className,funcName, manager.currentInstance);
}


@implementation UnrecognizedMessageManager


+ (instancetype)shareManager{
    static UnrecognizedMessageManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL] init];
    });
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [UnrecognizedMessageManager shareManager];
}

- (id)copyWithZone:(NSZone *)zone{
    return [UnrecognizedMessageManager shareManager];
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return [UnrecognizedMessageManager shareManager];
}



+ (BOOL)resolveInstanceMethod:(SEL)sel{
    return class_addMethod([self class], sel, (IMP)instanceFunc, "V@:");;
}

+ (BOOL)resolveClassMethod:(SEL)sel{
    // 获得元类
    Class metaClass = object_getClass(self);
    BOOL result = class_addMethod(metaClass, sel, (IMP)classFunc, "V@:");
    return result;
}
@end
