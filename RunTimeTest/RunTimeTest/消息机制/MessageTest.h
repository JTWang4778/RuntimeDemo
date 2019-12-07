//
//  MessageTest.h
//  RunTimeTest
//
//  Created by 王锦涛 on 2018/5/25.
//  Copyright © 2018年 JTWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTest : UIView
- (void)testInstanceMethod;

- (int)testFunc: (NSString *)p;

- (id)testFunc3: (NSInteger)a P2: (NSString *)string;
+ (void)testClassMethod;
+ (void)testClassMethod2;

@end
