//
//  TuSDKPixelBufferInput.h
//  TuSDKVideo
//
//  Created by sprint on 04/05/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

/** CMSampleBufferRef input */
@protocol TuSDKSampleBufferInput

/**
 新的数据可用
 @param sampleBufferRef CMSampleBufferRef
 @param type AVMediaTypeVideo / AVMediaTypeAudio
 @param sampleTime
 */
- (void)newSampleBufferRef:(CMSampleBufferRef)sampleBufferRef mediaType:(AVMediaType)type withSampleTime:(CMTime)sampleTime;

@end
