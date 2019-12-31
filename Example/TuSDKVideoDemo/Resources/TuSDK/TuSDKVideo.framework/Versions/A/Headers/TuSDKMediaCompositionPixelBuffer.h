//
//  TuSDKMediaCompositionPixelBuffer.h
//  TuSDKVideo
//
//  Created by KK on 2019/12/19.
//  Copyright © 2019 TuSDK. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TuSDKMediaCompositionPixelBuffer : NSObject

- (instancetype)initWithPixelBuffer:(CVPixelBufferRef)pixelBuffer outputTime:(CMTime)outputTime;

/** pixelBuffer */
@property (nonatomic, readonly) CVPixelBufferRef pixelBuffer;

/** outputTime */
@property (nonatomic, assign) CMTime outputTime;

@end

NS_ASSUME_NONNULL_END
