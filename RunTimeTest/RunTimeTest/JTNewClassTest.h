//
//  JTNewClassTest.h
//  RunTimeTest
//
//  Created by 王锦涛 on 2018/3/16.
//  Copyright © 2018年 JTWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTNewClassTest : NSObject
{
    NSString *variable1;
    int variable2;
}

@property (nonatomic,assign)BOOL property1;
@property (nonatomic,strong)NSArray *property2;

+ (NSString *)classMethod;
+ (void)classMethod2;
- (void)instanceMethod;

@end
