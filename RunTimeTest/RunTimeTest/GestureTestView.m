//
//  GestureTestView.m
//  RunTimeTest
//
//  Created by 王锦涛 on 2018/4/29.
//  Copyright © 2018年 JTWang. All rights reserved.
//

#import "GestureTestView.h"

@interface GestureTestView()<UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic,weak)UIScrollView *scrollView;
@end

@implementation GestureTestView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        
        UIScrollView  *scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
        scroll.delegate = self;
        scroll.backgroundColor = UIColor.grayColor;
        [self addSubview:scroll];
        self.scrollView = scroll;
        
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 600, 600)];
        view.backgroundColor = [UIColor orangeColor];
        [scroll addSubview:view];
        scroll.contentSize = CGSizeMake(600, 600);
       
    }
    
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    CGPoint offset = scrollView.contentOffset;
    NSLog(@"%f",offset.x);
    if (offset.x < -30.0) {
        [scrollView.panGestureRecognizer setEnabled:NO];
        
    }
    NSLog(@"%ld",(long)scrollView.panGestureRecognizer.state);
}
- (void)addGesture{
    // 单击
    //        UITapGestureRecognizer *asdf = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    //        asdf.delegate = self;
    //        [self addGestureRecognizer:asdf];
    //
    //        // 双击
    //        UITapGestureRecognizer *twiceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twiceTap:)];
    //        twiceTap.numberOfTapsRequired = 2;
    //        twiceTap.delegate = self;
    //        [self addGestureRecognizer:twiceTap];
    
    // 长按
    //        UILongPressGestureRecognizer *longPresss = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    //        [self addGestureRecognizer:longPresss];
    
    //        UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePan:)];
    //        edgePan.edges = UIRectEdgeLeft;
    //        [self addGestureRecognizer:edgePan];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSLog(@"touchesBegan");
//}
//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSLog(@"touchesCancelled");
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSLog(@"touchesMoved");
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSLog(@"touchesEnded");
//}

- (void)tap: (UITapGestureRecognizer *)ges{
    NSLog(@"单击");
}

//- (void)twiceTap: (UITapGestureRecognizer *)ges{
//    NSLog(@"双击");
//}
//
//- (void)longPress: (UILongPressGestureRecognizer *)ges{
//    NSLog(@"长按");
//}

- (void)edgePan: (UIScreenEdgePanGestureRecognizer *)ges{
    CGPoint trans = [ges translationInView:self];
    NSLog(@"edgePan%@",NSStringFromCGPoint(trans));
}

#pragma - mark

// 当手势识别器试图由UIGestureRecognizerStatePossible状态转变时调用，   默认返回YES， 手势正常识别，   如果返回NO， 识别器变为UIGestureRecognizerStateFailed
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return  YES;
}

// 当一个手势被识别 或者 一个手势识别器被阻塞时调用， 表示是否同时响应手势，默认是NO  一般情况下同一个view上的多个手势不能同时响应， 默认也是这么做的（但是单击和双击手势可以同时响应， 只不过不正常）
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return  NO;
}

//  一下两个方法为两个识别器之间的依赖，一个识别器的依赖于另外一个的失败，  也就是一个识别器识别失败之后， 另外一个识别器才能识别
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return  YES;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    return  YES;
//}

@end
