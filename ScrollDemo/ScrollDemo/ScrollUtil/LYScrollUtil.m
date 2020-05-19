//
//  LYScrollUtil.m
//  laoyuegou
//
//  Created by zwq on 2018/8/10.
//  Copyright © 2018年 HaiNanLexin. All rights reserved.
//

#import "LYScrollUtil.h"

typedef NS_ENUM (NSInteger,S_Status){
    S_Status_Super_UP,
    S_Status_Super_Down,
    S_Status_Super_Down_Only,
    S_Status_Child_UP,
    S_Status_Child_Down,
    S_Status_Keep,
};

typedef NS_ENUM (NSInteger,S_Drection){
    S_Drection_None,
    S_Drection_UP,
    S_Drection_Down,
};

@interface LYScrollUtil()

@property (nonatomic, assign) BOOL childIsDraging;

@property (nonatomic, assign) BOOL superCanScroll;

@property (nonatomic, assign) CGFloat childPointY;

@property (nonatomic, assign) CGFloat superPointY;

@property (nonatomic, assign) S_Status status;

@end


@implementation LYScrollUtil

//- (id)init{
//    if (self = [super init]) {
//        [self initBlocks];
//    }
//    return self;
//}

- (void)dealloc{
    if (_superScrollView) {
        [_superScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    if (_childScrollView) {
        [_childScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    _superScrollView = nil;
    _childScrollView = nil;
}

//- (void)initBlocks{
//    WeakSelf(weakSelf);
//    _childScrollDidChangeBlock = ^(UIScrollView *scrollView){
//        weakSelf.childScrollView = scrollView;
//    };
//}

- (void)childScrollViewDidScroll:(UIScrollView *) scrollView{
    if(scrollView.contentOffset.y <= -1 * ceilf(scrollView.contentInset.top)){
        self.childPointY = -1 * ceilf(scrollView.contentInset.top);
    }
    CGFloat y = self.childPointY;
    
    S_Status status = [self getStatus:scrollView];
    if(status == S_Status_Keep){
        return;
    }
    if(status == S_Status_Super_UP || status == S_Status_Super_Down || status == S_Status_Super_Down_Only){
        if(y != ceilf(self.childScrollView.contentOffset.y)){
            self.childScrollView.contentOffset = CGPointMake(0, y);
//            NSLog(@"子 保持不动");
        }
    }else{
        self.childPointY = ceilf(self.childScrollView.contentOffset.y);
//        NSLog(@"子 滑动");
    }
}

- (void)superScrollViewDidScroll:(UIScrollView *) superScrollView{
    if(self.superScrollView.contentOffset.y >= self.superScrollView.contentSize.height -  self.superScrollView.frame.size.height){
        self.superPointY = ceilf(self.superScrollView.contentSize.height -  self.superScrollView.frame.size.height);
    }
    CGFloat y = self.superPointY;
    
    S_Status status = [self getStatus:superScrollView];
    if(status == S_Status_Keep){
        return;
    }

    if(status == S_Status_Child_UP || status == S_Status_Child_Down){
        if(y != ceilf(self.superScrollView.contentOffset.y)){
            self.superScrollView.contentOffset = CGPointMake(0, y);
//            NSLog(@"父 保持不动");
        }
    }else{
        self.superPointY = superScrollView.contentOffset.y;
//        NSLog(@"父 滑动");
    }
}

- (S_Status) getStatus:(UIScrollView *) scrollView{
    S_Status status = S_Status_Keep;
    S_Drection drection = [self getDreationOfScrollView:scrollView];
    if (drection == S_Drection_UP) {
        if ([self isSuperScrolledToBottom]) {
                status = S_Status_Child_UP;
        }else{
                status = S_Status_Super_UP;
        }
    }else if(drection == S_Drection_Down){
        if ([self isChildScrollToTop]){
            status = S_Status_Super_Down;
        }else{
            status = S_Status_Child_Down;
        }
        
        if (scrollView == self.superScrollView ) {
            CGRect rect = [_childScrollView convertRect:_childScrollView.bounds toView:_superScrollView];
            CGFloat y = rect.origin.y + _childScrollView.contentInset.top;
            CGPoint point =  [scrollView.panGestureRecognizer locationInView:scrollView];
            //可以精确计算到子scrll以上都算父视图的滚动
            if (point.y < y) {
                status = S_Status_Super_Down_Only;
            }
        }
    }
    
    return status;
}

- (BOOL)isSuperScrolledToBottom{
    if(self.superScrollView.contentOffset.y + self.superScrollView.frame.size.height >= self.superScrollView.contentSize.height){

        return YES;
    }
    return NO;
}

- (BOOL)isChildScrollToTop{
    if (self.childScrollView.contentOffset.y > -1 * ceilf(self.childScrollView.contentInset.top)) {
        return NO;
    }
    return YES;
}

- (S_Drection)getDreationOfScrollView:(UIScrollView *) scrollView{
    CGFloat currentY = scrollView.contentOffset.y;
    S_Drection drection = S_Drection_None;
    if(scrollView == _superScrollView){
        if (currentY > _superPointY) {
            drection = S_Drection_UP;
        }else if(currentY < _superPointY){
            drection = S_Drection_Down;
        }
    }else if(scrollView == _childScrollView){
        if (currentY > _childPointY) {
            drection = S_Drection_UP;
        }else if(currentY < _childPointY){
            drection = S_Drection_Down;
        }
    }
    return drection;
}


- (void)setSuperScrollView:(UIScrollView *)superScrollView{
    if(self.superScrollView){
        [self.superScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }

    _superScrollView = superScrollView;
    if(superScrollView){
        NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
        [self.superScrollView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
    }
}

- (void)setChildScrollView:(UIScrollView *)childScrollView{
    self.childPointY = ceilf(childScrollView.contentOffset.y);
    
    if (self.childScrollView) {
        [self.childScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }

    _childScrollView = childScrollView;
    if(childScrollView){
        NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
        [self.childScrollView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (!self.superScrollView || !self.childScrollView) {
            //fix by zwq:有时候offset莫名其妙的偏移了
            return;
        }
        if(object == self.superScrollView){
            [self superScrollViewDidScroll:object];
        } else if(object == self.childScrollView){
            [self childScrollViewDidScroll:object];
        }
    }
}

@end
