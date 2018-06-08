//
//  APIMovieSplicerViewController.m
//  TuSDKVideoDemo
//
//  Created by wen on 27/06/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import "TuSDKFramework.h"

#import "APIMovieSplicerViewController.h"
#import "TopNavBar.h"

@interface APIMovieSplicerViewController ()<TopNavBarDelegate, TuSDKAssetVideoComposerDelegate>{
    // 编辑页面顶部控制栏视图
    TopNavBar *_topBar;
    // 拼接对象
    TuSDKAssetVideoComposer *_movieComposer;
    // 底部说明 label
    UILabel * explainationLabel;
    // 距离定点距离
    CGFloat topYDistance;
}

// 系统播放器
@property (strong, nonatomic) AVPlayer *firstPlayer;
@property (nonatomic, strong) AVPlayerItem *firstPlayerItem;
@property (strong, nonatomic) AVPlayer *secondPlayer;
@property (nonatomic, strong) AVPlayerItem *secondPlayerItem;
@end

@implementation APIMovieSplicerViewController

#pragma mark - 基础配置方法

// 隐藏状态栏 for IOS7
- (BOOL)prefersStatusBarHidden;
{
    if ([UIDevice lsqIsDeviceiPhoneX]) {
        return NO;
    }

    return YES;
}

#pragma mark - 视图布局方法

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self setNavigationBarHidden:YES animated:NO];
    if (![UIDevice lsqIsDeviceiPhoneX]) {
        [self setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lsqClorWithHex:@"#F3F3F3"];

    topYDistance = 0;
    if ([UIDevice lsqIsDeviceiPhoneX]) {
        topYDistance += 44;
    }
    
    // 顶部栏初始化
    [self initWithTopBar];
    // 视频播放器初始化
    [self initWithVideoPlayer];
    // 视频拼接
    [self initWithSplicerButton];
    // 底部说明 label
    [self initWithExplainationLabel];
    
    // 添加后台、前台切换的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterBackFromFront) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterFrontFromBack) name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - 后台前台切换
// 进入后台
- (void)enterBackFromFront
{
  [self cancelComposing];
}

// 后台到前台
- (void)enterFrontFromBack
{
    [[TuSDK shared].messageHub dismiss];
}

// 底部说明 label
- (void)initWithExplainationLabel;
{
    CGFloat sideGapDistance = 50;
    explainationLabel  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.lsqGetSizeWidth - 10, _topBar.lsqGetSizeHeight)];
    explainationLabel.backgroundColor = lsqRGB(236, 236, 236);
    explainationLabel.center = CGPointMake(self.view.lsqGetSizeWidth/2, self.view.lsqGetSizeHeight - sideGapDistance*0.5 - topYDistance);
    explainationLabel.textColor = [UIColor blackColor];
    explainationLabel.text = NSLocalizedString(@"lsq_api_splice_movie_explaination" , @"点击「视频拼接」按钮，将两段视频合为一段视频，保存成功后请去相册查看视频");    
    explainationLabel.numberOfLines = 0;
    explainationLabel.textAlignment = NSTextAlignmentCenter;
    explainationLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:explainationLabel];
}

// 视频拼接按钮
- (void)initWithSplicerButton;
{
    CGFloat sideGapDistance = 50;
    CGFloat buttonWidth = self.view.lsqGetSizeWidth - sideGapDistance*2;
    
    // 开始页面 合成视频btn
    UIButton *mixButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, buttonWidth, sideGapDistance)];
    mixButton.center = CGPointMake(self.view.lsqGetSizeWidth/2, self.view.lsqGetSizeHeight - sideGapDistance*2 - topYDistance);
    mixButton.backgroundColor =  lsqRGB(252, 143, 96);
    [mixButton setTitle:NSLocalizedString(@"lsq_api_Splice_movie" , @"视频拼接") forState:UIControlStateNormal];
    [mixButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mixButton lsqSetCornerRadius:10];
    mixButton.adjustsImageWhenHighlighted = NO;
    [mixButton addTouchUpInsideTarget: self action:@selector(startComposing)];
    [self.view addSubview:mixButton];
}

// 播放器初始化
- (void)initWithVideoPlayer;
{
    // 视频素材一播放器
    UIView *firstPlayerView = [[UIView alloc]initWithFrame:CGRectMake(0, _topBar.lsqGetSizeHeight - 20 + topYDistance/2, self.view.lsqGetSizeWidth, self.view.lsqGetSizeWidth*9/16)];
    [firstPlayerView setBackgroundColor:[UIColor clearColor]];
    firstPlayerView.multipleTouchEnabled = NO;
    [self.view addSubview:firstPlayerView];
    // 添加视频资源
    _firstPlayerItem = [[AVPlayerItem alloc]initWithURL:[self filePathName:@"tusdk_sample_video.mov"]];
    // 播放
    _firstPlayer = [[AVPlayer alloc]initWithPlayerItem:_firstPlayerItem];
    _firstPlayer.volume = 0.5;
    // 播放视频需要在AVPlayerLayer上进行显示
    AVPlayerLayer *firstPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_firstPlayer];
    firstPlayerLayer.frame = firstPlayerView.frame;
    [firstPlayerView.layer addSublayer:firstPlayerLayer];
    // 循环播放的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playSampleOneVideoCycling) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [_firstPlayer play];
    
    // 视频素材二播放器
    UIView *secondPlayerView = [[UIView alloc]initWithFrame:CGRectMake(0, _topBar.lsqGetSizeHeight + 80 + topYDistance, self.view.lsqGetSizeWidth, self.view.lsqGetSizeWidth*9/16)];
    [secondPlayerView setBackgroundColor:[UIColor clearColor]];
    secondPlayerView.multipleTouchEnabled = NO;
    [self.view addSubview:secondPlayerView];
    // 添加视频资源
    _secondPlayerItem = [[AVPlayerItem alloc]initWithURL:[self filePathName:@"tusdk_sample_splice_video.mov"]];
    // 播放
    _secondPlayer = [[AVPlayer alloc]initWithPlayerItem:_secondPlayerItem];
    _secondPlayer.volume = 0.5;
    // 播放视频需要在AVPlayerLayer上进行显示
    AVPlayerLayer *secondPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_secondPlayer];
    secondPlayerLayer.frame = secondPlayerView.frame;
    [secondPlayerView.layer addSublayer:secondPlayerLayer];
    // 循环播放的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playSampleTwoVideoCycling) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [_secondPlayer play];
}


// 顶部栏初始化
- (void)initWithTopBar;
{
    _topBar = [[TopNavBar alloc]initWithFrame:CGRectMake(0,topYDistance, self.view.bounds.size.width, 44)];
    [_topBar setBackgroundColor:[UIColor whiteColor]];
    _topBar.topBarDelegate = self;
    [_topBar addTopBarInfoWithTitle:NSLocalizedString(@"lsq_video_mixed", @"多视频拼接")
                     leftButtonInfo:@[@"video_style_default_btn_back.png"]
                    rightButtonInfo:nil];
    [_topBar.centerTitleLabel lsqSetSizeWidth:_topBar.lsqGetSizeWidth/2];
    _topBar.centerTitleLabel.center = CGPointMake(self.view.lsqGetSizeWidth/2, _topBar.lsqGetSizeHeight/2);
    [self.view addSubview:_topBar];
}

/**
 * 启动视频合成
 */
- (void)startComposing;
{
    if (!_movieComposer && _movieComposer.status == TuSDKAssetVideoComposerStatusStarted) return;
    
    [_firstPlayer pause];
    [_secondPlayer pause];
    
    if (!_movieComposer)
    {
        _movieComposer = [[TuSDKAssetVideoComposer alloc] initWithAsset:nil];
        _movieComposer.delegate = self;
        // 指定输出文件格式
        _movieComposer.outputFileType = lsqFileTypeMPEG4;
        // 指定输出文件的码率
        _movieComposer.outputVideoQuality = [TuSDKVideoQuality makeQualityWith:TuSDKRecordVideoQuality_Low1];
        // 指定输出文件的尺寸，设定后会根据输出尺寸对原视频进行裁剪
        // _movieComposer.outputSize = CGSizeMake(720, 1280);
        
        NSURL *sampleOneURL = [self filePathName:@"tusdk_sample_video.mov"];
        NSURL *sampleTwoURL = [self filePathName:@"tusdk_sample_splice_video.mov"];
        
        // 添加待拼接的视频源
        [_movieComposer addInputAsset:[AVAsset assetWithURL:sampleOneURL]];
        
        // 添加待拼接的视频源
        [_movieComposer addInputAsset:[AVAsset assetWithURL:sampleTwoURL]];
        
        // 移除已添加的视频源
        // [_movieComposer removeInputAsset:(AVAsset * _Nonnull)];
    }

  [_movieComposer startComposing];

}

/**
 取消视频合成
 */
- (void)cancelComposing
{
    if (_movieComposer)
        [_movieComposer cancelComposing];
    
    _movieComposer = nil;
}

#pragma mark - TuSDKAssetVideoComposerDelegate

/**
 合成状态改变事件
 
 @param composer TuSDKAssetVideoComposer
 @param status lsqAssetVideoComposerStatus 当前状态
 */
-(void)assetVideoComposter:(TuSDKAssetVideoComposer *)composer statusChanged:(TuSDKAssetVideoComposerStatus)status
{
    switch (status)
    {
        case TuSDKAssetVideoComposerStatusStarted:
             [[TuSDK shared].messageHub setStatus:NSLocalizedString(@"正在合并...", @"正在合并...")];
            break;
        case TuSDKAssetVideoComposerStatusCompleted:
              [[TuSDK shared].messageHub showSuccess:NSLocalizedString(@"lsq_api_splice_movie_success", @"操作完成，请去相册查看视频")];
            break;
        case TuSDKAssetVideoComposerStatusFailed:
              [[TuSDK shared].messageHub showError:NSLocalizedString(@"lsq_api_splice_movie_failed", @"操作失败，无法生成视频文件")];
            break;
        case TuSDKAssetVideoComposerStatusCancelled:
             [[TuSDK shared].messageHub showError:NSLocalizedString(@"lsq_api_splice_movie_cancelled", @"出现问题，操作被取消")];
            break;
        default:
            break;
    }
}

/**
 合成进度事件
 
 @param composer TuSDKAssetVideoComposer
 @param progress 处理进度
 @param index 当前正在处理的视频索引
 */
-(void)assetVideoComposter:(TuSDKAssetVideoComposer *)composer processChanged:(float)progress assetIndex:(NSUInteger)index
{
     NSLog(@"progress : %f",progress);
}

/**
 视频合成完毕
 
 @param composer TuSDKAssetVideoComposer
 @param result TuSDKVideoResult
 */
-(void)assetVideoComposter:(TuSDKAssetVideoComposer *)composer saveResult:(TuSDKVideoResult *)result
{
    // 视频处理结果
     NSLog(@"result path: %@ ",result.videoAsset);
}

#pragma mark - TopNavBarDelegate

/**
 左侧按钮点击事件
 
 @param btn 按钮对象
 @param navBar 导航条
 */
- (void)onLeftButtonClicked:(UIButton*)btn navBar:(TopNavBar *)navBar;
{
    // 返回按钮
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSURL *)filePathName:(NSString *)fileName
{
    return [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:fileName ofType:nil]];
}

- (void)playSampleOneVideoCycling;
{
    [_firstPlayer seekToTime:CMTimeMake(0, 1)];
    [_firstPlayer play];
}

- (void)playSampleTwoVideoCycling;
{
    [_secondPlayer seekToTime:CMTimeMake(0, 1)];
    [_secondPlayer play];
}

- (void)dealloc;
{
    // 移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    // 销毁播放器
    [self destroyPlayer];
}

- (void)destroyPlayer
{
    if (!_firstPlayer) {
        return;
    }
    [_firstPlayer cancelPendingPrerolls];
    [_firstPlayerItem cancelPendingSeeks];
    [_firstPlayerItem.asset cancelLoading];
    [_firstPlayer pause];
    _firstPlayerItem = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:@""]];
    // 初始化player对象
    self.firstPlayer = [[AVPlayer alloc]initWithPlayerItem:_firstPlayerItem];
    
    _firstPlayer = nil;
    _firstPlayerItem = nil;
    
    if (!_secondPlayer) {
        return;
    }
    [_secondPlayer cancelPendingPrerolls];
    [_secondPlayerItem cancelPendingSeeks];
    [_firstPlayerItem.asset cancelLoading];
    [_secondPlayer pause];
    _secondPlayerItem = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:@""]];
    // 初始化player对象
    self.secondPlayer = [[AVPlayer alloc]initWithPlayerItem:_secondPlayerItem];
    
    _secondPlayer = nil;
    _secondPlayerItem = nil;
}

@end
