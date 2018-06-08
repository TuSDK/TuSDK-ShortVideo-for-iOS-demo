//
//  TuSDKAssetVideoDecoder.h
//  TuSDKVideo
//
//  Created by sprint on 03/05/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKVideoImport.h"
#import "TuSDKMediaDecoder.h"
#import "TuSDKMovieInfo.h"

@class TuSDKAssetAudioDecoder;

/*!
 @enum TuSDKAssetAudioDecoderStatus
 @abstract
 These constants are returned by the TuSDKAssetAudioDecoder status property to indicate whether it can successfully read samples from its asset.
 
 @constant     TuSDKAssetAudioDecoderStatusUnknown
 Indicates that the status of the asset decoder is not currently known.
 @constant     TuSDKAssetAudioDecoderReading
 Indicates that the asset reader is successfully reading samples from its asset.
 @constant     TuSDKAssetAudioDecoderCompleted
 Indicates that the asset reader has successfully read all of the samples in its time range.
 @constant     TuSDKAssetAudioDecoderFailed
 Indicates that the asset reader can no longer read samples from its asset because of an error.
 @constant     TuSDKAssetAudioDecoderCancelled
 Indicates that the asset reader can no longer read samples because decoder was canceled with the cancelReading method.
 */
typedef NS_ENUM(NSInteger, TuSDKAssetAudioDecoderStatus) {
    TuSDKAssetAudioDecoderStatusUnknown = 0,
    TuSDKAssetAudioDecoderStatusReading,
    TuSDKAssetAudioDecoderStatusCompleted,
    TuSDKAssetAudioDecoderStatusFailed,
    TuSDKAssetAudioDecoderStatusCancelled,
};

#pragma mark - TuSDKAssetAudioDecoderDelegate

/**
  TuSDKAssetAudioDecoderDelegate
 */
@protocol TuSDKAssetAudioDecoderDelegate

@required
/**
 The current decoder state changes the event.
 
 @param decoder TuSDKAssetVideoDecoder
 @param status TuSDKAssetVideoDecoderStatus
 */
- (void)assetAudioDecoder:(TuSDKAssetAudioDecoder *_Nullable)decoder statusChanged:(TuSDKAssetAudioDecoderStatus)status;

@end

#pragma mark - TuSDKAssetVideoDecoder

/**
 * TuSDKAssetVideoDecoder
 */
@interface TuSDKAssetAudioDecoder : NSObject <TuSDKMediaDecoder>

/**
 初始化音频解码器

 @param asset 音频地址
 @param outputSettings 输出设置
     An NSDictionary of output settings to be used for sample output.  See AVAudioSettings.h for available output settings for audio tracks or AVVideoSettings.h for available output settings for video tracks and also for more information about how to construct an output settings dictionary.
 @return TuSDKAssetAudioDecoder
 */
- (instancetype _Nullable )initWithAsset:(AVAsset *_Nullable)asset outputSettings:(nullable NSDictionary<NSString *, id> *)outputSettings;

/*!
 @property processQueue
 @abstract
 
 @discussion
 Decoding run queue
 */
@property (nonatomic) dispatch_queue_t _Nullable processQueue;

/*!
 @property delegate
 @abstract
 
 @discussion
 Decoding event delegate
 */
@property (nonatomic,weak) id<TuSDKAssetAudioDecoderDelegate> _Nullable delegate;

/*!
 @property status
 解码器当前状态
 */
@property (nonatomic,readonly) TuSDKAssetAudioDecoderStatus status;

/*!
 @property asset
 
 @discussion
 输入的视频源
 */
@property (nonatomic,readonly)AVAsset * _Nonnull asset;

/*!
 @property movieInfo
 
 @discussion
 获取音频信息
 */
@property (nonatomic,readonly)NSArray<TuSDKAudioTrackInfo *> * _Nullable audioTrackInfos;

/*!
 @property outputSettings
 
 @discussion
 获取设置信息
 */
@property (nonatomic,readonly)NSDictionary<NSString *, id>  * _Nonnull outputSettings;

/*!
 @property outputSampleBufferInputTargets
 
 @discussion
 视频数据输出
 */
@property (nonatomic,readonly)NSMutableArray<id<TuSDKSampleBufferInput>> * _Nullable outputSampleBufferInputTargets;


@end


