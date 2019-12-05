//
//  PushFirstController.m
//  RunTimeTest
//
//  Created by 王锦涛 on 2018/3/14.
//  Copyright © 2018年 JTWang. All rights reserved.
//

#import "PushFirstController.h"

@interface PushFirstController ()
{
    int intest;
}
@end

@implementation PushFirstController

- (void)methodTest{
    NSLog(@"asdf");
}

+ (int)classMethod{
    return 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"PushFirst";
    NSLog(@"%@",self.navigationController.interactivePopGestureRecognizer);
    /*
        1,通过打印系统提供的侧滑手势，发现其类型为UIScreenEdgePanGestureRecognizer， 观察其target和action  发现系统专门提供了一个类  _UINavigationInteractiveTransition  用于处理转场，触发时会调用私有类的handleNavigationTransition:方法
        2，因为想要全屏滑动返回， 但是系统的只能是边缘触发，   所以可以禁用系统的侧滑手势，自己添加一个滑动的手势，，  然后让手势触发的时候调用系统私有的target  和  action
        3，所以，需要利用运行时， 找到侧滑返回手势，的view，触发的target  和   action
        4，找到之后，  根据target和 action自己创建一个全屏的手势添加到view上
     */
    
    UIGestureRecognizer *interactive = self.navigationController.interactivePopGestureRecognizer;
    [interactive setEnabled:NO];
    UIView *containerVeiw = interactive.view;
    NSMutableArray * targets = [interactive valueForKey:@"targets"]; // 数组里面存放的是私有类对象 UIGestureRecognizerTarget
    id firstBbject = targets.firstObject;
    id target = [firstBbject valueForKey:@"_target"];
    
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    // 2，
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
    pan.delegate = self;
    [containerVeiw addGestureRecognizer:pan];
    
    
//    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
//    swipe.direction = UISwipeGestureRecognizerDirectionRight;
//    [containerVeiw addGestureRecognizer:swipe];
}

- (void)pan: (UIPanGestureRecognizer *)ges{
    NSLog(@"asdf");
}
- (void)swipe: (UISwipeGestureRecognizer *)ges{
    NSLog(@"asdf");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
