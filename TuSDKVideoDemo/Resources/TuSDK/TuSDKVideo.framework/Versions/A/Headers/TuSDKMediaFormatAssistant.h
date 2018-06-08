//
//  TuSDKMediaFormatAssistant.h
//  TuSDKVideo
//
//  Created by sprint on 10/05/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
/**
 * 格式助手
 */
@interface TuSDKMediaFormatAssistant : NSObject

/**
 根据 videoSize 获取安全的size

 @param videoSize videoSize
 @return CGSize
 */
+ (CGSize)safeVideoSize:(CGSize)videoSize;

@end
