//
//  JTNewClassTest.m
//  RunTimeTest
//
//  Created by 王锦涛 on 2018/3/16.
//  Copyright © 2018年 JTWang. All rights reserved.
//

#import "JTNewClassTest.h"

@interface JTNewClassTest()
{
    float privateVariable1;
    NSString *privateVariable2;
}

@end
@implementation JTNewClassTest

+ (NSString *)classMethod{
    NSString *sdfasdf = [NSString stringWithFormat:@"classMethod - asd%@",@"13452345"];
    return sdfasdf;
}

+ (void)classMethod2{
    NSLog(@"classMethod2");
}

- (void)instanceMethod{
    NSLog(@"instanceMethod");
}

@end
