//
//  TuSDKVideoTimeEffectSlowProcesser.h
//  TuSDKVideo
//
//  Created by sprint on 29/04/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "TuSDKVideoTimeEffectProcesser.h"

/**
 * 制作慢动作
 */
@interface TuSDKVideoTimeEffectSlowProcesser : NSObject <TuSDKVideoTimeEffectProcesser>

/**
 初始化时间特效
 
 @param fireTimeRange 触发时间
 @param maxTimes 最大次数
 @return TuSDKVideoTimeEffectRepeatProcesser
 */
-(instancetype)initWithFireTimeRange:(CMTimeRange)fireTimeRange maxTimes:(NSUInteger)maxTimes;

@end
