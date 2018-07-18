//
//  TuSDKVideoInfo.h
//  TuSDKVideo
//
//  Created by sprint on 02/07/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoImport.h"

@class TuSDKVideoTrackInfo;

@interface TuSDKVideoInfo : NSObject

/**
视频轨道信息
@since 视频轨道信息
@since 3.0
*/
@property (nonatomic,readonly)NSArray<TuSDKVideoTrackInfo *> *videoTrackInfoArray;

/**
 持续时间
 @since 3.0
 */
@property(nonatomic, readonly)CMTime duration;

/**
 异步加载视频信息
 
 @param asset AVAsset
 @param handler 完成后回调
 @since 3.0
 */
-(void)loadAsynchronouslyForAssetInfo:(AVAsset *)asset completionHandler:(void (^)(void))handler;

/**
 同步加载视频信息
 
 @param asset AVAsset
 @since 3.0
 */
-(void)loadSynchronouslyForAssetInfo:(AVAsset *)asset;


@end

#pragma mark - TuSDKVideTrackInfo

/**
 * 视频轨道信息
 */
@interface TuSDKVideoTrackInfo : NSObject

/**
 TuSDKVideoTrackInfo
 
 @param audioTrack TuSDKVideoTrackInfo
 @return TuSDKAudioTrackInfo
 */
+(instancetype)trackInfoWithVideoAssetTrack:(AVAssetTrack *)videoTrack;

/**
 根据 AVAssetTrack 初始化 TuSDKVideoTrackInfo
 
 @param videoTrack AVAssetTrack
 @return TuSDKVideoTrackInfo
 */
-(instancetype)initWithVideoAssetTrack:(AVAssetTrack *)videoTrack;

/**
 The natural dimensions of the media data referenced by the track.
 */
@property (nonatomic,readonly) CGSize naturalSize;

/**
 The present dimensions of the media data referenced by the track.
 */
@property (nonatomic,readonly) CGSize presentSize;

/**
 The transform specified in the track’s storage container as the preferred transformation of the visual media data for display purposes.
 */
@property (nonatomic,readonly) CGAffineTransform preferredTransform;

/* indicates the estimated data rate of the media data referenced by the track, in units of bits per second */
@property (nonatomic, readonly) float estimatedDataRate;


/**
 rotation
 */
@property(nonatomic, readonly) GPUImageRotationMode orientation;

@end
