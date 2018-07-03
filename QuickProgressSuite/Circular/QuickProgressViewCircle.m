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
@property(nonatomic, strong) CAShapeLayer *progressLayer;

@end

@implementation QuickProgressViewCircle

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        
    }
    return self;
}

-(CAShapeLayer*)emptyLineLayer
{
    if(![_emptyLineLayer isKindOfClass:[CAShapeLayer class]])
    {
        _emptyLineLayer = [CAShapeLayer layer];
    }
    return _emptyLineLayer;
}

-(CAShapeLayer*)progressLayer
{
    if(![_progressLayer isKindOfClass:[CAShapeLayer class]])
    {
        _progressLayer = [CAShapeLayer layer];
    }
    return _progressLayer;
}

-(UIBezierPath *) createEmptyLinePath
{
    
    CGRect rect = self.bounds;
    CGPoint center = {CGRectGetMidX(rect), CGRectGetMidY(rect)};
    CGFloat radius = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect))/2 - MAX(self.emptyLineWidth, self.progressLineWidth)/2.f;
    
    CGMutablePathRef arc = CGPathCreateMutable();
    CGPathAddArc(arc, NULL,
                 center.x, center.y, radius,
                 (self.progressAngle/100.f)*M_PI-((-self.progressRotationAngle/100.f)*2.f+0.5)*M_PI,
                 //-(self.progressAngle/100.f)*M_PI-((-self.progressRotationAngle/100.f)*2.f+0.5)*M_PI,
                 (self.progressAngle/100.f)*M_PI-((-self.progressRotationAngle/100.f)*2.f+0.5)*M_PI -(2.f*M_PI)*(self.progressAngle/100.f)*(100.f-100.f*self.progress)/100.f /*- (2.f*M_PI)*(self.progressAngle/100.f)**/,
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

@end
