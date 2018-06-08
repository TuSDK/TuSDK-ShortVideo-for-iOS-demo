//
//  TuSDKVideoTimeEffectProcesser.h
//  TuSDKVideo
//
//  Created by sprint on 27/04/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>


/**
 * 时间特效接口
 */
@protocol TuSDKVideoTimeEffectProcesser <NSObject>

/**
 特效触发时间范围
 
 @return 触发区间
 */
@property (nonatomic)CMTimeRange fireTimeRange;

/**
 * 触发次数
 */
@property (nonatomic)NSUInteger maxTimes;

@required

/**
 标记该特效是否依赖触发特效的数据，如果返回true则调用端必须使用 fullTimeRangeSampleBuffers 方法填充触发时间范围内的视频数据

 @return true/false
 */
- (BOOL)needFullFireTimeRangeSampleBuffers;

/**
 仅当 needFullTimeRangeSampleBuffers 返回 true 时，才需要调用该方法填充触发时间范围内的视频数据

 @param sampleBufferArrayRef sampleBufferArrayRef
 */
- (void)fullFireTimeRangeSampleBuffers:(CFArrayRef)sampleBufferArrayRef;

/**
 处理视频帧数据 (CMSampleBufferRef)

 @param videoSampleBufferss
        当前数据帧
 @return
        返回处理后的视频帧
 */
- (void)processVideoSampleBuffers:(CFMutableArrayRef)videoSampleBuffers;

/**
 * 重置状态信息
 */
- (void)resetProcesser;

/**
 销毁特效处理器
 */
- (void)destoryProcesser;

@end
