//
//  ViewController.m
//  RunTimeTest
//
//  Created by 王锦涛 on 2018/3/12.
//  Copyright © 2018年 JTWang. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

// 方法的两个默认参数要带上 ，第一个是id类型的self，， 第二个是SEL类型的_cmd
void TestMetaClass(id self, SEL _cmd){
    NSLog(@"the object is %@",self);
    NSLog(@"the class is %@, superclass is %@",[self class], [self superclass]);
    
    Class currentClass = [self class];
    
    for (int i = 0; i < 4; i++) {
        NSLog(@"Following the isa pointer %d times gives %p", i, currentClass);
        currentClass = objc_getClass((__bridge void *)currentClass);
    }
    NSLog(@"NSObject class is%@",[NSObject class]);
    NSLog(@"NSObject metaClass is%@",objc_getClass((__bridge void *)[NSObject class]));
}

void imp_submethod1(id self, SEL _cmd){
    NSLog(@"imp_submethod1");
}

void imp_submethod2(id self, SEL _cmd){
    NSLog(@"imp_submethod2");
}

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self registerClassPair];
//    [self runtimeGetAllIvars];
    
//    [self runtimeGetAllProperty];
    
//    [self runtimeGetAllMethod];
    
    [self runtimeAddClass];
}


/**
 获取所有成员变量
 */
- (void)runtimeGetAllIvars{
    
    Class class = NSClassFromString(@"UINavigationController");
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(class, &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        NSLog(@"name = %@,type = %@",ivarName,ivarType);//
    }
    
    /*
        类型编码 ：  编译器提供的一种方法，用于编码方法的返回值和参数编码为一个字符串，将于方法的selector联系在一起。  关键字@encode可以查看某种类型的编码  常见的编码有
     c   :   char
     i   :   int
     s   :    short
     l   :   long
     q   :   long  long
     B   :   BOOL
     f   :   float
     d   :  double
     V   :  void
     @       一个对象
     :       selector
     #       一个类对象   详细见https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
     
     
     */
    free(ivars); // 注意 带有copy字眼的函数，返回值要另外释放
    
}

- (void)runtimeGetAllProperty{
    Class class = NSClassFromString(@"UINavigationController");
    unsigned int count = 0;
    objc_property_t *propertys = class_copyPropertyList(class, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t p = propertys[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(p)];
        NSString *type = [NSString stringWithUTF8String:property_getAttributes(p)];
        NSLog(@"name = %@,type = %@",name,type);
    }
    free(propertys);
}

- (void)runtimeGetAllMethod{
//    UINavigationController
    // 1.获取所有方法
    Class class = NSClassFromString(@"UINavigationController");
    unsigned int count = 0;
    Method *methods = class_copyMethodList(class, &count); // 返回方法数组，包含父类的方法
    NSLog(@"共有 %d 个方法",count);
    for (int i = 0; i < count; i++) {
        Method method = methods[i];
        NSString *methodName = NSStringFromSelector(method_getName(method));
        NSString *type = [NSString stringWithUTF8String:method_getTypeEncoding(method)];
        NSLog(@"name = %@, type = %@",methodName,type);
    }
    free(methods);
    
    // 2，获取实例方法  只查找当前类下面的实例方法  不搜索父类的
    Method method = class_getInstanceMethod(class, @selector(initWithRootViewController:));
    NSString *methodName = NSStringFromSelector(method_getName(method));
    NSString *type = [NSString stringWithUTF8String:method_getTypeEncoding(method)];
    NSLog(@"name = %@, type = %@",methodName,type);
    // 3，获取类方法
//    class_getClassMethod(class, @selector(classMethodName))
    
    // 4，添加方法  如果当前类中已经有同名的方法  会返回NO， 如果当前类中没有，按时父类中有同名的方法时，会在子类中重写父类的方法
//    class_addMethod(class, @selector(newMethod), (IMP)TestMetaClass, "V@:");
    
     //5, 获取方法的实现  类型是函数指针，指向首地址
//    method_getImplementation(method)
    
}


/**
 动态添加类
 */
- (void)runtimeAddClass{
    Class newUIViewClass = objc_allocateClassPair([UIView class], "JTView", 0);
    //
    class_addMethod(newUIViewClass, @selector(submethod1), (IMP)imp_submethod1, "v@:");
    // 替换方法的实现
    class_replaceMethod(newUIViewClass, @selector(sizeToFit), (IMP)imp_submethod2, "v@:");
    class_addIvar(newUIViewClass, "_ivar1", sizeof(NSString *), log(sizeof(NSString *)), "i");
    
    objc_property_attribute_t type = {"T", "@\"NSString\""};
    objc_property_attribute_t ownership = { "C", "" };
    objc_property_attribute_t backingivar = { "V", "_ivar1"};
    objc_property_attribute_t attrs[] = {type, ownership, backingivar};
    
    class_addProperty(newUIViewClass, "property2", attrs, 3);
    objc_registerClassPair(newUIViewClass); // 添加方法  属性  实例变量要在objc_allocateClassPair 和  objc_registerClassPair之间 ，注册之后才能正常使用
    
    id instance = [[newUIViewClass alloc] init];
    [instance performSelector:@selector(submethod1)];
    [instance performSelector:@selector(sizeToFit)];
}
/**
 动态添加类
 */
- (void)registerClassPair{
    // 动态添加一个NSError的子类，并且给子类添加方法，
    Class newClass = objc_allocateClassPair([NSError class], "TestError", 0);
    class_addMethod(newClass, @selector(testMetaClass), (IMP)TestMetaClass, "V@:");
    objc_registerClassPair(newClass);
    
    id instans = [[newClass alloc] initWithDomain:@"momain" code:0 userInfo:nil];
    NSLog(@"新创建的对象 %@",instans);
    [instans performSelector:@selector(testMetaClass)];
}

- (void)test{
    NSLog(@"%@, %@",[self class], [super class]);
    Class superClass = [self superclass];
    NSString *className = [NSString stringWithCString:class_getName(superClass) encoding:NSUTF8StringEncoding];
    NSLog(@"%@",className);
    NSString *superClassName = [NSString stringWithCString:class_getName([superClass class]) encoding:NSUTF8StringEncoding];
    NSLog(@"%@",superClassName);
    
    if (class_isMetaClass(superClass)) {
        NSLog(@"是元类");
    }else{
        NSLog(@"不是元类");
    }
    
    int count = 0;
    Ivar * asdf = class_copyIvarList(superClass, &count);
    NSLog(@"%d",count);
    
    
    Class asdasdff = objc_getMetaClass(class_getName([superClass superclass]));
    NSLog(@"%@",asdasdff);
}

@end