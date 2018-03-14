//
//  JTView.m
//  RunTimeTest
//
//  Created by 王锦涛 on 2018/3/14.
//  Copyright © 2018年 JTWang. All rights reserved.
//

#import "JTView.h"
#import <objc/runtime.h>

static char * KAssociateBlock = "KAssociateBlock";
static char * KAssociateTapGestureRecognizer = "KAssociateTapGestureRecognizer";

@implementation JTView

- (void)setTapActionWith:(void(^)(void))block {
    /*
        关联对象
        关联策略
     OBJC_ASSOCIATION_COPY
     OBJC_ASSOCIATION_RETAIN
     OBJC_ASSOCIATION_COPY_NONATOMIC
     OBJC_ASSOCIATION_RETAIN_NONATOMIC
     OBJC_ASSOCIATION_ASSIGN

     */
    
    
    UITapGestureRecognizer *tap = objc_getAssociatedObject(self, &KAssociateTapGestureRecognizer);
    if (!tap) {
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jt_handleActionForTapGesture:)];
        [self addGestureRecognizer:tap];
        objc_setAssociatedObject(self, &KAssociateTapGestureRecognizer, tap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    // 绑定block
    objc_setAssociatedObject(self, &KAssociateBlock, block, OBJC_ASSOCIATION_COPY);
}

- (void)jt_handleActionForTapGesture: (UITapGestureRecognizer *) ges{
    
    if (ges.state == UIGestureRecognizerStateRecognized) {
        void (^block)(void) = objc_getAssociatedObject(self, &KAssociateBlock);
        block();
    }
}

@end
