//
//  PieViews.m
//  Pie
//
//  Created by 阳光 on 2017/3/29.
//  Copyright © 2017年 YG. All rights reserved.
//

#import "PieViews.h"

@interface PieViews ()
{
    //空心圆半径
    CGFloat _pieRadius;
}

/** UIBezierPath */
@property(nonatomic, strong) UIBezierPath *bezierPath;

/** CAShapeLayer */
@property(nonatomic, strong) CAShapeLayer *shapeLayer;



@end


@implementation PieViews

#pragma mark - 初始化方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lineWidth = 20.0f;
        self.backgroundColor = [UIColor clearColor];
        self.pieViewRadius = 35.0f;
    }
    return self;
}

#pragma mark - 饼图制造者
- (instancetype)PieViewMaker
{
    
    if (self.colorArr.count < self.scaleArr.count) {
        return nil;
    }
    
    //当线宽大于等于半径时候, 将为实心圆
    if (self.lineWidth >= self.pieViewRadius) {
        self.lineWidth = self.pieViewRadius;
    }
    
    CGRect pieViewFrame = self.frame;
    pieViewFrame.size.width = self.pieViewRadius * 2;
    pieViewFrame.size.height = self.pieViewRadius * 2;
    
    self.frame = pieViewFrame;
    
    //里面空心圆半径
    _pieRadius = (self.frame.size.width - self.lineWidth) / 2;
    
    // 如果传入数组数量为零 则直接返回
    if (self.scaleArr.count == 0) {
        return nil;
    }
    //如果传入数组数量为1, 则绘制整个圆
    if (self.scaleArr.count == 1) {
        return nil;
    } else {
        //否则正常绘制
        for (int i = 0; i <= self.scaleArr.count - 2; i++) {
            UIBezierPath *path = [UIBezierPath bezierPath];
            
            [path addArcWithCenter:self.center radius:_pieRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
            [self adjust:path];
            [path stroke];
            
            _bezierPath = [UIBezierPath bezierPath];
            [_bezierPath addArcWithCenter:self.center radius:_pieRadius startAngle:[self.scaleArr[i] floatValue] endAngle:[self.scaleArr[i + 1] floatValue]  clockwise:YES];
            
            _shapeLayer = [CAShapeLayer layer];
            _shapeLayer.frame = self.bounds;
            _shapeLayer.path = _bezierPath.CGPath;
            [self adjustPathAndShapeLayer:_bezierPath shapeLayer:_shapeLayer color:((UIColor *)self.colorArr[i + 1])];
            [self.layer addSublayer:_shapeLayer];
        }
        
    }
    return self;
}

#pragma mark - 直接绘制 drawRect
- (void)drawRect:(CGRect)rect {
    if (self.colorArr.count < self.scaleArr.count) {
        return;
    }
    // 如果传入数组数量为零 则直接返回
    if (self.scaleArr.count == 0) {
        return;
    } else {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:self.center radius:_pieRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        [self adjust:path];
        [path stroke];
    }
    
}

- (void)adjustPathAndShapeLayer:(UIBezierPath *)bezierPath shapeLayer:(CAShapeLayer *)shapeLayer color:(UIColor *)color
{
    
    bezierPath.lineWidth = self.lineWidth;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = self.lineWidth;
    shapeLayer.strokeColor = color.CGColor;
}

- (void)adjust:(UIBezierPath *)path
{
    UIColor *color = self.colorArr.firstObject;
    
    path.lineWidth = self.lineWidth;
    [color setStroke];
    
    
}

#pragma mark - 将百分比穿换成pieView使用的百分比数组
- (NSArray *)changeScaleArrayToPieViewArray:(NSArray *)scaleArr
{
    CGFloat total = 0.0f;
    CGFloat start = 0.0f;
    CGFloat end = 0.0f;
    NSMutableArray *mScaleArr = [NSMutableArray array];
    for (int i = 0; i < scaleArr.count; i ++) {
        total += [scaleArr[i] floatValue];
        end = M_PI * 2 * [scaleArr[i] floatValue] + start;
        start = end;
        [mScaleArr addObject:[NSNumber numberWithFloat:end]];
    }
    return [mScaleArr copy];
}


@end
