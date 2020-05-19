//
//  LYScrollUtil.h
//  laoyuegou
//
//  Created by zwq on 2018/8/10.
//  Copyright © 2018年 HaiNanLexin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYScrollUtil : NSObject

@property(nonatomic,strong) UIScrollView * superScrollView;

@property(nonatomic,strong) UIScrollView * childScrollView;

//子scrollvew发生变化时使用这个回调
//@property(nonatomic,copy,readonly) void(^childScrollDidChangeBlock)(UIScrollView * scrollView);

@end
