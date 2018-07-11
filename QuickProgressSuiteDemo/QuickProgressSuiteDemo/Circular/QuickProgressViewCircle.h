//
//  QuickProgressViewCircle.h
//  QuickProgressSuite
//
//  Created by pcjbird on 2018/6/21.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "QuickProgressView.h"

/**
 * @brief 顶点绘制类型
 */
typedef NS_ENUM(NSInteger, QUICKPROGRESSCIRCLELINECAP)
{
    QUICKPROGRESSCIRCLELINECAP_BUTT = 0,                   //不绘制顶点
    QUICKPROGRESSCIRCLELINECAP_ROUND = 1,                  //绘制圆形顶点
    QUICKPROGRESSCIRCLELINECAP_SQUARE = 2,                 //绘制方形顶点
};

/**
 * @brief 环形进度条(圆形进度条)
 */
IB_DESIGNABLE
@interface QuickProgressViewCircle : QuickProgressView


/**
 * @brief 进度条宽度 The width of the progress bar
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
 * @brief 进度条线的顶点绘制类型 The shape of the progress bar cap
 */
@property (nonatomic,assign) IBInspectable QUICKPROGRESSCIRCLELINECAP lineCap;

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



@end
