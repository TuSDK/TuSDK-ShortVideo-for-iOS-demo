//
//  TuSDKMediaTextEffectData.h
//  TuSDKVideo
//
//  Created by songyf on 2018/6/5.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "TuSDKMediaEffectData.h"
#import "TuSDKVideoImport.h"

/**
 文字贴图数据类
 @since v2.2.0
 */
@interface TuSDKMediaTextEffectData : TuSDKMediaEffectData

/**
 初始化方法
 @param textStickImage TuSDKTextStickerImage
 @return TuSDKMediaTextEffectData
 @since v2.2.0
 */
- (instancetype)initWithStickerText:(TuSDKPFStickerText *)stickerText center:(CGRect)center degree:(CGFloat)degree designSize:(CGSize)designSize;

/**
 初始化方法
 @param stickerImage UIImage
 @return TuSDKMediaTextEffectData
 @since v2.2.0
 */
- (instancetype)initWithStickerImage:(UIImage *)stickerImage center:(CGRect)center degree:(CGFloat)degree designSize:(CGSize)designSize;

/**
 文字贴纸数据
 @since v2.2.0
 */
@property (nonatomic,strong,readonly) TuSDKTextStickerImage *textStickerImage;

/**
 编辑文字贴纸时设计图大小
 @since v2.2.0
 */
@property (nonatomic,assign) CGSize designSize;

/**
 编辑文字贴纸时旋转角度
 @since v2.2.0
 */
@property (nonatomic,assign) float  degree;

/**
 编辑文字贴纸时中心点坐标
 @since v2.2.0
 */
@property (nonatomic,assign) CGRect center;

@end
