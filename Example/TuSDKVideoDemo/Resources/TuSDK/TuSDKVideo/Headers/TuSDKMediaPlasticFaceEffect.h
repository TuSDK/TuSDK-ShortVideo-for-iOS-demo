//
//  TuSDKMediaPlasticFaceEffect.h
//  TuSDKVideo
//
//  Created by sprint on 2018/12/10.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKMediaEffectCore.h"

NS_ASSUME_NONNULL_BEGIN

/**
 微整形特效
 @sicne v3.2.0
 */
@interface TuSDKMediaPlasticFaceEffect : TuSDKMediaEffectCore

/**
 根据触发时间区间初始化微整形特效

 @param timeRange 触发时间区间
 @return 微整形特效实例对象
 @since v3.2.0
 */
- (instancetype)initWithTimeRange:(TuSDKTimeRange * _Nullable)timeRange;

@end

NS_ASSUME_NONNULL_END
