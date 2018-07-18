//
//  TuSDKAudioInfo.h
//  TuSDKVideo
//
//  Created by sprint on 02/07/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoImport.h"

@class TuSDKAudioTrackInfo;

/**
 音频信息
 @since 3.0
 */
@interface TuSDKAudioInfo : NSObject

/**
 音频轨道信息
 @since 音频轨道信息
 @since 3.0
 */
@property (nonatomic,readonly)NSArray<TuSDKAudioTrackInfo *> *audioTrackInfoArray;

/**
 持续时间
 @since 3.0
 */
@property(nonatomic, readonly)CMTime duration;

/**
 异步加载音频信息
 
 @param asset AVAsset
 @param handler 完成后回调
 @since 3.0
 */
-(void)loadAsynchronouslyForAssetInfo:(AVAsset *)asset completionHandler:(void (^)(void))handler;

/**
 同步加载音频信息
 
 @param asset AVAsset
 @since 3.0
 */
-(void)loadSynchronouslyForAssetInfo:(AVAsset *)asset;

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
