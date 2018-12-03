//
//  RecordButton.h
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/7/2.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 录制按钮
 */
@interface RecordButton : UIButton

/**
 内容适配大小
 */
@property (nonatomic, assign) CGSize contentSize;

/**
 背景圆点颜色
 */
@property (nonatomic, strong) UIColor *backgroundDotColor;

/**
 前景圆点颜色
 */
@property (nonatomic, strong) UIColor *dotColor;

/**
 背景圆点与前景圆点直径比率
 */
@property (nonatomic, assign) double backgroundDotRatio;

@end
