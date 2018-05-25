//
//  ViewController.m
//  RunTimeTest
//
//  Created by 王锦涛 on 2018/3/12.
//  Copyright © 2018年 JTWang. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "JTView.h"
#import "JTNewClassTest.h"
#import <AFNetworking.h>
#import "GestureTestView.h"
#import <RunTimeTest-Swift.h>
#import "MessageTest.h"

NSInteger globalVariable = 10;
static NSInteger staticGlobalVariable = 100;

typedef void (^DisBlock)(void);

@interface ViewController ()

@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)NSArray *arr;

@property (nonatomic,copy) DisBlock dismissBlock;// 使用assign修饰block后 如果block内引用了外部局部变量，  即block的类型是栈block，  那么在作用域使用block的时候就会崩溃， 如果是全局变量的话没有问题。  所以还是要用copy修饰，经过copy修饰后 block类型变为__NSMallocBlock__   堆block

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
    
    
    
//    UIWebView *asdf = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//    [self.view addSubview:asdf];
//    self.webView = asdf;
    
//    [self getAllRegisterClass];
    
//    [self registerClassPair];
    
//    [self runtimeGetAllIvars];
    
//    [self runtimeGetAllProperty];
    
//    [self runtimeGetAllMethod];
    
//    [self runtimeAddClass];
    
//    [self testRuntimeAssociteObject];
    
//    [self test];
    
//    [self runloopTest];
    
//    [self AFNetworkTest];
//    self.dismissBlock();
//    NSLog(@"%@",self.dismissBlock);
    
//    [self toLearnGestureFromAPI];
    
    
    /*
        1, 实例的类其实也是对象， 叫做类对象，区别就是类对象在内存中只有一份  类对象的类叫做元类
        2，当调用实例方法时， 会去类对象的方法列表中查找匹配
        3，当调用类方法时，  会去类的元类中查找
        4，观察类存储结构的定义，  发现有isa和  super两个class类型的数据，  其中isa指向所属的类，super指向父类
     */
    [self tesMessage];
}
- (void)AFNetworkTest{
    
    @synchronized(self) {
        // 需要锁定的代码
    }
    
//    [NSThread currentThread];
    dispatch_queue_t seSqueue = dispatch_queue_create("com.twshcool.asdf", DISPATCH_QUEUE_SERIAL);  // 创建一个串行队列
    dispatch_queue_t queue = dispatch_queue_create("asdfasdf", DISPATCH_QUEUE_CONCURRENT);//  创建一个并发队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_queue_t grobalQueue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(seSqueue, ^{
        NSLog(@"asdf");
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"asdfasdf");
    });
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"一次执行");
    });
    
    __block NSInteger asdf = 10;
    static NSInteger staticValue = 12;
    // 没有引用外部变量
    void (^firstBlock)(void)  = ^{ NSLog(@"sdaf%d",asdf); }; // __NSGlobalBlock__
//    firstBlock();
    
    
//    void (^secondBlock)(NSInteger) = ^(NSInteger paramter){
//
//        asdf = asdf + 1; //
////        NSLog(@"%d",staticGlobalVariable); // 如果引用静态变量，全局变量， 静态全局变量， 类型会变成 __NSGlobalBlock__
////        NSLog(@"%d",self.arr); // 如果引用外部局部变量， 类型会变成 __NSStackBlock__
////        NSLog(@"%ld",(long)paramter);
//    };
//    secondBlock(10);
    
    self.dismissBlock = firstBlock;
}

- (void)toLearnGestureFromAPI{

    GestureTestView *testView = [[GestureTestView alloc] initWithFrame:CGRectMake(0, 100, UIScreen.mainScreen.bounds.size.width, 100)];
    [self.view addSubview:testView];
    
//    UIPinchGestureRecognizer
//    UIPanGestureRecognizer
//    UIRotationGestureRecognizer
//    UISwipeGestureRecognizer
//    UILongPressGestureRecognizer
//    UIScreenEdgePanGestureRecognizer  //发现新的手势类型  系统的侧滑返回就是用的这个识别的
    
}
/**
 
 */
- (void)runloopTest{
//    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
//    [runloop addObserver:self forKeyPath:@"" options:NSKeyValueObservingOptionNew context:nil];
//    NSLog(@"%@",runloop);
    
//    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
//        NSLog(@"%zd",activity);
//    });
//
//    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopDefaultMode);
//    CFRelease(observer);
    
}


- (void)test{

    Class class = NSClassFromString(@"JTNewClassTest");
    unsigned int count = 0;
    
//    // 1获取所有实例变量,  会获取当前类（不包含父类）的所有实例变量，不管是否暴露在头文件暴露，包含属性生成的对应的 _开头的实例变量
//
//    Ivar * ivars = class_copyIvarList(class, &count);
//    if (count > 0) {
//        for (int i = 0; i < count; i++) {
//            Ivar ivar = ivars[i];
//            NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
//            NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
//            NSLog(@"%@,%@",ivarName,ivarType);
//        }
//    }
//    free(ivars);
//    NSLog(@"************************************************");
//    count = 0;
//    // 2， 获取所有属性
//    objc_property_t * propertys = class_copyPropertyList(class, &count);
//    if (count > 0) {
//        for (int i = 0; i < count; i++) {
//            objc_property_t p = propertys[i];
//            NSString *pName = [NSString stringWithUTF8String: property_getName(p)];
//            NSString *pType = [NSString stringWithUTF8String:property_getAttributes(p)];
//            NSLog(@"%@,%@",pName,pType);
//        }
//    }
//    free(propertys);
//
//
    // 3.1，获取当前类定义中所有的方法： 包含当前类的 所有对象方法 （包括属性的set和get方法）,  但是不包含类方法，因为类方法定义在元类中
    // .cxx_destruct,v16@0:8  多一个方法   这个方法是什么鬼
    NSLog(@"*************************************************************");
    count = 0;
    Method * methods = class_copyMethodList(class, &count);
    if (count > 0) {
        for (int i = 0; i < count; i++) {
            Method method = methods[i];
            NSString *methodName = NSStringFromSelector(method_getName(method));
            NSString *methodType = [NSString stringWithUTF8String:method_getTypeEncoding(method)];
            NSLog(@"%@,%@",methodName,methodType);
        }
    }
    free(methods);
    
    // 3.2，获取类的所有类方法，  （需要访问元类的方法定义）
    Class metaClass = object_getClass(class);
    if (class_isMetaClass(metaClass)) {
        NSLog(@"%@\n\n\n\n", [NSString stringWithUTF8String:class_getName(metaClass)]);
        NSLog(@"************************************************************");
        count = 0;
        Method *methods = class_copyMethodList(metaClass, &count);
        if (count > 0) {
            for (int i = 0; i < count; i++) {
                Method method = methods[i];
                NSString *methodName = NSStringFromSelector(method_getName(method));
                NSString *methodType = [NSString stringWithUTF8String:method_getTypeEncoding(method)];
                NSLog(@"%@,%@",methodName,methodType);
            }
        }
        free(methods);
    }else{
        NSLog(@"");
    }
}


/**
 获取当前系统中注册的所有类
 */
- (void)getAllRegisterClass{
    Class *classArr = NULL;
    int classCount = 0;
    classCount = objc_getClassList(classArr, 0);
    /*
        malloc 是在MRC下的命令  需要把文件设置成MRC  否则编译不通过
     */
    if (classCount > 0) {
        NSLog(@"%d",classCount);
        classArr = malloc(sizeof(Class) * classCount);
        classCount = objc_getClassList(classArr, classCount);
        NSLog(@"%d",classCount);
        
        for (int i = 0; i < classCount; i++) {
            Class class = classArr[i];
            NSString *name = [NSString stringWithUTF8String:class_getName(class)];
            NSLog(@"%@",name);
        }
        
        free(classArr);
    }
}


/**
 关联对象， 借此可以实现向已经存在的类添加属性的功能
 */
- (void)testRuntimeAssociteObject{
    JTView *asdf = [[JTView alloc] initWithFrame:CGRectZero];
    asdf.backgroundColor = [UIColor grayColor];
    [asdf setTapActionWith:^{
        NSLog(@"诶呀  你点我了啊 ");
    }];
    [self.view addSubview:asdf];
}


/**
 获取类的所有成员变量
 */
- (void)runtimeGetAllIvars{
    Class class = NSClassFromString(@"MPMoviePlayerController");
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(class, &count);
    NSLog(@"count = %d", count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        NSLog(@"name = %@",ivarName);//
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
    NSLog(@"count = %d",count);
    for (int i = 0; i < count; i++) {
        objc_property_t p = propertys[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(p)];
        NSString *type = [NSString stringWithUTF8String:property_getAttributes(p)];
        NSLog(@"%@",name);
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
    Class newUIViewClass = objc_allocateClassPair([UIView class], "JTNewClass", 0);
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
    objc_registerClassPair(newUIViewClass); // 添加方法  属性  实例变量要在objc_allocateClassPair 和  objc_registerClassPair之间 ，注册之后才能正常使用, 注册的类名一定要和项目中已经存在的不一样  否则会崩溃  严谨的做法是注册之前判断系统中是否已经存在同名的类s
    
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

- (void)tesMessage{
    
    // 当实例对象调用时
    MessageTest *test = [[MessageTest alloc] init];
//    Class instanceClass = [test class];
//    Class classClass = [MessageTest class];
//    Class objcClass = object_getClass(test);
//    NSLog(@"%p,%p,%p",instanceClass,classClass,objcClass);
    
    // 类对象调用，
//    id classObject = [test class];
//    Class instanceClass = [classObject class];
//    Class classClass = [MessageTest class];
//    Class objcClass = object_getClass(classObject);
//    NSLog(@"%p,%p,%p",instanceClass,classClass,objcClass);
    
    /*
        1,不管什么情况，object_getClass 会返回对象isa指针所指向的类
        2，对于class方法，  如果是实例对象调用，返回对象所属的类效果和object_getClass一样。如果是类调用（不管是类和类对象）都返回当前类
     */
    
//    [MessageTest testClassMethod];
    MessageTest *asdf = [[MessageTest alloc] init];
    [asdf testInstanceMethod];
//    [asdf performSelector:@selector(asdfadfasdf:) withObject:nil];
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    SwiftViewController *swift = [SwiftViewController new];
    [self.navigationController pushViewController:swift animated:true];
}
@end
