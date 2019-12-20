//
//  NSObject+MessageFarword.m
//  RunTimeTest
//
//  Created by 王锦涛 on 2019/12/5.
//  Copyright © 2019 JTWang. All rights reserved.
//

#import "NSObject+MessageFarword.h"
#import "UnrecognizedMessageManager.h"
#import "HTForwardInvocation.h"

BOOL MessageFarwordIsSystemClass(id self){
    NSString *className = NSStringFromClass([self class]);
    if ([className hasPrefix:@"NS"] || [className hasPrefix:@"_"]) {
        return YES;
    }else{
        return NO;
    }
}

@implementation NSObject (MessageFarword)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 交换方法 区分 实例方法   类方法
        // 第一种消息转发的方案，  在第二部实现
//        Class class = [NSObject class];
//        SEL originalSel = @selector(forwardingTargetForSelector:);
//        SEL swizzlingSel = @selector(jt_forwardingTargetForSelector:);
//
//        [self exchangeMethodWithClass:class OriginalSel:originalSel SwizzlingSel:swizzlingSel IsClassMethod:YES];
//
//        [self exchangeMethodWithClass:class OriginalSel:originalSel SwizzlingSel:swizzlingSel IsClassMethod:NO];
        
        
        // 第二种消息转发的方案  在第三部完整的消息转发实现
        
        Class class = [NSObject class];
         SEL originalSel = @selector(methodSignatureForSelector:);
         SEL swizzlingSel = @selector(jt_methodSignatureForSelector:);
         [self exchangeMethodWithClass:class OriginalSel:originalSel SwizzlingSel:swizzlingSel IsClassMethod:NO];
        
        SEL originalSel2 = @selector(forwardInvocation:);
        SEL swizzlingSel2 = @selector(jt_forwardInvocation:);
        [self exchangeMethodWithClass:class OriginalSel:originalSel2 SwizzlingSel:swizzlingSel2 IsClassMethod:NO];
        
    });
}

- (NSMethodSignature *)jt_methodSignatureForSelector:(SEL)aSelector{
    id sin = [self jt_methodSignatureForSelector:aSelector];
    if (sin == nil) {
        sin = [HTForwardInvocation instanceMethodSignatureForSelector:@selector(testInstanceMethod)];
    }
    return sin;
}

- (void)jt_forwardInvocation:(NSInvocation *)anInvocation{
    @try {
        [self jt_forwardInvocation:anInvocation];
    } @catch (NSException *exception) {
        NSString *name = exception.name;
        NSString *reson = exception.reason;
        NSString *userinfo = exception.userInfo;
        NSArray *asdf = exception.callStackSymbols;
        // 处理堆栈信息 上报
        NSLog(@"😆 %@ -%@",name, reson);
    } @finally {
        
    }
}


// hook系统的方法
- (id)jt_forwardingTargetForSelector:(SEL)aSelector{
    
    id asdf = [self jt_forwardingTargetForSelector:aSelector];
    
    if (MessageFarwordIsSystemClass(self)) {
        return asdf;
    }
    // 判断类如果有自定义消息转发 就不在处理
    if (asdf == nil) {
        UnrecognizedMessageManager *manager = [UnrecognizedMessageManager shareManager];
        manager.currentInstance = self;
        manager.isClassMethod = NO;
        return manager;
    }else{
        return asdf;
    }
    
}

+ (id)jt_forwardingTargetForSelector:(SEL)aSelector{
    id asdf = [self jt_forwardingTargetForSelector:aSelector];
    
    if (MessageFarwordIsSystemClass(self)) {
        return asdf;
    }
    // 判断类如果有自定义消息转发 就不在处理
    if (asdf == nil) {
        UnrecognizedMessageManager *manager = [UnrecognizedMessageManager shareManager];
        manager.currentInstance = self;
        manager.isClassMethod = YES;
        return manager;
    }else{
        return asdf;
    }
}

@end
