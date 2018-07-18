//
//  TuSDKMediaExtractor.h
//  TuSDKVideo
//
//  Created by sprint on 12/06/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "TuSDKVideoImport.h"

@protocol TuSDKMediaExtractorSync;

/**
 媒体数据读取器接口
 @since      v3.0
 */
@protocol TuSDKMediaExtractor <NSObject>

/**
 开始读取
 @since      v3.0
 */
- (void)start;

/**
 停止读取
 @since      v3.0
 */
- (void)stop;

/**
 暂停输出
 @since      v3.0
 */
- (void)pause;

/**
 读取当前已解码的媒体数据
 
 @return 已解码的媒体数据
 @since      v3.0
 */
- (const CMSampleBufferRef)copySampleBuffer;

/**
 获取当前时间戳

 @return
 @since      v3.0
 */
- (CMTime)getSampleTime;

/**
 获取实时帧间隔时间

 @return 视频帧间隔
 @since      v3.0
 */
- (CMTime)frameInterval;

/**
 获取精确的持续时间
 
 @return 视频帧间隔
 @since      v3.0
 */
- (CMTime)realDuration;

/**
 移动读取光标

 @param time 光标读取时间
 @since      v3.0
 */
- (void)seekTo:(CMTime)time;

/**
 移动视频到下一帧
 @return true/false
 @since      v3.0
 */
- (BOOL)advance;

/**
 验证当前分离器是否支持倒序输出

 @return true/false
 @since      v3.0
 */
- (BOOL)canSupportedReverse;

/**
 请求反转顺序
 
 @return true/false
 @since      v3.0
 */
- (BOOL)requestReverse;

/**
 设置分离器同步器

 @param mediaSync TuSDKMediaExtractorSync
 @since      v3.0
 */
- (void)setMediaSync:(id<TuSDKMediaExtractorSync>)mediaSync;

@end
