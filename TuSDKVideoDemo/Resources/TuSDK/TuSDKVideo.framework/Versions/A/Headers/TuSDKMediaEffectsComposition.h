//
//  TuSDKMediaEffectsComposition.h
//  TuSDKVideo
//
//  Created by sprint on 07/06/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoImport.h"
#import "TuSDKMediaEffectsTimeline.h"
#import "TuSDKComboFilterWrapChain.h"

@class TuSDKMediaEffectsComposition;

/**
 TuSDKMediaEffectsCompositionDelegate
 @since v2.2.0
 */
@protocol TuSDKMediaEffectsCompositionDelegate <NSObject,TuSDKMediaEffectsTimelineDelegate>

@optional

/**
 当前正在应用的特效

 @param composition 合成器
 @param applyingMediaEffectData 正在预览特效
 @since v2.2.0
 */
- (void)mediaEffectsComposition:(TuSDKMediaEffectsComposition *)composition didApplyingMediaEffect:(TuSDKMediaEffectData *)mediaEffectData;

@end

/**
特效数据合成
 @since v2.2.0
 */
@interface TuSDKMediaEffectsComposition : TuSDKComboFilterWrapChain

/**
 TuSDKMediaEffectsComposition 委托
 @since v2.2.0
 */
@property (nonatomic,weak) id<TuSDKMediaEffectsCompositionDelegate> delegate;

/**
 特效数据分布时间线
 @since v2.2.0
 */
@property (nonatomic,readonly) TuSDKMediaEffectsTimeline *mediaEffectsTimeline;

/**
 预览的分辨率
 @since v2.2.0
 */
@property (nonatomic)CGSize outputSize;

/**
 预览时裁剪范围
 @since v2.2.0
 */
@property (nonatomic,assign) CGRect cropRect;

/**
 是否可以播放音频特效
 @since v2.2.0
 */
@property (nonatomic) BOOL audioPlayable;

/**
 根据特效乐谱演奏特效

 @param musicBook 特效乐谱
 @return TuSDKMediaEffectEditor
 @since v2.2.0
 */
- (instancetype)initWithMediaEffectsTimeline:(TuSDKMediaEffectsTimeline *)mediaEffectsTimeline playground:(TuSDKComboFilterWrapChain *)playground;

/**
 播放指定位置的特效

 @param frameTime 帧时间
 @param originalFrameTime 原始帧时间
 @since v2.2.0
 */
- (void)playAtTime:(CMTime)frameTime originalFrameTime:(CMTime)originalFrameTime;

/**
 暂停特效
 @since v2.2.0
 */
- (void)pauseMediaEffects;

@end

