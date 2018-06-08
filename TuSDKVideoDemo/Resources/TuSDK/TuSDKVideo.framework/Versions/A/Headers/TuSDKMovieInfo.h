//
//  TuSDKMovieInfo.h
//  TuSDKVideo
//
//  Created by sprint on 04/05/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoImport.h"

typedef void(^lsqMovieInfoLoadCompletionHandler)(void);

@class TuSDKVideoTrackInfo;
@class TuSDKAudioTrackInfo;

/**
 * 视频信息
 */
@interface TuSDKMovieInfo : NSObject

/**
 异步加载视频信息

 @param asset AVAsset
 @param handler 完成后回调
 */
-(void)loadAsynchronouslyForAssetInfo:(AVAsset *)asset completionHandler:(void (^)(void))handler;

/**
 异步加载视频信息
 
 @param asset AVAsset
 @param handler 完成后回调
 */
-(void)loadSynchronouslyForAssetInfo:(AVAsset *)asset;

/**
 * 视频轨道信息
 */
@property (nonatomic,readonly)NSArray<TuSDKVideoTrackInfo *> *videoTrackInfoArray;

/**
 音频轨道信息
 */
@property (nonatomic,readonly)NSArray<TuSDKAudioTrackInfo *> *audioTrackInfoArray;

/**
 * 持续时间
 */
@property(nonatomic, readonly)CMTime duration;

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

/**
 rotation
 */
@property(nonatomic, readonly) UIImageOrientation orientation;

@end


#pragma mark - TuSDKAudioTrackInfo

/**
 * 音频轨道信息
 */
@interface TuSDKAudioTrackInfo : NSObject

/**
 TuSDKAudioTrackInfo

 @param audioTrack AVAssetTrack
 @return TuSDKAudioTrackInfo
 */
+(instancetype)trackInfoWithAudioAssetTrack:(AVAssetTrack *)audioTrack;

/**
 根据 CMAudioFormatDescriptionRef 初始化 TuSDKAudioTrackInfo

 @param audioFormatDescriptionRef CMAudioFormatDescriptionRef
 @return TuSDKAudioTrackInfo
 */
-(instancetype)initWithCMAudioFormatDescriptionRef:(CMAudioFormatDescriptionRef)audioFormatDescriptionRef;

/**
  The number of frames per second of the data in the stream, when the stream is played at normal speed. For compressed formats, this field indicates the number of frames per second of equivalent decompressed data.
 
 To determine the duration represented by one packet, use the mSampleRate field with the mFramesPerPacket field, as follows:
 
 duration = (1 / mSampleRate) * mFramesPerPacket
*/
@property (nonatomic,readonly) Float64 sampleRate;

/**
 The number of channels in each frame of audio data. This value must be nonzero.
 */
@property (nonatomic,readonly) UInt32 channelsPerFrame;

/**
 The number of bytes in a packet of audio data. To indicate variable packet size, set this field to 0. For a format that uses variable packet size, specify the size of each packet using an AudioStreamPacketDescription structure.
 */
@property (nonatomic,readonly) UInt32 bytesPerPacket;

@end
