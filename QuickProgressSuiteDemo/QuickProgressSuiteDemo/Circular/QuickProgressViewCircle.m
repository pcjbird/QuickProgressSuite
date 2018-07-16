//
//  QuickProgressViewCircle.m
//  QuickProgressSuite
//
//  Created by pcjbird on 2018/6/21.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "QuickProgressViewCircle.h"

@interface QuickProgressViewCircle()

@property(nonatomic, strong) CAShapeLayer *emptyLayer;
@property(nonatomic, strong) CAShapeLayer *emptyMaskLayer;
@property(nonatomic, strong) CAShapeLayer *foreLayer;

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
    if(_emptyLayer)
    {
        _emptyLayer.frame = self.bounds;
    }
    if(_emptyMaskLayer)
    {
        _emptyMaskLayer.frame = self.bounds;
    }
    if(_foreLayer)
    {
        _foreLayer.frame = self.bounds;
    }
}

-(void) initVariables
{
    _emptyLineWidth = 3;
    _lineWidth = 6;
    _rotation = 0.5;
    _partial = 1.0f;
    _color = [UIColor colorWithWhite:1.0f alpha:0.5f];
    _strokeColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
    _emptyColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    _emptyStrokeColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
    _lineCap = QUICKPROGRESSCIRCLELINECAP_ROUND;
    [self setProgress:0.0f animated:NO];
}

-(void) initView
{
    self.backgroundColor = [UIColor clearColor];
    
    //Without setting the content scale factor the layer would be pixelated
    [self setContentScaleFactor:[[UIScreen mainScreen] scale]];
    
    //This mode forces redrawing when bounds change (e.g. bounds change in animation)
    [self setContentMode:UIViewContentModeRedraw];
}

-(void) createSubLayers
{
    [self.layer addSublayer:[self emptyLayer]];
    [self.layer addSublayer:[self foreLayer]];
}

-(CAShapeLayer*)emptyLayer
{
    if(![_emptyLayer isKindOfClass:[CAShapeLayer class]])
    {
        _emptyLayer = [CAShapeLayer layer];
        _emptyLayer.fillColor = self.emptyColor.CGColor;
        _emptyMaskLayer.strokeColor = self.emptyStrokeColor.CGColor;
        
        _emptyLayer.frame = self.bounds;
        _emptyMaskLayer = [CAShapeLayer layer];
        _emptyMaskLayer.frame = self.bounds;
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
        [maskPath appendPath:[self createForeLayerPath]];
        maskPath.usesEvenOddFillRule = YES;
        
        _emptyMaskLayer.path = maskPath.CGPath;
        _emptyMaskLayer.fillRule = kCAFillRuleEvenOdd;
        
        UIBezierPath * path = [self createEmptyLayerPath];
        _emptyLayer.path = path.CGPath;
        _emptyLayer.mask = _emptyMaskLayer;
    }
    return _emptyLayer;
}

-(CAShapeLayer*)foreLayer
{
    if(![_foreLayer isKindOfClass:[CAShapeLayer class]])
    {
        _foreLayer = [CAShapeLayer layer];
        _foreLayer.fillColor = self.color.CGColor;
        _foreLayer.strokeColor = self.strokeColor.CGColor;
        _foreLayer.frame = self.bounds;
        _foreLayer.path = [self createForeLayerPath].CGPath;
    }
    return _foreLayer;
}

-(UIBezierPath *) createEmptyLayerPath
{
    
    CGRect rect = self.bounds;
    CGPoint center = {CGRectGetMidX(rect), CGRectGetMidY(rect)};
    CGFloat radius = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect))/2 - MAX(self.emptyLineWidth, self.lineWidth)/2.f;
    
    CGMutablePathRef arc = CGPathCreateMutable();
    
    CGFloat startAngle = 0;
    CGFloat endAngle = 2*M_PI;
    CGPathAddArc(arc, NULL, center.x, center.y, radius, startAngle, endAngle, YES);
    
    CGPathRef strokedArc = CGPathCreateCopyByStrokingPath(arc, NULL, self.emptyLineWidth, (CGLineCap)self.lineCap, kCGLineJoinMiter, 10);
    UIBezierPath * path = [UIBezierPath bezierPathWithCGPath:strokedArc];
    CGPathRelease(arc);
    CGPathRelease(strokedArc);
    
    return path;
}

-(UIBezierPath *) createForeLayerPath
{
    CGRect rect = self.bounds;
    CGPoint center = {CGRectGetMidX(rect), CGRectGetMidY(rect)};
    CGFloat radius = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect))/2 - MAX(self.emptyLineWidth, self.lineWidth)/2.f;
    
    CGMutablePathRef arc = CGPathCreateMutable();
    CGPathAddArc(arc, NULL, center.x, center.y, radius, (self.partial)*M_PI-((-self.rotation)*2.f+0.5)*M_PI -(2.f*M_PI)*(_partial)*(100.f-100.f*self.progress)/100.f , -(self.partial)*M_PI-((-self.rotation)*2.f+0.5)*M_PI,
                 YES);
    
    CGPathRef strokedArc =
    CGPathCreateCopyByStrokingPath(arc, NULL, self.lineWidth, (CGLineCap)self.lineCap, kCGLineJoinMiter, 10);
    UIBezierPath * path = [UIBezierPath bezierPathWithCGPath:strokedArc];
    CGPathRelease(arc);
    CGPathRelease(strokedArc);
    
    return path;
}

-(void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    [super setProgress:progress animated:animated];
    
    //emptylayer
    if(_emptyLayer)
    {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
        [maskPath appendPath:[self createForeLayerPath]];
        maskPath.usesEvenOddFillRule = YES;
        
        UIBezierPath * path = [self createEmptyLayerPath];
        
        if(animated)
        {
            CABasicAnimation *maskAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
            maskAnimation.duration          = 0.5;
            maskAnimation.fromValue         = (__bridge id)(_emptyMaskLayer.path);
            maskAnimation.toValue           = (__bridge id)maskPath.CGPath;
            _emptyMaskLayer.path         = maskPath.CGPath;
            [self.emptyMaskLayer addAnimation:maskAnimation forKey:@"emptyMaskLayerPath"];
            
            CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
            basicAnimation.duration          = 0.5;
            basicAnimation.fromValue         = (__bridge id)(_emptyMaskLayer.path);
            basicAnimation.toValue           = (__bridge id)path.CGPath;
            _emptyLayer.path         = path.CGPath;
            [self.emptyLayer addAnimation:basicAnimation forKey:@"emptyLayerPath"];
        }
        else
        {
            _emptyMaskLayer.path = maskPath.CGPath;
            _emptyLayer.path = path.CGPath;
        }
    }
    
    //forelayer
    if(_foreLayer)
    {
        
        UIBezierPath * path = [self createForeLayerPath];
        
        if(animated)
        {
            CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
            basicAnimation.duration          = 0.5;
            basicAnimation.fromValue         = (__bridge id)(_emptyLayer.path);
            basicAnimation.toValue           = (__bridge id)path.CGPath;
            _foreLayer.path         = path.CGPath;
            [self.foreLayer addAnimation:basicAnimation forKey:@"foreLayerPath"];
        }
        else
        {
            _foreLayer.path = path.CGPath;
        }
    }
    [self.layer setNeedsLayout];
}

@end
