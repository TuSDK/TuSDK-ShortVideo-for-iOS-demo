//
//  TuSDKMediaVideoComposition.h
//  TuSDKVideo
//
//  Created by sprint on 2019/5/14.
//  Copyright © 2019 TuSDK. All rights reserved.
//

#import "TuSDKMediaComposition.h"

NS_ASSUME_NONNULL_BEGIN

/**
视频合成项
 
@since v3.4.1
*/
@protocol TuSDKMediaVideoComposition <TuSDKMediaComposition>

/**
 该 Composition 输出的像素格式.
 
 @return 输出格式
 @since v3.4.1
 */
@property (nonatomic, readonly)OSType outputPixelFormatType;

/**
 画面输出方向
 
 @since v3.4.1
 */
@property (nonatomic, assign) LSQGPUImageRotationMode outputRotation;

/**
 画面输出时间范围
 
 @since v3.5.2
 */
@property (nonatomic, assign) CMTimeRange outputTimeRange;

/**
 原视频无方向尺寸
 
 @since v3.4.1
 */
@property (nonatomic, readonly)CGSize preferredOutputSize;

/**
 输出尺寸
 @since v3.5.2
 */
@property (nonatomic, assign) CGSize outputSize;

@end

NS_ASSUME_NONNULL_END
