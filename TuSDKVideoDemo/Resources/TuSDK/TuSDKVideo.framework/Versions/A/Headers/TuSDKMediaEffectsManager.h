//
//  TuSDKMediaEffectsManager.h
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

@class TuSDKMediaEffectsManager;

typedef NSDictionary<NSNumber *,NSArray<TuSDKMediaEffectData *> *> * TuSDKMediaEffectsSearcherResult;

/**
 * 特效事件委托
 */
@protocol TuSDKMediaEffectsManagerDelegate <NSObject>

@optional

/**
 *  mediaEffectsManager 特效信息改变时间
 *
 *  @param mediaEffectsManager mediaEffectsManager
 *  @param effectType 特效类型
 */
- (void)mediaEffectsManager:(TuSDKMediaEffectsManager *)mediaEffectsManager didChangedForMediaEffectTypes:(NSArray<NSNumber *> *) effectTypes;

@end


/**
 * 设置的特效数据检索器
 */
@interface TuSDKMediaEffectsManager : NSObject

/**
 特效信息时间委托
 */
@property (nonatomic,weak) id<TuSDKMediaEffectsManagerDelegate> delegate;

/**
 添加音频特效数据

 @param mediaEffect TuSDKMediaEffectData
 @return true/false
 */
- (BOOL)addMediaEffect:(TuSDKMediaEffectData *)mediaEffect;

/**
 移除特效数据

 @param mediaEffect TuSDKMediaEffectData
 @return true/false
 */
- (BOOL)removeMediaEffect:(TuSDKMediaEffectData *)mediaEffect;

/**
 移除制定类型的特效信息
 
 @param mediaEffect 特效类型
 */
-(void)removeMediaEffectsWithType:(TuSDKMediaEffectDataType)effectType;

/**
 获取指定类型的特效信息

 @param type TuSDKMediaEffectDataType
 @return TuSDKMediaEffectData
 */
- (NSArray<id> *)mediaEffectsWithType:(TuSDKMediaEffectDataType)effectType;

/**
 移除所有特效
 */
- (void)removeAllMediaEffect;

/**
 重置所有特效
 */
- (void)resetAllMediaEffects;

@end

#pragma mark - 检索数据

@interface TuSDKMediaEffectsManager(Seek)

/**
 搜索指定特效 搜索后通过 getResult 获取
 
 @param time CMTime
 */
- (void)seekTime:(CMTime)time;

/**
 获取当前特效数据

 @return TuSDKMediaEffectsSearcherResult
 */
- (TuSDKMediaEffectsSearcherResult)getResult;


@end
