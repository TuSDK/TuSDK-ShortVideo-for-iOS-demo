//
//  TuSDKMutipleMediaMovieCompositionComposer.h
//  TuSDKVideo
//
//  Created by KK on 2019/12/18.
//  Copyright © 2019 TuSDK. All rights reserved.
//

#import "TuSDKMediaMovieCompositionComposer.h"
#import "TuSDKMutipleMediaMutableAudioComposition.h"
#import "TuSDKMutipleMediaMutableVideoComposition.h"
#import "TuSDKMediaPlayer.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TuSDKMutipleMediaMovieCompositionComposerPlayerDelegate;

@interface TuSDKMutipleMediaMovieCompositionComposer : TuSDKMediaMovieCompositionComposer<TuSDKMediaPlayer>

/**
 初始化合成器
 
 @param videoComposition 视频合成物
 @param audioComposition 音频合成物
 @param composorSettings 合成器配置
 @param preview 预览视图
 @return TuSDKMutipleMediaMovieCompositionComposer
 
 @since v3.5.2
 */
- (instancetype)initWithVideoComposition:(id<TuSDKMediaVideoComposition> __nullable)videoComposition audioComposition:(id<TuSDKMediaAudioComposition> __nullable)audioComposition composorSettings:(TuSDKMediaCompositionVideoComposerSettings * __nullable)composorSettings preview:(UIView *)preview;


/**
  视频覆盖区域颜色 (默认：[UIColor blackColor])
  @since v3.0
 */
@property (nonatomic, retain) UIColor * _Nullable regionViewColor;


/** 播放代理 */
@property (nonatomic, weak) id<TuSDKMutipleMediaMovieCompositionComposerPlayerDelegate> playerDelegate;

/// 更新尺寸
/// @param frame 尺寸
- (void)updatePreViewFrame:(CGRect)frame;

/** 播放状态 */
@property (nonatomic, assign) TuSDKMediaPlayerStatus playerStatus;

// 重新加载
- (void)reload;


@end



/**
 TuSDKMediaMovieCompositionComposer 委托协议
 @since v3.4.1
 */
@protocol TuSDKMutipleMediaMovieCompositionComposerPlayerDelegate <NSObject>

@required

/**
 合成器进度改变事件

 @param compositionComposer 合成器
 @param percent (0 - 1)
 @param outputTime 当前帧所在持续时间
 @since v3.4.1
 */
- (void)mediaMovieCompositionComposer:(TuSDKMutipleMediaMovieCompositionComposer *_Nonnull)compositionComposer playerProgressChanged:(CGFloat)percent outputTime:(CMTime)outputTime;

/**
 合成器状态改变事件

 @param compositionComposer  合成器
 @param status 当前播放器状态
 @since v3.4.1
 */
- (void)mediaMovieCompositionComposer:(TuSDKMutipleMediaMovieCompositionComposer *_Nonnull)compositionComposer playerStatusChanged:(TuSDKMediaPlayerStatus)status;

@end

NS_ASSUME_NONNULL_END
