//
//  TuSDKMovieEditorBase.h
//  TuSDKVideo
//
//  Created by Yanlin Qiu on 19/12/2016.
//  Copyright © 2016 TuSDK. All rights reserved.
//

#import "TuSDKVideoImport.h"
#import "TuSDKVideoResult.h"
#import "TuSDKMovieEditorOptions.h"
#import "TuSDKMediaEffectData.h"
#import "TuSDKTimeRange.h"
#import "TuSDKMVStickerAudioEffectData.h"
#import "TuSDKMediaSceneEffectData.h"
#import "TuSDKMovieEditorMode.h"
#import "TuSDKMediaEffectsManager.h"

/**
 *  视频编辑基类
 */
@interface TuSDKMovieEditorBase : NSObject
{
    @protected
    
    // 视频视图
    TuSDKICFilterMovieViewWrap *_cameraView;
}

/**
 *  输入视频源 URL > Asset
 */
@property (nonatomic) NSURL *inputURL;

/**
 *  输入视频源 URL > Asset
 */
@property (nonatomic) AVAsset *inputAsset;

/**
 *  裁剪范围 （开始时间~持续时间）
 */
@property (nonatomic,strong) TuSDKTimeRange *cutTimeRange;

/**
 *  最小裁剪持续时间
 */
@property (nonatomic, assign) NSUInteger minCutDuration;

/**
 *  最大裁剪持续时间
 */
@property (nonatomic, assign) NSUInteger maxCutDuration;

/**
 *  保存到系统相册 (默认保存, 当设置为NO时, 保存到临时目录)
 */
@property (nonatomic) BOOL saveToAlbum;

/**
 *  保存到系统相册的相册名称
 */
@property (nonatomic, copy) NSString *saveToAlbumName;

/**
 *  视频覆盖区域颜色 (默认：[UIColor blackColor])
 */
@property (nonatomic, retain) UIColor *regionViewColor;

/**
 *  是否正在切换滤镜
 */
@property (nonatomic, readonly) BOOL isFilterChanging;

/**
 *  视频总持续时间
 */
@property(readonly,nonatomic) float duration;

/**
 *  视频实际总时长
 */
@property(readonly,nonatomic) float actualDuration;

/**
 *  TuSDKMovieEditor 状态
 */
@property (readonly,assign) lsqMovieEditorStatus status;

/**
 * 设置播放模式，默认正序播放
 */
@property (nonatomic,assign) lsqMovieEditorPlayMode playMode;

/**
 * 当前设置的时间特效 默认： lsqMovieEditorTimeEffectModeNone
 */
@property (nonatomic,readonly) lsqMovieEditorTimeEffectMode timeEffectMode;

/**
 *  导出视频的文件格式（默认:lsqFileTypeMPEG4）
 */
@property (nonatomic, assign) lsqFileType fileType;

/**
 *  预览时视频原音音量， 默认 1.0  注：仅在 option 中的 enableSound 为 YES 时有效
 */
@property (nonatomic, assign) CGFloat videoSoundVolume;

#pragma mark - waterMark

/**
 *  设置水印图片，最大边长不宜超过 500
 */
@property (nonatomic, retain) UIImage *waterMarkImage;

/**
 *  水印位置，默认 lsqWaterMarkBottomRight
 */
@property (nonatomic) lsqWaterMarkPosition waterMarkPosition;

#pragma mark - init

/**
 *  初始化
 *
 *  @param holderView 预览容器
 *  @return 对象实例
 */
- (instancetype)initWithPreview:(UIView *)holderView options:(TuSDKMovieEditorOptions *)options;

/**
 *  加载视频，显示第一帧
 */
- (void)loadVideo;

#pragma mark - Preview

/**
 *  启动预览
 */
- (void) startPreview;

/**
 *  停止预览
 */
- (void) stopPreview;

/**
 * 停止并重新开始预览
 * 如果你需要 stopPreView 紧接着使用 startPreView 再次启动预览，你首选的方案应为 rePreview，rePreview会根据内部状态在合适的时间启动预览
 */
- (void) rePreview;

/**
 * 暂停预览
 */
- (void) pausePreView;

/**
 *  是否正在预览视频
 *
 *  @return true/false
 */
- (BOOL) isPreviewing;

/**
 获取当前视频帧时间

 @return CMTime
 */
- (CMTime) getCurrentSampleTime;

/**
 跳转至某一时间节点

 @param time 当前视频的时间节点(若以设置过裁剪时间段，该时间表示裁剪后时间表示)
 */
- (void) seekToPreviewWithTime:(CMTime)time;

#pragma mark - Record

/**
 *  开始录制视频 将被存储至文件
 */
- (void) startRecording;

/**
 *  取消录制
 */
- (void) cancelRecording;

/**
 *  是否正在录制视频
 *
 *  @return true/false
 */
- (Boolean) isRecording;

/**
 *  通知视频编辑器状态
 *
 *  @param status 状态信息
 */
- (void) notifyMovieEditorStatus:(lsqMovieEditorStatus) status;

/**
 *  通知视频处理进度事件
 *
 *  @param progress 进度 (0 ~1)
 */
- (void)notifyMovieProgress:(CGFloat)progress;

/**
 *  通知视频处理结果
 *
 *  @param result TuSDKVideoResult 对象
 *  @param error  错误信息
 *  
 *  @return
 */
- (void)notifyResult:(TuSDKVideoResult *)result error:(NSError *)error;

#pragma mark - switch filter

/**
 *  切换滤镜
 *
 *  @param code 滤镜代号
 *
 *  @return BOOL 是否成功切换滤镜
 */
- (BOOL)switchFilterWithCode:(NSString *)code;

#pragma mark - time effect

/**
 设置时间特效模式
 @since      v2.1
 @param timeEffectMode 时间特效模式
 @param atTimeRange 特效生效时间
 @param times 特效次数
 */
- (void)setTimeEffectMode:(lsqMovieEditorTimeEffectMode)timeEffectMode atTimeRange:(TuSDKTimeRange *)timeRange times:(NSUInteger)times;


#pragma mark - particle scene

/**
 更新粒子特效的发射器位置
 
 @param point 粒子发射器位置  左上角为(0,0)  右下角为(1,1)
 @since      v2.0
 */
- (void)updateParticleEmitPosition:(CGPoint)point;

/**
 更新 下一次添加的 粒子特效材质大小  0~1  注：对当前正在添加或已添加的粒子不生效

 @param size 粒子特效材质大小
 @since      v2.0
 */
- (void)updateParticleEmitSize:(CGFloat)size;

/**
 更新 下一次添加的 粒子特效颜色  注：对当前正在添加或已添加的粒子不生效
 
 @param color 粒子特效颜色
 @since      v2.0
 */
- (void)updateParticleEmitColor:(UIColor *)color;

#pragma mark - destroy

/**
 *  销毁
 */
- (void)destroy;

@end

#pragma mark - TuSDKMovieEditorBase (MediaEffectManager)

/**
 * 特效管理
 */
@interface TuSDKMovieEditorBase (MediaEffectManager)

/**
 添加一个多媒体特效。该方法不会自动设置触发时间.
 @since      v2.0
 @param mediaEffect
 @discussion 如果已有特效和该特效不能同时共存，已有旧特效将被移除.
 */
- (BOOL)addMediaEffect:(TuSDKMediaEffectData *)mediaEffect;

/**
 移除特效数据
 @since      v2.1
 
 @param mediaEffect TuSDKMediaEffectData
 @return true/false
 */
- (void)removeMediaEffect:(TuSDKMediaEffectData *)mediaEffect;

/**
 移除指定类型的特效信息
 @since      v2.1
 @param effectType 特效类型
 */
- (void)removeMediaEffectsWithType:(TuSDKMediaEffectDataType)effectType;

/**
  @since      v2.0
  @discussion 移除所有特效
 */
- (void)removeAllMediaEffect;

/**
 开始编辑并预览特效.
 @since      v2.1
 @param mediaEffect TuSDKMediaEffectData
 @discussion  当调用该方法时SDK内部将会设置特效开始时间为当前视频时间。
 */
- (void)applyMediaEffect:(TuSDKMediaEffectData *)mediaEffect;

/**
 停止编辑特效.
 @since      v2.1
 @param mediaEffect TuSDKMediaEffectData
 @discussion 当调用该方法时SDK内部将会设置特效结束时间为当前视频时间。
 */
- (void)unApplyMediaEffect:(TuSDKMediaEffectData *)mediaEffect;

/**
 获取指定类型的特效信息
 @since      v2.1
 @param type 特效数据类型
 @return 特效列表
 */
- (NSArray<TuSDKMediaEffectData *> *)mediaEffectsWithType:(TuSDKMediaEffectDataType)effectType;

/**
 特效状态信息改变.
 @since      v2.1
 @param mediaEffectsManager TuSDKMediaEffectsManager
 @param effectTypes 改变的特效类型数组. 当添加特效时如果已有特效不能同时使用，该冲突特效将被移除，该回调同样会被调用.
 @discussion 当开发者调用添加或者移除方法时该回调将被调用.
 */
-(void)mediaEffectsManager:(TuSDKMediaEffectsManager *)mediaEffectsManager didChangedForMediaEffectTypes:(NSArray<NSNumber *> *)effectTypes;

@end
