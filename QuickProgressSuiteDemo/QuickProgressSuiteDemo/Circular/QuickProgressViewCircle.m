//
//  QuickProgressViewCircle.m
//  QuickProgressSuite
//
//  Created by pcjbird on 2018/6/21.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "QuickProgressViewCircle.h"

@interface QuickProgressViewCircle()

@property(nonatomic, strong) CAShapeLayer *emptyLineLayer;
@property(nonatomic, strong) CAShapeLayer *emptyMaskLayer;
@property(nonatomic, strong) CAShapeLayer *progressLayer;

@end

@implementation QuickProgressViewCircle

-(instancetype)init
{
    if(self = [super init])
    {
        [self initVariables];
        [self initView];
        [self createSubLayers];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self initVariables];
        [self initView];
        [self createSubLayers];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self initVariables];
        [self initView];
        [self createSubLayers];
    }
    return self;
}

-(void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    //if(layer == self.emptyLineLayer)
    {
        _emptyLineLayer.frame = self.bounds;
        _emptyMaskLayer = [CAShapeLayer layer];
        _emptyMaskLayer.frame = self.bounds;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
        [path appendPath:[self createProgressPath]];
        
        path.usesEvenOddFillRule = YES;
        //_emptyMaskLayer.fillColor = [UIColor blackColor].CGColor;
        _emptyMaskLayer.path = path.CGPath;
        _emptyMaskLayer.fillRule = kCAFillRuleEvenOdd;
        UIBezierPath * linePath = [self createEmptyLinePath];
        //[linePath appendPath:path];
        //_emptyLineLayer.fillRule = kCAFillRuleEvenOdd;
        _emptyLineLayer.path = linePath.CGPath;
        
        _emptyLineLayer.mask = _emptyMaskLayer;
    }
    //else if(layer == self.progressLayer)
    {
        _progressLayer.frame = self.bounds;
        _progressLayer.path = [self createProgressPath].CGPath;
    }
}

-(void) initVariables
{
    _emptyLineWidth = 3;
    UISlider *slider;
    _progressLineWidth = 6;
    
    _progressRotationAngle = 0;
    _progressAngle = 100.0f;
    _progressColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    _progressStrokeColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
    _emptyLineColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    _emptyLineStrokeColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
    _emptyCapType = kCGLineCapRound;
    _progressCapType = kCGLineCapRound;
}

-(void) initView
{
    [self setProgress:0.5f animated:NO];
    self.backgroundColor = [UIColor clearColor];
    
    //Without setting the content scale factor the layer would be pixelated
    [self setContentScaleFactor:[[UIScreen mainScreen] scale]];
    
    //This mode forces redrawing when bounds change (e.g. bounds change in animation)
    [self setContentMode:UIViewContentModeRedraw];
}

-(void) createSubLayers
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bounds;
    layer.fillColor = [UIColor redColor].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 100, 100)];
    layer.path = path.CGPath;
    //[self.layer addSublayer:layer];
    [self.layer addSublayer:[self emptyLineLayer]];
    [self.layer addSublayer:[self progressLayer]];
}

-(CAShapeLayer*)emptyLineLayer
{
    if(![_emptyLineLayer isKindOfClass:[CAShapeLayer class]])
    {
        _emptyLineLayer = [CAShapeLayer layer];
        _emptyLineLayer.fillColor = self.emptyLineColor.CGColor;
        _emptyMaskLayer.strokeColor = self.emptyLineStrokeColor.CGColor;
        
        //_emptyLineLayer.path = [self createEmptyLinePath].CGPath;
        //UIBezierPath *path = [self createProgressPath];
        //path.usesEvenOddFillRule = YES;
        //_emptyMaskLayer.path = path.CGPath;
        //_emptyMaskLayer.fillRule = kCAFillRuleEvenOdd;
        //_emptyLineLayer.fillRule = kCAFillRuleEvenOdd;
        //_emptyLineLayer.mask = _emptyMaskLayer;//[self emptyMaskLayer];
    }
    return _emptyLineLayer;
}

-(CAShapeLayer*)emptyMaskLayer
{
    if(![_emptyMaskLayer isKindOfClass:[CAShapeLayer class]])
    {
        _emptyMaskLayer = [CAShapeLayer layer];
        UIBezierPath *path = [self createProgressPath];
        path.usesEvenOddFillRule = YES;
        _emptyMaskLayer.path = path.CGPath;
        _emptyMaskLayer.fillRule = kCAFillRuleEvenOdd;
    }
    return _emptyMaskLayer;
}

-(CAShapeLayer*)progressLayer
{
    if(![_progressLayer isKindOfClass:[CAShapeLayer class]])
    {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.fillColor = self.progressColor.CGColor;
        _progressLayer.strokeColor = self.progressStrokeColor.CGColor;
        _progressLayer.path = [self createProgressPath].CGPath;
    }
    return _progressLayer;
}

-(UIBezierPath *) createEmptyLinePath
{
    
    CGRect rect = self.bounds;
    CGPoint center = {CGRectGetMidX(rect), CGRectGetMidY(rect)};
    CGFloat radius = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect))/2 - MAX(self.emptyLineWidth, self.progressLineWidth)/2.f;
    
    CGMutablePathRef arc = CGPathCreateMutable();
    //CGPathAddArc(arc, NULL, center.x, center.y, radius, 0, 1.0*M_PI, YES);
    CGFloat startAngle = 0;//(self.progressAngle/100.f)*M_PI-((-self.progressRotationAngle/100.f)*2.f+0.5)*M_PI;
    CGFloat endAngle = 2*M_PI;//(self.progressAngle/100.f)*M_PI-((-self.progressRotationAngle/100.f)*2.f+0.5)*M_PI -(2.f*M_PI)*(self.progressAngle/100.f)*(100.f-100.f*self.progress)/100.f;
    CGPathAddArc(arc, NULL,
                 center.x, center.y, radius,
                 startAngle,
                 //-(self.progressAngle/100.f)*M_PI-((-self.progressRotationAngle/100.f)*2.f+0.5)*M_PI,
                  endAngle/*- (2.f*M_PI)*(self.progressAngle/100.f)**/,
                 YES);
    
    
    CGPathRef strokedArc =
    CGPathCreateCopyByStrokingPath(arc, NULL,
                                   self.emptyLineWidth,
                                   (CGLineCap)self.emptyCapType,
                                   kCGLineJoinMiter,
                                   10);
    UIBezierPath * path = [UIBezierPath bezierPathWithCGPath:strokedArc];
    CGPathRelease(arc);
    CGPathRelease(strokedArc);
    
    return path;
}

-(UIBezierPath *) createProgressPath
{
    CGRect rect = self.bounds;
    CGPoint center = {CGRectGetMidX(rect), CGRectGetMidY(rect)};
    CGFloat radius = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect))/2 - MAX(self.emptyLineWidth, self.progressLineWidth)/2.f;
    
    CGMutablePathRef arc = CGPathCreateMutable();
    CGPathAddArc(arc, NULL,
                 center.x, center.y, radius,
                 (self.progressAngle/100.f)*M_PI-((-self.progressRotationAngle/100.f)*2.f+0.5)*M_PI -(2.f*M_PI)*(self.progressAngle/100.f)*(100.f-100.f*self.progress)/100.f ,
                 -(self.progressAngle/100.f)*M_PI-((-self.progressRotationAngle/100.f)*2.f+0.5)*M_PI,
                 YES);
    
    CGPathRef strokedArc =
    CGPathCreateCopyByStrokingPath(arc, NULL,
                                   self.progressLineWidth,
                                   (CGLineCap)self.progressCapType,
                                   kCGLineJoinMiter,
                                   10);
    UIBezierPath * path = [UIBezierPath bezierPathWithCGPath:strokedArc];
    CGPathRelease(arc);
    CGPathRelease(strokedArc);
    
    return path;
}

-(void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    [super setProgress:progress animated:animated];
    
    /*CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    basicAnimation.duration          = 0.5;
    basicAnimation.fromValue         = (__bridge id)(self.lineShapeLayer.path);
    basicAnimation.toValue           = (__bridge id)newPath.CGPath;
    self.lineShapeLayer.path         = newPath.CGPath;
    self.fillShapeLayer.path         = newPath.CGPath;
    [self.lineShapeLayer addAnimation:basicAnimation forKey:@"lineShapeLayerPath"];
    [self.fillShapeLayer addAnimation:basicAnimation forKey:@"fillShapeLayerPath"];*/
    
    //[self.layer setNeedsLayout];
}

@end
