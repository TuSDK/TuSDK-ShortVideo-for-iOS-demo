//
//  TuSDKPixelBufferInput.h
//  TuSDKVideo
//
//  Created by sprint on 04/05/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Indicates the current data type.  */
typedef NSUInteger TuSDKSampleBufferInputType;
/** Video */
static const TuSDKSampleBufferInputType TuSDKSampleBufferInputTypeVideo = 0;
/** Audio */
static const TuSDKSampleBufferInputType TuSDKSampleBufferInputTypeAudio = 1;

/** CMSampleBufferRef input */
@protocol TuSDKSampleBufferInput

/**
 新的数据可用
 @param sampleBufferRef CMSampleBufferRef
 @param type TuSDKSampleBufferInputTypeVideo / TuSDKSampleBufferInputTypeAudio
 @param sampleTime
 */
- (void)newSampleBufferRef:(CMSampleBufferRef)sampleBufferRef sampleBufferInputType:(TuSDKSampleBufferInputType)type withSampleTime:(CMTime)sampleTime;

@end
