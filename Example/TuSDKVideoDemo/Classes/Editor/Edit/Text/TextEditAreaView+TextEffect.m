//
//  TextEditAreaView+TextEffect.m
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/11/13.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "TextEditAreaView+TextEffect.h"
#import "TextItemTransformControl.h"
#import "TuSDKFramework.h"

@interface TextEditAreaView ()

/**
 文字项数组
 */
@property (nonatomic, strong, readonly) NSMutableArray<TextItemTransformControl *> *textItemControls;

@end

@implementation TextEditAreaView (TextEffect)

- (NSArray<TuSDKMediaTextEffect *> *)generateTextEffectsWithVideoSize:(CGSize)videoSize {
    NSMutableArray *textEffects = [NSMutableArray array];
    
    for (TextItemTransformControl *textItemControl in self.textItemControls) {
        AttributedLabel *textLabel = textItemControl.textLabel;
        CGRect textFrame = [textLabel.superview convertRect:textLabel.frame toView:self];
        CGRect centerRect = [self centerRectWithTextFrame:textFrame];
        UIImage *image = [self textImageWithItemLabel:textLabel];
        CGAffineTransform transform = textItemControl.transform;
        // 弧度
        double radian = atan2f(transform.b, transform.a);
        // 角度
        double degree = radian * (180 / M_PI);
        
        // 创建 text effect
        CMTimeRange timeRange = textLabel.timeRange;
        TuSDKMediaTextEffect *textEffect = [[TuSDKMediaTextEffect alloc] initWithStickerImage:image center:centerRect degree:degree designSize:videoSize];
        textEffect.atTimeRange = [TuSDKTimeRange makeTimeRangeWithStart:timeRange.start duration:timeRange.duration];
        [textEffects addObject:textEffect];
    }
    
    return textEffects.copy;
}

#pragma mark - util

/**
 由给定 texlLabel 矢量拉伸后生成图片
 
 @param textLabel 文字标签
 @return 图片
 */
- (UIImage *)textImageWithItemLabel:(AttributedLabel *)textLabel {
    CGRect originFrame = textLabel.frame;
    UIFont *originFont = textLabel.font;
    UIEdgeInsets originEdgeInsets = textLabel.edgeInsets;
    
    CGFloat textScale = self.textScale;
    textLabel.edgeInsets = UIEdgeInsetsMake(kTextEdgeInset * textScale, kTextEdgeInset * textScale, kTextEdgeInset * textScale, kTextEdgeInset * textScale);
    NSString *fontName = textLabel.font.fontName;
    textLabel.font = [UIFont fontWithName:fontName size:textLabel.font.pointSize * textScale];
    CGPoint center = textLabel.center;
    textLabel.center = center;
    
    UIGraphicsBeginImageContextWithOptions(textLabel.intrinsicContentSize, NO, .0);
    [textLabel.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    textLabel.font = originFont;
    textLabel.edgeInsets = originEdgeInsets;
    textLabel.frame = originFrame;
    
    return image;
}

/**
 生成基于中点的百分比 frame
 
 @param textFrame 文字的 frame
 @return rect 尺寸比例
 */
- (CGRect)centerRectWithTextFrame:(CGRect)textFrame {
    CGFloat x = CGRectGetMidX(textFrame);
    CGFloat y = CGRectGetMidY(textFrame);
    CGFloat w = CGRectGetWidth(textFrame);
    CGFloat h = CGRectGetHeight(textFrame);
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    x /= width;
    y /= height;
    w /= width;
    h /= height;
    return CGRectMake(x, y, w, h);
}

@end
