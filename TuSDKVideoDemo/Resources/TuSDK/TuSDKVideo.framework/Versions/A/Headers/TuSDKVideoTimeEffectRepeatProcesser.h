//
//  TuSDKVideoTimeEffectRepeatProcesser.h
//  TuSDKVideo
//
//  Created by sprint on 27/04/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoTimeEffectProcesser.h"

/**
 * 时间特效 - 反复特效
 */
@interface TuSDKVideoTimeEffectRepeatProcesser : NSObject <TuSDKVideoTimeEffectProcesser>

/**
 初始化时间特效

 @param fireTimeRange 触发时间
 @param maxTimes 最大次数
 @return TuSDKVideoTimeEffectRepeatProcesser
 */
-(instancetype)initWithFireTimeRange:(CMTimeRange)fireTimeRange maxTimes:(NSUInteger)maxTimes;

@end
