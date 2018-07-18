//
//  TuSDKMediaExtractor.h
//  TuSDKVideo
//
//  Created by sprint on 12/06/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "TuSDKMediaExtractor.h"
#import "TuSDKTimeRange.h"

/*!
 @enum TuSDKMediaAssetExtractorStatus
 @abstract
 These constants are returned by the AVAssetReader status property to indicate whether it can successfully read samples from its asset.
 
 @constant     TuSDKMediaAssetExtractorStatusUnknown
 Indicates that the status of the asset decoder is not currently known.
 @constant     TuSDKMediaAssetExtractorStatusReading
 Indicates that the asset reader is successfully reading samples from its asset.
 @constant     TuSDKMediaAssetExtractorStatusCompleted
 Indicates that the asset reader has successfully read all of the samples in its time range.
 @constant     TuSDKMediaAssetExtractorStatusFailed
 Indicates that the asset reader can no longer read samples from its asset because of an error.
 @constant     TuSDKMediaAssetExtractorStatusCancelled
 Indicates that the asset reader can no longer read samples because decoder was canceled with the cancelReading method.
 */
typedef NS_ENUM(NSInteger, TuSDKMediaAssetExtractorStatus) {
    TuSDKMediaAssetExtractorStatusUnknown = 0,
    TuSDKMediaAssetExtractorStatusReading,
    TuSDKMediaAssetExtractorStatusCompleted,
    TuSDKMediaAssetExtractorStatusCancelled,
    TuSDKMediaAssetExtractorStatusFailed
};


/** TuSDKMediaAssetExtractorSettings  */
typedef NSDictionary<NSString *, id> TuSDKMediaAssetExtractorSettings;


/**
 AVAsset 媒体数据读取类
 @since      v3.0
 */
@interface TuSDKMediaAssetExtractor : NSObject <TuSDKMediaExtractor>

/**
 初始化数据分离器
 
 @param asset 音频地址
 @param outputSettings 输出设置
 An NSDictionary of output settings to be used for sample output.  See AVAudioSettings.h for available output settings for audio tracks or AVVideoSettings.h for available output settings for video tracks and also for more information about how to construct an output settings dictionary.
 @return TuSDKMediaAssetExtractor
 */
- (instancetype _Nullable )initWithAsset:(AVAsset *_Nullable)asset outputTrackMediaType:(AVMediaType _Nonnull )mediaType outputSettings:(TuSDKMediaAssetExtractorSettings*_Nullable)outputSettings;

/*!
 获取设置信息
 @since      v3.0
 */
@property (nonatomic,readonly)TuSDKMediaAssetExtractorSettings * _Nullable outputSettings;

/*!
 @property mediaSync
 分离同步器
 @since      v3.0
 */
@property (nonatomic,readonly) id<TuSDKMediaExtractorSync> mediaSync;

/*!
 @property processQueue
 @abstract
 
 @discussion
 Decoding run queue
 @since      v3.0
 */
@property (nonatomic) dispatch_queue_t _Nullable processQueue;

/*!
 @property asset
 
 @discussion
 输入的视频源
 @since      v3.0
 */
@property (nonatomic,readonly)AVAsset * _Nonnull asset;

/**
 获取实时帧间隔时间
 
 @return 视频帧间隔
 @since      v3.0
 */
@property (nonatomic,readonly)CMTime frameInterval;

/**
 获取精确的持续时间
 @since      v3.0
 */
@property (nonatomic)CMTime realDuration;

/*!
 @property status
 解码器当前状态
 @since      v3.0
 */
@property (nonatomic,readonly) TuSDKMediaAssetExtractorStatus status;

/**
 设置一组时间区间范围
 @since      v3.0
 */
@property (nonatomic,strong) NSArray<TuSDKTimeRange *> *readingTimeRanges;

@end

#pragma mark - Detect Asset

@interface TuSDKMediaAssetExtractor (DetectAsset)

/**
 探测资产信息
 @since      v3.0
 */
- (void)detecAsset;

@end

#pragma mark - Cache

@interface TuSDKMediaAssetExtractor (Cache)

/**
 缓存数据帧

 @return true/falses
 @since      v3.0
 */
- (BOOL)cacheSamplebuffers;

/**
 读取某段视频帧
 
 @param reverse 是否反转视频
 */
- (CFMutableArrayRef)copySampleBuffers:(CMTimeRange)range reverse:(BOOL)reverse;

@end

