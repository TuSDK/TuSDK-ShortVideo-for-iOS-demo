//
//  TuSDKMovieInfo.h
//  TuSDKVideo
//
//  Created by sprint on 04/05/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoImport.h"
#import "TuSDKAudioInfo.h"
#import "TuSDKVideoInfo.h"

typedef void(^lsqMovieInfoLoadCompletionHandler)(void);

/**
 视频信息
 @since 2.2.0
 */
@interface TuSDKMovieInfo : NSObject

/**
 异步加载视频信息

 @param asset AVAsset
 @param handler 完成后回调
 @since 2.2.0
 */
-(void)loadSynchronouslyForAssetInfo:(AVAsset *)asset;

/**
 视频轨道信息
 @since 2.2.0
 */
@property (nonatomic,readonly)TuSDKVideoInfo *videoInfo;

/**
 音频轨道信息
 @since 2.2.0
 */
@property (nonatomic,readonly)TuSDKAudioInfo *audioInfo;

@end

