//
//  ViewController.h
//  RunTimeTest
//
//  Created by 王锦涛 on 2018/3/12.
//  Copyright © 2018年 JTWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@end

@interface ViewController ()

@property (nonatomic,copy)NSString *testStr;


+ (void)classFuncTest;
- (void)hahahal;

+ (NSString *)testClassMethodExchange: (NSString *)string;
@end

