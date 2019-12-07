//
//  NSObject+ExchangeMethodIMP.h
//  RunTimeTest
//
//  Created by 王锦涛 on 2019/12/6.
//  Copyright © 2019 JTWang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ExchangeMethodIMP)

+ (void)exchangeMethodWithClass: (Class)currentClass OriginalSel: (SEL)originalSel SwizzlingSel: (SEL)swizzlingSel IsClassMethod: (BOOL)isClassMethod;
@end

NS_ASSUME_NONNULL_END
