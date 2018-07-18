//
//  QuickProgressViewCircle.m
//  QuickProgressSuite
//
//  Created by pcjbird on 2018/6/21.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "QuickProgressViewCircle.h"

#define DegreeToRadian(d) (((d)*M_PI)/180.0)

@interface QuickProgressViewCircle()

@property(nonatomic, strong) CAShapeLayer *trackLayer;
@property(nonatomic, strong) CAShapeLayer *trackMaskLayer;
@property(nonatomic, strong) CAShapeLayer *foreLayer;
@property (nonatomic, assign) CGFloat lastProgress;
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
    if([self.trackLayer isKindOfClass:[CAShapeLayer class]])
    {
        self.trackLayer.frame = self.bounds;
    }
    if([self.foreLayer isKindOfClass:[CAShapeLayer class]])
    {
        self.foreLayer.frame = self.bounds;
    }
}

-(void) initVariables
{
    _trackWidth = 3.0f;
    _progressWidth = 3.0f;
    _startAngle = -90.0f;
    _reduceAngle = 0.0f;
    _progressColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    _trackColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    _lineCap = QUICKPROGRESSCIRCLELINECAP_ROUND;
    self.lastProgress = self.progress;
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
    [self.layer addSublayer:[self trackLayer]];
    [self.layer addSublayer:[self foreLayer]];
}

-(void)setTrackWidth:(CGFloat)trackWidth
{
    _trackWidth = trackWidth;
    if([self.trackLayer isKindOfClass:[CAShapeLayer class]])
    {
        self.trackLayer.lineWidth = trackWidth;
    }
}

-(void)setTrackColor:(UIColor *)trackColor
{
    if(![trackColor isKindOfClass:[UIColor class]]) trackColor = [UIColor clearColor];
    _trackColor = trackColor;
    if([self.trackLayer isKindOfClass:[CAShapeLayer class]])
    {
        self.trackLayer.strokeColor = trackColor.CGColor;
    }
}

-(void)setProgressWidth:(CGFloat)progressWidth
{
    _progressWidth = progressWidth;
    if([self.foreLayer isKindOfClass:[CAShapeLayer class]])
    {
        self.foreLayer.lineWidth = progressWidth;
    }
    if([self.trackMaskLayer isKindOfClass:[CAShapeLayer class]])
    {
        self.trackMaskLayer.lineWidth = progressWidth;
    }
}

-(void)setProgressColor:(UIColor *)progressColor
{
    if(![progressColor isKindOfClass:[UIColor class]]) progressColor = [UIColor clearColor];
    _progressColor = progressColor;
    if([self.foreLayer isKindOfClass:[CAShapeLayer class]])
    {
        self.foreLayer.strokeColor = progressColor.CGColor;
    }
}

-(CAShapeLayer*)trackLayer
{
    if(![_trackLayer isKindOfClass:[CAShapeLayer class]])
    {
        _trackLayer = [CAShapeLayer layer];
        _trackLayer.fillColor = [UIColor clearColor].CGColor;
        _trackLayer.strokeColor = self.trackColor.CGColor;
        _trackLayer.lineWidth = self.trackWidth;
        _trackLayer.lineCap = [self lineCapString];
        _trackLayer.frame = self.bounds;
        
        UIBezierPath * path = [self getNewBezierPath];
        _trackLayer.path = path.CGPath;
        //_trackLayer.mask = self.trackMaskLayer;
    }
    return _trackLayer;
}

-(CAShapeLayer*)trackMaskLayer
{
    if(![_trackMaskLayer isKindOfClass:[CAShapeLayer class]])
    {
        _trackMaskLayer = [CAShapeLayer layer];
        _trackMaskLayer.fillColor = [UIColor clearColor].CGColor;
        _trackMaskLayer.strokeColor = self.progressColor.CGColor;
        _trackMaskLayer.lineWidth = self.progressWidth;
        _trackMaskLayer.frame = self.bounds;
        UIBezierPath *circlePath = [self getNewBezierPath];
        _trackMaskLayer.path = circlePath.CGPath;
        _trackMaskLayer.lineCap = [self lineCapString];
        _trackMaskLayer.strokeEnd = self.progress;
    }
    return _trackMaskLayer;
}

-(CAShapeLayer*)foreLayer
{
    if(![_foreLayer isKindOfClass:[CAShapeLayer class]])
    {
        _foreLayer = [CAShapeLayer layer];
        _foreLayer.fillColor = [UIColor clearColor].CGColor;
        _foreLayer.strokeColor = self.progressColor.CGColor;
        _foreLayer.lineWidth = self.progressWidth;
        _foreLayer.frame = self.bounds;
        UIBezierPath *circlePath = [self getNewBezierPath];
        _foreLayer.path = circlePath.CGPath;
        _foreLayer.lineCap = [self lineCapString];
        _foreLayer.strokeEnd = self.progress;
    }
    return _foreLayer;
}

-(NSString *) lineCapString
{
    switch (self.lineCap) {
        case QUICKPROGRESSCIRCLELINECAP_BUTT:
        {
            return @"butt";
            break;
        }
        case QUICKPROGRESSCIRCLELINECAP_ROUND:
        {
            return @"round";
            break;
        }
        case QUICKPROGRESSCIRCLELINECAP_SQUARE:
        {
            return @"square";
            break;
        }
        default:
            break;
    }
    return @"butt";
}

- (UIBezierPath *)getNewBezierPath
{
    CGRect rect = self.bounds;
    CGPoint center = {CGRectGetMidX(rect), CGRectGetMidY(rect)};
    CGFloat radius = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect))/2 - MAX(self.trackWidth, self.progressWidth)/2.f;
    return [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:DegreeToRadian(self.startAngle) endAngle:DegreeToRadian(self.startAngle + 360.0f - self.reduceAngle) clockwise:YES];
}

-(void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    [super setProgress:progress animated:animated];
   
    //tracklayer
    if([self.trackLayer isKindOfClass:[CAShapeLayer class]])
    {
        UIBezierPath * path = [self getNewBezierPath];
        self.trackLayer.path = path.CGPath;
    }
    
    //trackMasklayer
    if([self.trackMaskLayer isKindOfClass:[CAShapeLayer class]])
    {
        
        UIBezierPath * path = [self getNewBezierPath];
        
        if(animated)
        {
            _trackMaskLayer.path         = path.CGPath;
            CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            basicAnimation.duration          = 1.0;
            basicAnimation.fromValue = [NSNumber numberWithFloat:self.lastProgress];
            basicAnimation.toValue = [NSNumber numberWithFloat:progress];//
            basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            basicAnimation.fillMode = kCAFillModeForwards;
            basicAnimation.removedOnCompletion = NO;
            [self.trackMaskLayer addAnimation:basicAnimation forKey:@"strokeEnd"];
        }
        else
        {
            _trackMaskLayer.path         = path.CGPath;
            _trackMaskLayer.strokeEnd = self.progress;
        }
    }
    
    //forelayer
    if([self.foreLayer isKindOfClass:[CAShapeLayer class]])
    {
        
        UIBezierPath * path = [self getNewBezierPath];
        
        if(animated)
        {
            _foreLayer.path         = path.CGPath;
            CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            basicAnimation.duration          = 1.0;
            basicAnimation.fromValue = [NSNumber numberWithFloat:self.lastProgress];
            basicAnimation.toValue = [NSNumber numberWithFloat:progress];//
            basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            basicAnimation.fillMode = kCAFillModeForwards;
            basicAnimation.removedOnCompletion = NO;
            [self.foreLayer addAnimation:basicAnimation forKey:@"strokeEnd"];
        }
        else
        {
            _foreLayer.path         = path.CGPath;
            _foreLayer.strokeEnd = self.progress;
        }
    }
    self.lastProgress = progress;
    [self.layer setNeedsLayout];
}

@end
