//
//  TuSDKMediaEffectData.h
//  TuSDKVideo
//
//  Created by wen on 06/07/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKTimeRange.h"
#import "TuSDKMediaEffectData.h"

// 特效类型
typedef NS_ENUM(NSUInteger,TuSDKMediaEffectDataType) {
    TuSDKMediaEffectDataTypeFilter = 0,
    TuSDKMediaEffectDataTypeAudio ,
    TuSDKMediaEffectDataTypeSticker,
    TuSDKMediaEffectDataTypeSticketAudio,
    TuSDKMediaEffectDataTypeScene,
    TuSDKMediaEffectDataTypeParticle
};

/**
 video 特效
 */
@interface TuSDKMediaEffectData : NSObject
{
    TuSDKMediaEffectDataType _effectType;
}

/**
 * 时间范围
 */
@property (nonatomic,strong) TuSDKTimeRange *atTimeRange;

/**
 特效类型
 */
@property (nonatomic,readonly) TuSDKMediaEffectDataType effectType;

/**
 * 标记当前特效是否正在应用中
 * 开发者不应修改该标识
 */
@property (nonatomic) BOOL isApplyed;

/**
 初始化方法
 */
- (instancetype)initEffectInfoWithTimeRange:(TuSDKTimeRange *)timeRange;


@end
