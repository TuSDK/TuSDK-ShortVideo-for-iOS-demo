//
//  APIMutipleVideoEditViewController.m
//  TuSDKVideoDemo
//
//  Created by KK on 2019/12/19.
//  Copyright © 2019 TuSDK. All rights reserved.
//

#import "APIMutipleVideoEditViewController.h"
#import "TuSDKFramework.h"
#import "Constants.h"

@interface APIMutipleVideoEditViewController()<TuSDKMutipleMediaMovieCompositionComposerPlayerDelegate, TuSDKMediaMovieCompositionComposerDelegate>

@property (weak, nonatomic) IBOutlet UIView *preview;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

/** 合成器 */
@property (nonatomic, strong) TuSDKMutipleMediaMovieCompositionComposer *movieComposition;
/** 视频合成器 */
@property (nonatomic, strong) TuSDKMutipleMediaMutableVideoComposition *videoComposition;
/** 音频合成器 */
@property (nonatomic, strong) TuSDKMutipleMediaMutableAudioComposition *audioComposition;
/** 合成配置 */
@property (nonatomic, strong) TuSDKMediaCompositionVideoComposerSettings *videoComposerSettings;

/** 当前视频项 */
@property (nonatomic, strong) TuSDKMutipleMediaVideoTrackComposition *currentVideoComposition;

/** 当前音频项 */
@property (nonatomic, strong) TuSDKMutipleMediaAudioTrackComposition *currentAudioComposition;

/** desc */
@property (nonatomic, strong) NSArray *filterCodes;

@end

@implementation APIMutipleVideoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _filterCodes = @[kVideoFilterCodes];
    [self prepareComposition];
    
    // 添加后台、前台切换的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackFromFront) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFrontFromBack) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.movieComposition updatePreViewFrame:self.preview.bounds];
}

- (void)dealloc {
    if (_movieComposition) {
        [_movieComposition cancelExport];
        [_movieComposition stop];
        [_movieComposition destory];
        _movieComposition = nil;
    }
    
    if (_videoComposition) {
        _videoComposition = nil;
    }
    
    if (_audioComposition) {
        _audioComposition = nil;
    }
}

- (void)prepareComposition {
    
    [self.inputAssets enumerateObjectsUsingBlock:^(AVURLAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TuSDKMutipleMediaVideoTrackComposition *video = [[TuSDKMutipleMediaVideoTrackComposition alloc] initWithVideoAsset:obj];
        [self.videoComposition appendComposition:video];
        
        TuSDKMutipleMediaAudioTrackComposition *audio = [[TuSDKMutipleMediaAudioTrackComposition alloc] initWithAudioAsset:obj];
        [self.audioComposition appendComposition:audio];
    }];
    
    [self.movieComposition load];
}

#pragma mark - 后台切换操作

/**
 进入后台
 */
- (void)enterBackFromFront {
    if (_movieComposition) {
        if (_movieComposition.status == TuSDKMediaExportSessionStatusExporting) {
            // 调用 stopRecording 会将已处理的视频保存下来；cancelRecording 会取消已录制的内容
            [_movieComposition cancelExport];
        }
        [_movieComposition stop];
    }
}

/**
 后台到前台
 */
- (void)enterFrontFromBack {
    [[TuSDK shared].messageHub dismiss];
}

#pragma mark - actions
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)playAction:(UIButton *)sender {
    _playButton.selected = !_playButton.selected;
    if (_playButton.selected) {
        [self play];
    } else {
        [self pasue];
    }
}

- (IBAction)seek:(id)sender {
    [self testSeek];
}

- (IBAction)cut:(id)sender {
    [self testCut];
}

- (IBAction)changed:(id)sender {
    [self testChanged];
}

- (IBAction)effect:(id)sender {
    [self testEffect];
}

- (IBAction)separate:(id)sender {
    [self testSeparate];
}


- (IBAction)rotate:(id)sender {
    [self testRotate];
}


- (IBAction)cutSize:(id)sender {
    [self testCutSize];
}

- (IBAction)allEffect:(id)sender {
    [self testAllEffect];
}


- (IBAction)export:(id)sender {
    [self testExport];
}

#pragma mark - test
- (void)play {
    [self.movieComposition play];
}

- (void)pasue {
    [self.movieComposition pause];
}

// seek -- ok
- (void)testSeek {
    self.playButton.selected = NO;
    [self.movieComposition seekToTime:CMTimeMake(15.0, 1.0)];
}


// 尺寸裁剪
- (void)testCutSize {
    // 第一个裁剪尺寸
    self.playButton.selected = NO;
    [self.movieComposition stop];
    TuSDKMutipleMediaVideoTrackComposition *firstV = (TuSDKMutipleMediaVideoTrackComposition *)self.videoComposition.compositions.firstObject;
    firstV.outputSize = CGSizeMake(1080, 1080);
    // 设置完后需要重置
    [firstV reset];
    [self.movieComposition reload];
}


// 旋转，适应屏幕分辨率的问题
- (void)testRotate {
    // 第一段左旋转
    self.playButton.selected = NO;
    [self.movieComposition stop];
    
    TuSDKMutipleMediaVideoTrackComposition *firstV = (TuSDKMutipleMediaVideoTrackComposition *)self.videoComposition.compositions.firstObject;
    if (firstV.outputRotation == LSQKGPUImageNoRotation) {
        firstV.outputRotation = LSQKGPUImageRotateRight;
    } else if (firstV.outputRotation == LSQKGPUImageRotateRight) {
        firstV.outputRotation = LSQKGPUImageRotate180;
    } else if (firstV.outputRotation == LSQKGPUImageRotate180) {
        firstV.outputRotation = LSQKGPUImageRotateLeft;
    } else if (firstV.outputRotation == LSQKGPUImageRotateLeft) {
        firstV.outputRotation = LSQKGPUImageNoRotation;
    }
    // 设置完后需要重置
    [firstV reset];
    [self.movieComposition reload];
}

// 分割
- (void)testSeparate {
    // 第一段分割成段，为了看到效果，建议进行一次交换
    self.playButton.selected = NO;
    [self.movieComposition stop];
    CMTime time = self.videoComposition.compositions.firstObject.outputDuraiton;
    [self.videoComposition separateCompositionWithTime:CMTimeMake(time.value*0.5, time.timescale)];
    [self.audioComposition separateCompositionWithTime:CMTimeMake(time.value*0.5, time.timescale)];
    [self.movieComposition reload];
}

// 裁剪
- (void)testCut {
    self.playButton.selected = NO;
    [self.movieComposition stop];
    // 每段视频的长度裁剪一半
    [self.videoComposition.compositions enumerateObjectsUsingBlock:^(TuSDKMutipleMediaVideoTrackComposition *composition, NSUInteger idx, BOOL * _Nonnull stop) {
        composition.outputTimeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMake(composition.outputDuraiton.value*0.5, composition.outputDuraiton.timescale));
    }];
    
    [self.audioComposition.compositions enumerateObjectsUsingBlock:^(TuSDKMutipleMediaAudioTrackComposition *composition, NSUInteger idx, BOOL * _Nonnull stop) {
        composition.outputTimeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMake(composition.outputDuraiton.value*0.5, composition.outputDuraiton.timescale));
    }];
    [self.movieComposition reload];
}


// 交换位置
- (void)testChanged {
    if (self.videoComposition.compositions.count < 2) {
        return;
    }
    self.playButton.selected = NO;
    [self.movieComposition stop];
    // 第一个和第二个交换
//    TuSDKMutipleMediaVideoTrackComposition *firstV = (TuSDKMutipleMediaVideoTrackComposition *)self.videoComposition.compositions.firstObject;
    TuSDKMutipleMediaVideoTrackComposition *secondV = (TuSDKMutipleMediaVideoTrackComposition *)self.videoComposition.compositions[1];
    [self.videoComposition removeComposition:secondV];
    [self.videoComposition insertComposition:secondV atIndex:0];
    
//    TuSDKMutipleMediaAudioTrackComposition *firstA = (TuSDKMutipleMediaAudioTrackComposition *)self.audioComposition.compositions.firstObject;
    TuSDKMutipleMediaAudioTrackComposition *secondA = (TuSDKMutipleMediaAudioTrackComposition *)self.audioComposition.compositions[1];
    [self.audioComposition removeComposition:secondA];
    [self.audioComposition insertComposition:secondA atIndex:0];
    
    [self.movieComposition reload];
}

// 添加特效
- (void)testEffect {
    self.playButton.selected = NO;
    [self.movieComposition stop];
    
    TuSDKMutipleMediaVideoTrackComposition *firstV = (TuSDKMutipleMediaVideoTrackComposition *)self.videoComposition.compositions.firstObject;
    [self videoComposition:firstV configCode:self.filterCodes.firstObject];
    
    if (self.videoComposition.compositions.count >= 2) {
        TuSDKMutipleMediaVideoTrackComposition *secondV = (TuSDKMutipleMediaVideoTrackComposition *)self.videoComposition.compositions[1];
        [self videoComposition:secondV configCode:self.filterCodes[1]];
    }
    
    if (self.videoComposition.compositions.count >= 3) {
        TuSDKMutipleMediaVideoTrackComposition *thirdV = (TuSDKMutipleMediaVideoTrackComposition *)self.videoComposition.compositions[2];
        [self videoComposition:thirdV configCode:self.filterCodes[2]];
    }
    [self.movieComposition reload];
}

- (void)videoComposition:(TuSDKMutipleMediaVideoTrackComposition *)composition configCode:(NSString *)filterCode {
    TuSDKMediaFilterEffect *filterEffect = (TuSDKMediaFilterEffect *)[composition mediaEffectsWithType:TuSDKMediaEffectDataTypeFilter].lastObject;
    if (![filterEffect.effectCode isEqualToString:filterCode]) { // 仅当滤镜码不一致时才应用新滤镜
        // 选中滤镜列表第一项，code 为空时，移除滤镜
        if (!filterCode.length) {
            [composition removeMediaEffectsWithType:TuSDKMediaEffectDataTypeFilter];
        } else {
            // 应用滤镜
            filterEffect = [[TuSDKMediaFilterEffect alloc] initWithEffectCode:filterCode];
            [composition addMediaEffect:filterEffect];
        }
    }
}


/// 全部特效
- (void)testAllEffect {
    // 去倒数第二个特效
    NSString *filterCode = self.filterCodes[self.filterCodes.count - 2];
    [self.videoComposition.compositions enumerateObjectsUsingBlock:^(TuSDKMutipleMediaVideoTrackComposition * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self videoComposition:obj configCode:filterCode];
    }];
}

/// 导出
- (void)testExport {
    [self.movieComposition startExport];
}

#pragma mark - 播放代理
- (void)mediaMovieCompositionComposer:(TuSDKMutipleMediaMovieCompositionComposer *)compositionComposer playerStatusChanged:(TuSDKMediaPlayerStatus)status {
    if (status == TuSDKMediaPlayerStatusPlaying) {
        // 正在播放
    } else if (status == TuSDKMediaPlayerStatusCompleted) {
        // 播放完成
    } else if (status == TuSDKMediaPlayerStatusFailed) {
        // 播放失败
    } else if (status == TuSDKMediaPlayerStatusPaused) {
        // 播放暂停
    }
}

- (void)mediaMovieCompositionComposer:(TuSDKMutipleMediaMovieCompositionComposer *)compositionComposer playerProgressChanged:(CGFloat)percent outputTime:(CMTime)outputTime {
    NSLog(@"播放进度：%f", percent*100);
}


#pragma mark - 导出代理
- (void)mediaMovieCompositionComposer:(TuSDKMediaMovieCompositionComposer *)compositionComposer progressChanged:(CGFloat)percent outputTime:(CMTime)outputTime {
    [TuSDKProgressHUD showProgress:percent status:NSLocalizedStringFromTable(@"tu_正在保存...", @"VideoDemo", @"正在保存...") maskType:TuSDKProgressHUDMaskTypeBlack];
}


- (void)mediaMovieCompositionComposer:(TuSDKMediaMovieCompositionComposer *)compositionComposer statusChanged:(TuSDKMediaExportSessionStatus)status {
    if (status == TuSDKMediaExportSessionStatusExporting) {
        // 正在导出
    } else if (status == TuSDKMediaExportSessionStatusCompleted) {
        // 导出完成
    } else if (status == TuSDKMediaExportSessionStatusFailed) {
        // 导出失败
        
    } else if (status == TuSDKMediaExportSessionStatusCancelled) {
        // 导出取消
        [[TuSDK shared].messageHub showError:NSLocalizedStringFromTable(@"tu_取消保存", @"VideoDemo", @"取消保存")];
    }
}

- (void)mediaMovieCompositionComposer:(TuSDKMediaMovieCompositionComposer *)compositionComposer result:(TuSDKVideoResult *)result error:(NSError *)error {
    if (error) {
        // 导出失败
        NSLog(@"导出失败：%@", error);
        NSLog(@"保存失败，error: %@", error);
        [[TuSDK shared].messageHub showError:NSLocalizedStringFromTable(@"tu_保存失败", @"VideoDemo", @"保存失败")];
    } else {
        // 导出成功
        NSLog(@"导出的视频路径：%@", result.videoPath);
        [[TuSDK shared].messageHub showSuccess:NSLocalizedStringFromTable(@"tu_保存成功", @"VideoDemo", @"保存成功")];
    }
}

#pragma mark - getter setter

- (TuSDKMutipleMediaMutableVideoComposition *)videoComposition {
    if (!_videoComposition) {
        _videoComposition = [[TuSDKMutipleMediaMutableVideoComposition alloc] init];
    }
    return _videoComposition;
}

- (TuSDKMutipleMediaMutableAudioComposition *)audioComposition {
    if (!_audioComposition) {
        _audioComposition = [[TuSDKMutipleMediaMutableAudioComposition alloc] init];
    }
    return _audioComposition;
}

- (TuSDKMutipleMediaMovieCompositionComposer *)movieComposition {
    if (!_movieComposition) {
        _movieComposition = [[TuSDKMutipleMediaMovieCompositionComposer alloc] initWithVideoComposition:self.videoComposition audioComposition:self.audioComposition composorSettings:self.videoComposerSettings preview:self.preview];
        _movieComposition.playerDelegate = self;
        _movieComposition.delegate = self;
    }
    return _movieComposition;
}

- (TuSDKMediaCompositionVideoComposerSettings *)videoComposerSettings {
    if (!_videoComposerSettings) {
        _videoComposerSettings = [[TuSDKMediaCompositionVideoComposerSettings alloc] init];
        _videoComposerSettings.saveToAlbum = YES;
        
        // 输出分辨率，这里是测试用
        _videoComposerSettings.outputSize = CGSizeMake(1080, 1920);
    }
    return _videoComposerSettings;
}

@end
