//
//  MessageTest.m
//  RunTimeTest
//
//  Created by 王锦涛 on 2018/5/25.
//  Copyright © 2018年 JTWang. All rights reserved.
//

#import "MessageTest.h"
#import "SpareObject.h"
#import "HTForwardInvocation.h"
#import <objc/runtime.h>

// 要添加的方法
void func(id self, SEL sel){
    NSLog(@"MessageTest");
}

@implementation MessageTest

//+ (BOOL)resolveClassMethod:(SEL)sel{
//    if ([NSStringFromSelector(sel)  isEqualToString:@"testClassMethod"]) {
//        // 判断如果是需要添加的方法 动态添加
//        class_addMethod(object_getClass(self), sel, (IMP)func, "V@:");
//    }
//    return NO;
//}
//
//+ (BOOL)resolveInstanceMethod:(SEL)sel{
//    class_addMethod([self class], sel, (IMP)func, "V@:");
//    if ([NSStringFromSelector(sel)  isEqualToString:@"testInstanceMethod"]) {
//        // 判断如果是需要添加的方法 动态添加
//        class_addMethod([self class], sel, (IMP)func, "V@:");
//    }
//    return YES;
//}


/*
    1,如果第一步动态方法解析中没有给相应的sel添加实现， 就会到第二步， 消息转发，  会调用相应类的forwardingTargetForSelector的方法
    2, 在该方法中， 可以根据传入的sel 返回一个备用消息接受者，  由改接受者处理该消息
 */
//- (id)forwardingTargetForSelector:(SEL)aSelector{
//
//    return [SpareObject new];
////    return [super forwardingTargetForSelector: aSelector];
//}

/*
    如果第二部中  备用消息处理者没有处理， 那么就会进入完整的消息转发， 这个时候 会把taeget  和 sel和参数封装成NSInvocation对象， 然后用系统消息转发机制进行转发
 */

//- (void)forwardInvocation:(NSInvocation *)anInvocation{
//    NSLog(@"asdf");
//}

//第三步，生成方法签名，然后系统用这个方法签名生成NSInvocation对象
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *selectedStr = NSStringFromSelector(aSelector);
    if ([selectedStr isEqualToString:@"testInstanceMethod"]) {
        NSMethodSignature *sign = [NSMethodSignature signatureWithObjCTypes:"v@:@"];
        return sign;
    }
    return [super methodSignatureForSelector:aSelector];
}

//第四步，改变选择子
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    HTForwardInvocation *forwardInvocation = [[HTForwardInvocation alloc] init];
//    NSLog(@"%@",NSStringFromSelector(anInvocation.selector));
//    anInvocation.selector =  NSSelectorFromString(@"setMsg:");
    if ([forwardInvocation respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:forwardInvocation];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

@end
