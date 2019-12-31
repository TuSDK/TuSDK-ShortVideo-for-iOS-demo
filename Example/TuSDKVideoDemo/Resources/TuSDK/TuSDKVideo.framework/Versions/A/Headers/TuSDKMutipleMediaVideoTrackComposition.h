//
//  TuSDKMutipleMediaVideoTrackComposition.h
//  TuSDKVideo
//
//  Created by KK on 2019/12/18.
//  Copyright © 2019 TuSDK. All rights reserved.
//

#import "TuSDKMediaVideoTrackComposition.h"
#import "TuSDKMediaCompositionPixelBuffer.h"
#import "TuSDKMediaEffect.h"

NS_ASSUME_NONNULL_BEGIN


/// 多文件拼接：单个视频轨道
@interface TuSDKMutipleMediaVideoTrackComposition : TuSDKMediaVideoTrackComposition

/** 位置 */
@property (nonatomic, assign) CGRect cutRegin;

/**
 获取下一帧数据
 @since v3.5.2
*/
- (TuSDKMediaCompositionPixelBuffer *)readNexPixelBuffer;


/// 指定时间点分割其所在的视频，将其分割成两份，如果时间超出范围，则返回nil
/// @param time 指定分割的时间点
- (NSArray <TuSDKMutipleMediaVideoTrackComposition *> *)separateCompositionWithTime:(CMTime)time;

@end

#pragma mark -  MediaEffectManager

/**
 * 特效管理
 */
@interface TuSDKMutipleMediaVideoTrackComposition  (MediaEffectManager)

/**
 添加一个多媒体特效。该方法不会自动设置触发时间.
 
 @param mediaEffect 特效数据
 @discussion 如果已有特效和该特效不能同时共存，已有旧特效将被移除.
 @since    v2.0
 */
- (BOOL)addMediaEffect:(id<TuSDKMediaEffect> _Nonnull)mediaEffect;

/**
 移除特效数据
 
 @since v3.4.1
 
 @param mediaEffect TuSDKMediaEffectData
 */
- (void)removeMediaEffect:(id<TuSDKMediaEffect> _Nonnull)mediaEffect;

/**
 移除指定类型的特效信息
 
 @since v3.4.1
 @param effectType 特效类型
 */
- (void)removeMediaEffectsWithType:(NSUInteger)effectType;

/**
 @since v3.4.1
 @discussion 移除所有特效
 */
- (void)removeAllMediaEffect;


/**
 获取指定类型的特效信息
 
 @since v3.4.1
 @param effectType 特效数据类型
 @return 特效列表
 */
- (NSArray<id<TuSDKMediaEffect>> *_Nonnull)mediaEffectsWithType:(NSUInteger)effectType;

/**
 获取添加的所有特效
 
 @since v3.4.0
 @return 特效列表
 */
- (NSArray<id<TuSDKMediaEffect>> *_Nonnull)allMediaEffects;

@end

NS_ASSUME_NONNULL_END
