//
//  TuSDKMutipleMediaMutableAudioComposition.h
//  TuSDKVideo
//
//  Created by KK on 2019/12/18.
//  Copyright © 2019 TuSDK. All rights reserved.
//

#import "TuSDKMediaMutableAudioComposition.h"
#import "TuSDKMutipleMediaAudioTrackComposition.h"

NS_ASSUME_NONNULL_BEGIN

@interface TuSDKMutipleMediaMutableAudioComposition : TuSDKMediaMutableAudioComposition

/// 指定时间点分割其所在的视频，将其分割成两份，如果时间超出范围，则返回nil
/// @param time 指定分割的时间点
- (NSArray <TuSDKMutipleMediaAudioTrackComposition *> *)separateCompositionWithTime:(CMTime)time;


/// 根据时间查找对应的视频
/// @param time 时间
- (TuSDKMutipleMediaAudioTrackComposition *)findCompositionWithTime:(CMTime)time;

- (void)reload;

/// seek到指定时间
/// @param outputTime 时间
- (void)seekToTime:(CMTime)outputTime;

@end

NS_ASSUME_NONNULL_END
