//
//  TuSDKMediaEffectsTimeline.h
//  TuSDKVideo
//
//  Created by sprint on 17/05/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "TuSDKMediaEffectData.h"
#import "TuSDKMediaSceneEffectData.h"
#import "TuSDKMediaStickerEffectData.h"
#import "TuSDKMediaParticleEffectData.h"
#import "TuSDKMediaStickerAudioEffectData.h"
#import "TuSDKMediaAudioEffectData.h"
#import "TuSDKMediaFilterEffectData.h"

@class TuSDKMediaEffectsTimeline;

typedef NSDictionary<NSNumber *,NSArray<TuSDKMediaEffectData *> *> * TuSDKMediaEffectsSearcherResult;

/**
  特效事件委托
  @since      v2.2.0
 */
@protocol TuSDKMediaEffectsTimelineDelegate <NSObject>

@optional

/**
  特效被移除通知
 
 @param mediaEffectsTimeline TuSDKMediaEffectTimeline
 @param mediaEffects 被移除的特效列表
 @since      v2.2.0
 */
- (void)mediaEffectsTimeline:(TuSDKMediaEffectsTimeline *)mediaEffectsTimeline didRemoveMediaEffects:(NSArray<TuSDKMediaEffectData *> *) mediaEffects;

@end

/**
 特效数据分布时间轴
 @since      v2.2.0
 */
@interface TuSDKMediaEffectsTimeline : NSObject

/**
 特效信息时间委托
 */
@property (nonatomic,weak) id<TuSDKMediaEffectsTimelineDelegate> delegate;

/**
 添加音频特效数据

 @param mediaEffect TuSDKMediaEffectData
 @return true/false
 @since      v2.2.0
 */
- (BOOL)addMediaEffect:(TuSDKMediaEffectData *)mediaEffect;

/**
 移除特效数据

 @param mediaEffect TuSDKMediaEffectData
 @return true/false
 @since      v2.2.0
 */
- (BOOL)removeMediaEffect:(TuSDKMediaEffectData *)mediaEffect;

/**
 移除制定类型的特效信息
 
 @param mediaEffect 特效类型
 @since      v2.2.0
 */
-(void)removeMediaEffectsWithType:(TuSDKMediaEffectDataType)effectType;

/**
 获取指定类型的特效信息

 @param type TuSDKMediaEffectDataType
 @return TuSDKMediaEffectData
 @since      v2.2.0
 */
- (NSArray<id> *)mediaEffectsWithType:(TuSDKMediaEffectDataType)effectType;

/**
 移除所有特效
 @since      v2.2.0
 */
- (void)removeAllMediaEffect;

/**
 重置所有特效
 @since      v2.2.0
 */
- (void)resetAllMediaEffects;

/**
 销毁特效
 @since      v2.2.0
 */
- (void)destory;

@end

#pragma mark - 检索数据

@interface TuSDKMediaEffectsTimeline(Seek)

/**
 搜索指定特效 搜索后通过 getResult 获取
 
 @param time CMTime
 @since      v2.2.0
 */
- (void)seekTime:(CMTime)time;

/**
 获取当前特效数据

 @return TuSDKMediaEffectsSearcherResult
 @since      v2.2.0
 */
- (TuSDKMediaEffectsSearcherResult)getResult;

/*
获取当前取消的特效

@return     NSArray<TuSDKMediaEffectData *> *
@since      v2.2.0
*/
- (NSArray<TuSDKMediaEffectData *> *)getUndockResult;

@end
