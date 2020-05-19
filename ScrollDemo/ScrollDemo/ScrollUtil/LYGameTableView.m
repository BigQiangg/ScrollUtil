//
//  LYGameTableView.m
//  laoyuegou
//
//  Created by zwq on 2018/8/7.
//  Copyright © 2018年 HaiNanLexin. All rights reserved.
//

#import "LYGameTableView.h"

@implementation LYGameTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"LYGameScrollView")]) {
        return YES;
    }
    return NO;
}


@end
