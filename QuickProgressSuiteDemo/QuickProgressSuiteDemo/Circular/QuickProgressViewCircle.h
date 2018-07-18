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
 *  起点角度。角度从水平右侧开始为0，顺时针为增加角度。直接传度数 如-90.0
 *  默认-90.0
 */
@property (nonatomic, assign) IBInspectable CGFloat startAngle;

/**
 *  减少的角度 直接传度数 [0,360) 如30
 *  默认0.0
 */
@property (nonatomic, assign) IBInspectable CGFloat reduceAngle;

/**
 * @brief 进度条宽度 The width of the progress bar [0,∞)
 */
@property (nonatomic,assign) IBInspectable CGFloat progressWidth;

/**
 * @brief 进度条前景色 The color of the progress bar
 */
@property (nonatomic,strong) IBInspectable UIColor* progressColor;


/**
 * The width of the background bar (user space units)    [0,∞)
 */
@property (nonatomic,assign) IBInspectable CGFloat trackWidth;

/**
 * The color of the background bar
 */
@property (nonatomic,strong) IBInspectable UIColor* trackColor;

/**
 * @brief 进度条线的顶点绘制类型 The shape of the progress bar cap
 */
@property (nonatomic,assign) IBInspectable QUICKPROGRESSCIRCLELINECAP lineCap;
@end
