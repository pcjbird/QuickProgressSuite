//
//  QuickProgressView.h
//  QuickProgressSuite
//
//  Created by pcjbird on 2018/6/21.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @brief 进度条基类
 */
IB_DESIGNABLE
@interface QuickProgressView : UIView

/**
 * @brief 当前进度 (范围: 0~1)
 */
@property (nonatomic, readonly) CGFloat progress;

/**
 * @brief 设置进度
 * @param progress 进度 (范围: 0~1)
 * @param animated 是否动画
 */
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
