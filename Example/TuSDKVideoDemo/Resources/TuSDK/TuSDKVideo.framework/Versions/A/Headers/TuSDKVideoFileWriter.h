//
//  TuSDKVideoFileWriter.h
//  TuSDK
//
//  Created by Yanlin on 2/23/16.
//  Copyright © 2016 tusdk.com. All rights reserved.
//

#import "TuSDKVideoDataOutputBase.h"
#import "TuSDKVideoQuality.h"

@class TuSDKVideoFileWriter;

extern NSString *const kTuVideoGPUImageColorSwizzlingFragmentShaderString;


#pragma mark - TuSDKVideoWriterDelegate

@protocol TuSDKVideoFileWriterDelegate<NSObject>
@optional
- (void)videoFileWriterDidRecordCompleted:(TuSDKVideoFileWriter *)fileWriter;
- (void)videoFileWriterRecordFailed:(NSError*)error;

- (void)adjustingLastVideoTime;


@end

#pragma mark - TuSDKVideoFileWriter

/**
 *  视频数据输出，保存为文件
 */
@interface TuSDKVideoFileWriter : TuSDKVideoDataOutputBase
{
    NSString *_fileType;
    AVAssetWriter *_assetWriter;
    AVAssetWriterInput *_assetWriterAudioInput;
    AVAssetWriterInput *_assetWriterVideoInput;
    AVAssetWriterInputPixelBufferAdaptor *_assetWriterPixelBufferInput;
}

@property (nonatomic, readonly) NSURL *movieURL;
@property (nonatomic, assign) BOOL hasAudioTrack;
@property (nonatomic, assign) BOOL shouldPassthroughAudioSettings;
//@property (nonatomic, assign) BOOL shouldInvalidateAudioSampleWhenDone;
@property (nonatomic, weak) id<TuSDKVideoFileWriterDelegate> delegate;
@property (nonatomic, copy) BOOL(^videoInputReadyCallback)(void);
@property (nonatomic, copy) BOOL(^audioInputReadyCallback)(void);
@property (nonatomic, copy) void(^audioProcessingCallback)(SInt16 **samplesRef, CMItemCount numSamplesInBuffer);

@property (nonatomic, assign) CGAffineTransform transform;
@property (nonatomic, assign) BOOL shouldOptimizeForNetworkUse;

@property(nonatomic, assign, getter = isPaused) BOOL paused;
// 变速后的时长
@property(nonatomic, readonly) CMTime duration;
// 未变速的实际录制时长
@property(nonatomic, readonly) CMTime defaultDuration;
// 是否需要声音 默认：YES，有声音
@property(nonatomic, assign) BOOL enableSound;
// 是否为录制视频，当录制(不是剪裁)视频时，需要抛弃多余的音频帧
@property(nonatomic, assign) BOOL isRecordVideo;
// 续拍模式下，在暂停后，校对过最后一帧的时间后调用该block，同时校准camera类中的时间节点记录；
//@property(nonatomic, copy) void(^adjustingLastVideoTime)(void);
// Audio FormatDescriptionRef
@property (nonatomic) CMAudioFormatDescriptionRef audioFormatDescriptionRef;
// 变速速度  默认 1.0：正常
@property (nonatomic, assign) CGFloat videoSpeed;

/**
 设置是否验证时间戳 默认：true
 
 @since v3.0.1
 */
@property (nonatomic, assign) BOOL enableCheckSampleTime;

/**
 是否使用 Context 队列 默认：true 所有任务都在 ContextQueue 队列中执行
 NO : 所有任务都在 VideoProcessingQueue 队列中执行
 @since v3.0
 */
@property (nonatomic, assign) BOOL useContextQueue;

/**
 音频数据写入队列 （dispatch_retain)
 @since v3.0
 */
@property (nonatomic) dispatch_queue_t audioQueue;

/**
 视频数据写入队列 (dispatch_retain)
 @since v3.0
 */
@property (nonatomic) dispatch_queue_t videoQueue;

/**
 初始化

 @param newMovieURL 保存文件路径
 @param newSize 视频尺寸
 @return 实例对象
 */
- (id)initWithMovieURL:(NSURL *)newMovieURL size:(CGSize)newSize;

- (id)initWithMovieURL:(NSURL *)newMovieURL size:(CGSize)newSize fileType:(lsqFileType)newFileType videoQuality:(TuSDKVideoQuality *)videoQuality;

- (void)setHasAudioTrack:(BOOL)hasAudioTrack audioSettings:(NSDictionary *)audioOutputSettings;

- (void)enableSynchronizationCallbacks;


/**
 写入一帧音频数据

 @param audioBuffer 音频数据
 @param outputTime 输出时间
 @since v3.4.1
 */
- (void)processAudioBuffer:(CMSampleBufferRef)audioBuffer outputTime:(CMTime)outputTime;

/**
 写入一帧音频数据
 
 @param audioBuffer 音频数据
 @since v3.4.1
 */
- (void)processAudioBuffer:(CMSampleBufferRef)audioBuffer;

/**
 *  完成视频录制，且在完成后，执行block内容
 */
- (void)publicFinishRecordingWithCompletionHandler:(void (^)(void))handler;

/**
 *  销毁output
 */
- (void)destroyMovieOutput;

@end
