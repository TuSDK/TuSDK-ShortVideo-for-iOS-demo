//
//  TuSDKMediaAudioComposition.h
//  TuSDKVideo
//
//  Created by sprint on 2019/5/14.
//  Copyright © 2019 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKMediaComposition.h"

NS_ASSUME_NONNULL_BEGIN

/**
 音频合成项
 
 @since v3.4.1
 */
@protocol TuSDKMediaAudioComposition <TuSDKMediaComposition>

/**
 音频输出时间范围
 
 @since v3.5.2
 */
@property (nonatomic, assign) CMTimeRange outputTimeRange;

@end

NS_ASSUME_NONNULL_END
