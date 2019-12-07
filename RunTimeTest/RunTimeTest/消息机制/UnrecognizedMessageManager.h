//
//  UnrecognizedMessageManager.h
//  RunTimeTest
//
//  Created by 王锦涛 on 2019/12/5.
//  Copyright © 2019 JTWang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UnrecognizedMessageManager : NSObject


+ (instancetype)shareManager;

@property (nonatomic,weak)id currentInstance;
@property (nonatomic,assign)BOOL isClassMethod;
@end

NS_ASSUME_NONNULL_END
