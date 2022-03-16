//
//  TuSDKMediaMovieFilmEditSaver.h
//  TuSDKVideo
//
//  Created by sprint on 19/07/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "TuSDKMediaMovieAssetExportSession.h"
#import "TuSDKMediaTimelineAssetAudioExtractor.h"
#import "TuSDKMediaVideoRender.h"
#import "TuSDKMediaAudioRender.h"
#import "TuSDKMediaEffect.h"
#import "TuSDKMediaEffectSync.h"
#import "TuSDKComboFilterWrapChain.h"

@class TuSDKMediaMovieFilmEditSaverSettings;
@protocol TuSDKMediaMovieFilmEditSaverDelegate;

/**
 特效导出
 @since 3.0
 */
@interface TuSDKMediaMovieFilmEditSaver : TuSDKMediaMovieAssetExportSession

/**
 初始化视频导出会话

 @param asset 输入的视频资源
 @param mediaEffects 导出的特效信息
 @param exportOutputSettings 输出设置
 @return TuSDKMovieEditorExportSession
 */
- (instancetype _Nullable)initWithInputAsset:(AVAsset *_Nonnull)inputAsset mediaEffects:(NSArray<id<TuSDKMediaEffect>> *_Nullable)mediaEffects exportOutputSettings:(nullable TuSDKMediaMovieFilmEditSaverSettings * )exportOutputSettings;

/**
 获取视频信息，视频加载完成后可用
 @since      v3.0
 */
@property (nonatomic,readonly)TuSDKMediaAssetInfo * _Nullable inputAssetInfo;

/**
 视频外部渲染接口
 
 @since      v3.0
 */
@property (nonatomic,weak) id<TuSDKMediaVideoRender> _Nullable videoRender;

/**
 音频外部渲染接口
 
 @since     v3.0
 */
@property (nonatomic,weak) id<TuSDKMediaAudioRender> _Nullable audioRender;

/**
 TuSDKMovieEditorExportSession 进度委托
 @since     v3.0
 */
@property (nonatomic,weak) id<TuSDKMediaMovieFilmEditSaverDelegate> _Nullable delegate;


@end

#pragma mark - MediaTimelineSlice

@interface TuSDKMediaMovieFilmEditSaver (MediaTimelineSlice)

/**
 在原有特效后追加新的特效
 
 @param timelineSlice 特效片段z
 @since      v3.0
 */
- (BOOL)appendSlice:(TuSDKMediaTimelineSlice *_Nonnull)timelineSlice;


@end

#pragma mark - 音效混合

@interface TuSDKMediaMovieFilmEditSaver (Mix)

- (void)mixAudios;

@end

#pragma mark TuSDKMediaMovieFilmEditSaverDelegate

@protocol TuSDKMediaMovieFilmEditSaverDelegate <NSObject>

@required

/**
 进度改变事件
 
 @param exportSession TuSDKMovieEditorExportSession
 @param percent (0 - 1)
 @param outputTime 当前帧所在持续时间
 @since      v3.0
 */
- (void)mediaAssetExportSession:(TuSDKMediaMovieFilmEditSaver *_Nonnull)exportSession progressChanged:(CGFloat)percent outputTime:(CMTime)outputTime;

/**
 播放器状态改变事件
 
 @param exportSession 当前
 @param status 当前播放器状态
 @since      v3.0
 */
- (void)mediaAssetExportSession:(TuSDKMediaMovieFilmEditSaver *_Nonnull)exportSession statusChanged:(TuSDKMediaExportSessionStatus)status;

/**
 播放器状态改变事件
 
 @param exportSession 当前
 @param result TuSDKVideoResult
 @param error 错误信息
 @since      v3.0
 */
- (void)mediaAssetExportSession:(TuSDKMediaMovieFilmEditSaver *_Nonnull)exportSession result:(TuSDKVideoResult *_Nonnull)result error:(NSError *_Nonnull)error;

@end

#pragma mark TuSDKMediaMovieFilmEditSaverSettings

@interface TuSDKMediaMovieFilmEditSaverSettings : TuSDKMediaMovieAssetExportSessionSettings

#pragma mark - 文件生成

/**
 导出时视频原音音量 默认：1.f
 @since v3.0
 */
@property (nonatomic, assign) CGFloat videoSoundVolume;


#pragma mark - 相册

/**
 保存到系统相册 (默认保存, 当设置为NO时, 保存到临时目录)
 @since v3.0
 */
@property (nonatomic) BOOL saveToAlbum;

/**
 保存到系统相册的相册名称
 @since v3.0
 */
@property (nonatomic, copy) NSString * _Nullable saveToAlbumName;

@end
