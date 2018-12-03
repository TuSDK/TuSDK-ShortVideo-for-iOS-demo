//
//  RecordButton.m
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/7/2.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "RecordButton.h"

@interface RecordButton ()

/**
 背景圆点图层
 */
@property (nonatomic, strong) CAShapeLayer *backgroundDotLayer;

/**
 前景圆点图层
 */
@property (nonatomic, strong) CAShapeLayer *dotLayer;

@end

@implementation RecordButton

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    self.tintColor = [UIColor whiteColor];
    _backgroundDotColor = [UIColor colorWithWhite:1 alpha:0.6];
    _dotColor = [UIColor colorWithRed:254.0f/255.0f green:58.0f/255.0f blue:58.0f/255.0f alpha:1.0f];
    _backgroundDotRatio = 7/9.0;
    
    _dotLayer = [CAShapeLayer layer];
    [self.layer insertSublayer:_dotLayer atIndex:0];
    _dotLayer.fillColor = _dotColor.CGColor;
    
    _backgroundDotLayer = [CAShapeLayer layer];
    [self.layer insertSublayer:_backgroundDotLayer atIndex:0];
    _backgroundDotLayer.fillColor = _backgroundDotColor.CGColor;
    
    [self addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchEndAction:) forControlEvents:UIControlEventTouchCancel | UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _backgroundDotLayer.frame = _dotLayer.frame = self.bounds;
    _backgroundDotLayer.path = [self circleWithRadiusInset:0].CGPath;
    _dotLayer.path = [self circleWithRadiusScale:_backgroundDotRatio].CGPath;
    [self bringSubviewToFront:self.imageView];
}

/**
 创建圆形路径

 @param radiusInset 半径缩进
 @return 圆形路径
 */
- (UIBezierPath *)circleWithRadiusInset:(CGFloat)radiusInset {
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = center.x + radiusInset;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    return path;
}

/**
 创建圆形路径

 @param radiusScale 半径缩放
 @return 圆形路径
 */
- (UIBezierPath *)circleWithRadiusScale:(CGFloat)radiusScale {
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = center.x * radiusScale;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    return path;
}

#pragma mark - property

- (void)setContentSize:(CGSize)contentSize {
    _contentSize = contentSize;
    [self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
    return _contentSize;
}

- (void)setBackgroundDotColor:(UIColor *)backgroundDotColor {
    _backgroundDotColor = backgroundDotColor;
    _backgroundDotLayer.fillColor = _dotColor.CGColor;
}

- (void)setDotColor:(UIColor *)dotColor {
    _dotColor = dotColor;
    _dotLayer.fillColor = _dotColor.CGColor;
}

- (void)setBackgroundDotRatio:(double)backgroundDotRatio {
    _backgroundDotRatio = backgroundDotRatio;
    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        [self touchDownAction:nil];
    } else {
        [self touchEndAction:nil];
    }
}

#pragma mark - action

/**
 按下事件
 */
- (void)touchDownAction:(UIButton *)sender {
    NSString *transformKey = @"transform.scale";
    [_backgroundDotLayer setValue:@(7/6.0) forKeyPath:transformKey];
    [_dotLayer setValue:@(6/7.0) forKeyPath:transformKey];
}

/**
 抬起事件
 */
- (void)touchEndAction:(UIButton *)sender {
    _backgroundDotLayer.affineTransform = CGAffineTransformIdentity;
    _dotLayer.affineTransform = CGAffineTransformIdentity;
}

@end
