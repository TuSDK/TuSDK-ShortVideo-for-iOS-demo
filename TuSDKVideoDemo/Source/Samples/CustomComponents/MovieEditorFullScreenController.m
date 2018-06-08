//
//  MovieEditorFullScreenController.m
//  TuSDKVideoDemo
//
//  Created by tutu on 2017/3/15.
//  Copyright © 2017年 TuSDK. All rights reserved.
//

#import "MovieEditorFullScreenController.h"
#import "MovieEditerFullScreenBottomBar.h"
#import "ParticleEffectEditView.h"

#import "Constants.h"

@interface MovieEditorFullScreenController()<MovieEditorFullScreenBottomBarDelegate, ParticleEffectEditViewDelegate>{
    // 粒子特效编辑View
    ParticleEffectEditView *_particleEditView;
    // 当前选中的粒子特效code
    NSString *_selectedParticleCode;
    // 粒子特效 [Code:Color] 对应的字典对象
    NSDictionary *_colorDic;
    
    TuSDKMediaParticleEffectData *_editingParticleEffect;
}

@end

@implementation MovieEditorFullScreenController

#pragma mark - override method

- (void)lsqInitView
{
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    CGRect rect = [UIScreen mainScreen].bounds;

    // 视频播放view，将 frame 修改为全屏
    self.previewView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    self.previewView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.previewView];
    self.videoView = [[UIView alloc]initWithFrame:self.previewView.bounds];
    [self.previewView addSubview:self.videoView];
    
    // 播放按钮,  以 self.previewView.frame 进行初始化，如设置全屏，请修改 frame 避免 屏幕视图层级的遮挡
    self.playBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.topBar.lsqGetSizeHeight, rect.size.width, rect.size.width)];
    [self.playBtn addTarget:self action:@selector(clickPlayerBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playBtn];
    
    self.playBtnIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    self.playBtnIcon.center = CGPointMake(self.view.lsqGetSizeWidth/2, self.view.lsqGetSizeHeight/2);
    self.playBtnIcon.image = [UIImage imageNamed:@"video_style_default_crop_btn_record"];
    [self.playBtn addSubview:self.playBtnIcon];
    
    // 默认相机顶部控制栏
    CGFloat topY = 0;
    if ([UIDevice lsqIsDeviceiPhoneX]) {
        topY = 44;
    }
    
    self.topBar = [[TopNavBar alloc]initWithFrame:CGRectMake(0, topY, rect.size.width, 44)];
    [self.topBar setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    self.topBar.topBarDelegate = self;
    [self.topBar addTopBarInfoWithTitle:NSLocalizedString(@"lsq_movieEditor", @"视频编辑")
                     leftButtonInfo:@[@"video_style_default_btn_back.png"]
                    rightButtonInfo:@[NSLocalizedString(@"lsq_save_video", @"保存")]];
    self.topBar.centerTitleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.topBar];
    
    // 底部栏控件
    CGFloat bottomHeight = rect.size.height - rect.size.width - 44;
    if ([UIDevice lsqIsDeviceiPhoneX]) {
        bottomHeight -= 34;
    }
    
    self.bottomBar = [[MovieEditerFullScreenBottomBar alloc]initWithFrame:CGRectMake(0, rect.size.width + 44, rect.size.width , bottomHeight)];
    self.bottomBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.bottomBar.bottomBarDelegate = self;
    self.bottomBar.videoFilters = kVideoFilterCodes;
    self.bottomBar.filterView.currentFilterTag = 200;
    self.bottomBar.videoURL = self.inputURL;
    self.bottomBar.topThumbnailView.timeInterval = self.endTime - self.startTime;
    self.bottomBar.effectsView.effectsCode = kVideoEffectCodes;
    self.bottomBar.videoDuration = self.endTime - self.startTime;
    
    MovieEditerFullScreenBottomBar *bottomBar = (MovieEditerFullScreenBottomBar *)self.bottomBar;
    bottomBar.fullScreenBottomBarDelegate = self;
    [self.view addSubview:bottomBar];
    
    _colorDic = [NSDictionary dictionaryWithObjects:kVideoPaticleColors forKeys:kVideoParticleCodes];
    // 根据不同需求可创建不同的对应颜色  或者使用随机色
//    _colorDic = [self getDicWithParticleCode:particleCods];

    [bottomBar.particleView createParticleEffectsWith:kVideoParticleCodes];
    [self initParticleEditView];
}

- (void)initParticleEditView;
{
    _particleEditView = [[ParticleEffectEditView alloc]initWithFrame:CGRectMake(0, self.bottomBar.lsqGetOriginY, self.view.lsqGetSizeWidth, 80)];
    _particleEditView.displayView.videoURL = self.inputURL;
    _particleEditView.particleDelegate = self;
    [self.view addSubview:_particleEditView];
}

#pragma mark - private method

- (UIColor *)getRandomColor;
{
    return [UIColor colorWithRed:random()%255/255.0 green:random()%255/255.0 blue:random()%255/255.0 alpha:0.9];
}

- (NSDictionary *)getDicWithParticleCode:(NSArray *)codeArr;
{
    NSMutableArray *colorArr = [NSMutableArray array];
    for (int i = 0; i < codeArr.count; i++) {
        UIColor *randColor = [self getRandomColor];
        [colorArr addObject:randColor];
    }
    
    return [NSDictionary dictionaryWithObjects:colorArr forKeys:codeArr];
}

// 更新删除按钮的是否可点击状态
- (void)updateRemoveBtnEnableState;
{
    if (_particleEditView.displayView.segmentCount > 0) {
       ((MovieEditerFullScreenBottomBar *) self.bottomBar).particleView.removeEffectBtn.enabled = YES;
    }else{
       ((MovieEditerFullScreenBottomBar *) self.bottomBar).particleView.removeEffectBtn.enabled = NO;
    }
}

#pragma mark - 初始化 movieEditor 

- (void)initSettingsAndPreview
{
    TuSDKMovieEditorOptions *options = [TuSDKMovieEditorOptions defaultOptions];
    // 设置视频地址
    options.inputURL = self.inputURL;
    // 设置视频截取范围
    options.cutTimeRange = [TuSDKTimeRange makeTimeRangeWithStartSeconds:self.startTime endSeconds:self.endTime];
    // 是否按照时间播放
    options.playAtActualSpeed = YES;
    // 设置裁剪范围 注：该参数对应的值均为比例值，即：若视频展示View总高度800，此时截取时y从200开始，则cropRect的 originY = 偏移位置/总高度， 应为 0.25, 其余三个值同理
    // 如需全屏展示，可以注释 options.cropRect = _cropRect; 该行设置，配合 view 的 frame 的更改，即可全屏展示
    // 可以直接设置 options.cropRect = CGRectMake(0, 0, 0, 0);
    options.cropRect = self.cropRect;
    // 设置编码视频的画质
    options.encodeVideoQuality = [TuSDKVideoQuality makeQualityWith:TuSDKRecordVideoQuality_High1];
    // 是否保留原音
    options.enableVideoSound = YES;

    self.movieEditor = [[TuSDKMovieEditor alloc]initWithPreview:self.videoView options:options];
    self.movieEditor.delegate = self;
    // 监听特效数据信息改变事件
    self.movieEditor.mediaEffectsDelegate = self;
    // 设置播放模式 : lsqMovieEditorPlayModeSequence 正序播放， lsqMovieEditorPlayModeReverse 倒序播放
    // self.movieEditor.playMode = lsqMovieEditorPlayModeReverse;
    // 保存到系统相册 默认为YES
    self.movieEditor.saveToAlbum = YES;
    // 设置录制文件格式(默认：lsqFileTypeQuickTimeMovie)
    self.movieEditor.fileType = lsqFileTypeMPEG4;
    // 设置水印，默认为空
    self.movieEditor.waterMarkImage = [UIImage imageNamed:@"sample_watermark.png"];
    // 设置水印图片的位置
    self.movieEditor.waterMarkPosition = lsqWaterMarkTopRight;
    // 视频播放音量设置，0 ~ 1.0 仅在 enableVideoSound 为 YES 时有效
    self.movieEditor.videoSoundVolume = 0.5;
    // 设置默认镜
    [self.movieEditor switchFilterWithCode:kVideoFilterCodes[0]];
    
  
    // 加载视频，显示第一帧
    [self.movieEditor loadVideo];
}

#pragma mark - MovieEditorFullScreenBottomBarDelegate

/**
 切换粒子特效
 
 @param filterCode 粒子特效code
 */
- (void)movieEditorFullScreenBottom_particleViewSwitchEffectWithCode:(NSString *)particleEffectCode;
{
    // 暂停预览
    [self pausePreview];
    
    _selectedParticleCode = particleEffectCode;
    // 隐藏底部栏 顶部栏
    self.bottomBar.hidden = YES;
    self.topBar.hidden = YES;
    
    
    // 点击后 particleEditView 进入编辑模式
    _particleEditView.isEditStatus = YES;
    _particleEditView.selectColor = _colorDic[particleEffectCode];
}

/**
 点击撤销按钮
 */
- (void)movieEditorFullScreenBottom_removeLastParticleEffect;
{
    TuSDKMediaEffectData *mediaEffect = [[self.movieEditor mediaEffectsWithType:TuSDKMediaEffectDataTypeParticle] lastObject];
    [self.movieEditor removeMediaEffect:mediaEffect];
    
    [_particleEditView removeLastParticleEffect];
    [self updateRemoveBtnEnableState];
}

#pragma mark - ParticleEffectEditViewDelegate

/**
 是否选中粒子特效展示栏
 */
- (void)movieEditorFullScreenBottom_selectParticleView:(BOOL)isParticle;
{
    if (_particleEditView.hidden != !isParticle)
        _particleEditView.hidden = !isParticle;
}

/**
 开始当前的特效
 */
- (void)particleEffectEditView_startParticleEffect;
{
    if (![self.movieEditor isPreviewing])  [self startPreview];
    
    _editingParticleEffect = [[TuSDKMediaParticleEffectData alloc] initWithEffectsCode:_selectedParticleCode];
    _editingParticleEffect.particleSize = _particleEditView.particleSize;
    _editingParticleEffect.particleColor = _particleEditView.particleColor;
    
    [self.movieEditor applyMediaEffect:_editingParticleEffect];
    
}

/**
 结束当前的特效
 */
- (void)particleEffectEditView_endParticleEffect;
{
    if (_editingParticleEffect)
    {
        [self.movieEditor unApplyMediaEffect:_editingParticleEffect];
        _editingParticleEffect = nil;
    }
    
    [self pausePreview];
}

/**
 取消当前正在添加的特效
 */
- (void)particleEffectEditView_cancleParticleEffect;
{
    if (_editingParticleEffect)
        [self.movieEditor removeMediaEffect:_editingParticleEffect];
    
    _editingParticleEffect = nil;
}

/**
 更新粒子轨迹位置
 
 @param newPoint 粒子轨迹的点
 */
- (void)particleEffectEditView_particleViewUpdatePoint:(CGPoint)newPoint;
{
    [self.movieEditor updateParticleEmitPosition:newPoint];
}

/**
 更新粒子大小size
 
 @param newSize 粒子大小
 */
- (void)particleEffectEditView_particleViewUpdateSize:(CGFloat)newSize;
{
    [self.movieEditor updateParticleEmitSize:newSize];
}

/**
 更新粒子颜色
 
 @param newColor 粒子颜色
 */
- (void)particleEffectEditView_particleViewUpdateColor:(UIColor *)newColor;
{
    [self.movieEditor updateParticleEmitColor:newColor];
}

/**
 移除上一个粒子特效
 */
- (void)particleEffectEditView_removeLastParticleEffect;
{
    TuSDKMediaEffectData *mediaEffect = [[self.movieEditor mediaEffectsWithType:TuSDKMediaEffectDataTypeParticle] lastObject];
    [self.movieEditor removeMediaEffect:mediaEffect];
}

/**
 点击播放按钮  YES：开始播放   NO：暂停播放
 
 @param isStartPreview YES:开始预览
 */
- (void)particleEffectEditView_playVideoEvent:(BOOL)isStartPreview;
{
    if (isStartPreview) {
        [self startPreview];
    }else{
        [self pausePreview];
    }
}

/**
 点击返回按钮
 */
- (void)particleEffectEditView_backViewEvent;
{
    _particleEditView.isEditStatus = NO;
    self.playBtn.hidden = ([self movieEditor].status == lsqMovieEditorStatusPreviewing);
    self.bottomBar.hidden = NO;
    self.topBar.hidden = NO;
    [self updateRemoveBtnEnableState];
}

/**
 手势移动缩略图的进度展示条
 
 @param progress 移动到某一 progress
 */
- (void)particleEffectEditView_moveLocationWithProgress:(CGFloat)progress;
{
    if ([self.movieEditor isPreviewing]) {
        [self pausePreview];
    }
    
    CMTime newTime = CMTimeMakeWithSeconds(progress * (self.endTime - self.startTime), 1*USEC_PER_SEC);
    [self.movieEditor seekToPreviewWithTime:newTime];
}

#pragma mark - TuSDKMovieEditorDelegate
- (void)onMovieEditor:(TuSDKMovieEditor *)editor statusChanged:(lsqMovieEditorStatus)status
{
    [super onMovieEditor:editor statusChanged:status];
    
    switch (status)
    {
        // 取消录制
        case lsqMovieEditorStatusRecordingCancelled:
        {
             [_particleEditView setVideoProgress:0 playModel:self.movieEditor.playMode];
            break;
        }
        default:
            break;
    }
    
    if (_particleEditView.isEditStatus)
        self.playBtn.hidden = YES;

    _particleEditView.playBtn.hidden = (status == lsqMovieEditorStatusPreviewing);
}

/**
 播放进度通知
 
 @param editor editor TuSDKMovieEditor
 @param progress progress description
 */
- (void)onMovieEditor:(TuSDKMovieEditor *)editor progress:(CGFloat)progress
{
    [super onMovieEditor:editor progress:progress];
    if (self.movieEditorStatus == lsqMovieEditorStatusPreviewing) {
        // 注意：UI相关修改需要确认在主线程中进行
        dispatch_async(dispatch_get_main_queue(), ^{
            [_particleEditView setVideoProgress:progress playModel:self.movieEditor.playMode];
        });
    }
}

#pragma mark - TuSDKMediaEffectsManagerDelegate

/**
 特效信息改变通知
 当添加特效时或者移除特效时该回调将被调用
 
 @param editor TuSDKMovieEditor
 @param effectTypes NSArray
 */
-(void)onMovieEditor:(TuSDKMovieEditor *)editor didChangedForMediaEffectTypes:(NSArray<NSNumber *> *)effectTypes
{
    [super onMovieEditor:editor didChangedForMediaEffectTypes:effectTypes];
    
    [effectTypes enumerateObjectsUsingBlock:^(NSNumber * _Nonnull mediaEffectType, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (mediaEffectType.integerValue == TuSDKMediaEffectDataTypeParticle)
        {
            if ([editor mediaEffectsWithType:TuSDKMediaEffectDataTypeParticle].count == 0)
                [_particleEditView.displayView removeAllSegment];
            
        }else if(mediaEffectType.integerValue == TuSDKMediaEffectDataTypeScene)
        {
            if ([editor mediaEffectsWithType:TuSDKMediaEffectDataTypeScene].count == 0)
                [self.bottomBar.effectsView.displayView removeAllSegment];
        }
        
    }];
}

#pragma mark - TimeEffectsViewDelegate

/**
 播放模式改变
 
 @param effectsView 时间特效视图
 @param playMode 当前播放模式
 */
-(void)timeEffectView:(TimeEffectsView *)effectsView playModeChanged:(lsqMovieEditorPlayMode)playMode
{
    [super timeEffectView:effectsView playModeChanged:playMode];
}

@end
