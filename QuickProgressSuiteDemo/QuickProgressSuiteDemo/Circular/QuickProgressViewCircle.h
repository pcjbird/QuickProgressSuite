//
//  QuickProgressViewCircle.h
//  QuickProgressSuite
//
//  Created by pcjbird on 2018/6/21.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "QuickProgressView.h"

/**
 * @brief 环形进度条(圆形进度条)
 */
IB_DESIGNABLE
@interface QuickProgressViewCircle : QuickProgressView

/**
 * Progress bar rotation (Clockewise)    [0,100]
 */
@property (nonatomic,assign) IBInspectable CGFloat   progressRotationAngle;

/**
 * Set a partial angle for the progress bar    [0,100]
 */
@property (nonatomic,assign) IBInspectable CGFloat   progressAngle;

/**
 * @brief 进度条宽度 The width of the progress bar (user space units)    [0,∞)
 */
@property (nonatomic,assign) IBInspectable CGFloat   progressLineWidth;

/**
 * @brief 进度条前景色 The color of the progress bar
 */
@property (nonatomic,strong) IBInspectable UIColor   *progressColor;

/**
 * @brief 进度条描边着色 The color of the progress bar frame
 */
@property (nonatomic,strong) IBInspectable UIColor   *progressStrokeColor;

/**
 * @brief 进度条定点类型 The shape of the progress bar cap    {kCGLineCapButt=0, kCGLineCapRound=1, kCGLineCapSquare=2}
 */
@property (nonatomic,assign) IBInspectable NSInteger progressCapType;

/**
 * The width of the background bar (user space units)    [0,∞)
 */
@property (nonatomic,assign) IBInspectable CGFloat   emptyLineWidth;

/**
 * The color of the background bar
 */
@property (nonatomic,strong) IBInspectable UIColor   *emptyLineColor;

/**
 * The color of the background bar stroke color
 */
@property (nonatomic,strong) IBInspectable UIColor   *emptyLineStrokeColor;

/**
 * The shape of the background bar cap    {kCGLineCapButt=0, kCGLineCapRound=1, kCGLineCapSquare=2}
 */
@property (nonatomic,assign) IBInspectable NSInteger emptyCapType;


@end
