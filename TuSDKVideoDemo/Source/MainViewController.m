//
//  MainViewController.m
//  TuSDKVideoDemo
//
//  Created by tutu on 2017/3/9.
//  Copyright © 2017年 TuSDK. All rights reserved.
//

#import "MainViewController.h"
#import "TuSDKFramework.h"
#import "ComponentListViewController.h"
#import "MovieRecordFullScreenController.h"
#import "MoviePreviewAndCutRatioAdaptedController.h"
#import "TuAssetManager.h"
#import "TuAlbumViewController.h"
#import "MoviePreviewAndCutFullScreenController.h"

@interface MainViewController ()<TuSDKFilterManagerDelegate,TuVideoSelectedDelegate>

@end

@implementation MainViewController
#pragma mark - 基础配置方法
// 隐藏状态栏 for IOS7
- (BOOL)prefersStatusBarHidden;
{
    return YES;
}

// 是否允许旋转 IOS5
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

// 是否允许旋转 IOS6
-(BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavigationBarHidden:YES animated:NO];
    [self setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}


#pragma mark - 视图布局方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self lsqInitView];
    // 启动GPS
    [[TuSDKTKLocation shared] requireAuthorWithController:self];
    
    // sdk统计代码，请不要加入您的应用
    [TuSDKTKStatistics appendWithComponentIdt:tkc_sdkComponent];
    
    // 异步方式初始化滤镜管理器
    // 需要等待滤镜管理器初始化完成，才能使用所有功能
    [TuSDK checkManagerWithDelegate:self];
}

#pragma mark - TuSDKFilterManagerDelegate
/**
 * 滤镜管理器初始化完成
 *
 * @param manager
 *            滤镜管理器
 */
- (void)onTuSDKFilterManagerInited:(TuSDKFilterManager *)manager;
{
    // 初始化完成
    NSLog(@"TuSDK inited");
}

- (void)lsqInitView
{
    CGRect rect = self.view.bounds;
    // 背景图
    UIImageView *backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width,rect.size.height)];
    backgroundImage.center = self.view.center;
    
    if ([UIDevice lsqIsDeviceiPhoneX])
    { // iPhone X
        backgroundImage.image = [UIImage imageNamed:@"homepage_iphonex"];
    }else{
        backgroundImage.image = [UIImage imageNamed:@"style_default_1.6.0_homepage_bg@2x"];
    }
        
    backgroundImage.userInteractionEnabled = YES;
    [self.view addSubview:backgroundImage];

    CGFloat btnInterval = 8;
    CGFloat btnHeight = 68;
    CGFloat btnWidth = backgroundImage.lsqGetSizeWidth - 32;
    CGFloat centerY = self.view.lsqGetSizeHeight - 32 - 2.5*btnHeight - 2*btnInterval;    
    centerY = centerY + btnHeight + btnInterval;
    
    // 断点续拍
    UIButton *RecordButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
    RecordButton.center = CGPointMake(self.view.lsqGetSizeWidth/2 , centerY - btnHeight - btnInterval);
    [RecordButton setImage:[UIImage imageNamed:@"style_default_1.6.0_homepage_btn_normal"] forState:UIControlStateNormal];
    [RecordButton addTouchUpInsideTarget:self action:@selector(openRecordVideo)];
    RecordButton.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:RecordButton];
    
    UIImageView *RecordButtonIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    RecordButtonIcon.center = CGPointMake(45, btnHeight/2);
    RecordButtonIcon.image = [UIImage imageNamed:@"style_default_1.8.0_homepage_video_icon"];
    [RecordButton addSubview:RecordButtonIcon];
    
    UIImageView *RecordButtonNext = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    RecordButtonNext.center = CGPointMake(btnWidth - 24, btnHeight/2);
    RecordButtonNext.image = [UIImage imageNamed:@"style_default_1.6.0_homepage_next_icon"];
    [RecordButton addSubview:RecordButtonNext];
    
    UILabel *RecordButtonText = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    RecordButtonText.center = CGPointMake(76+75, btnHeight/2);
    RecordButtonText.text = NSLocalizedString(@"lsq_video_mainVC_record", @"录制视频");
    RecordButtonText.textColor = [UIColor lsqClorWithHex:@"#553213"];
    RecordButtonText.font = [UIFont systemFontOfSize:19];
    [RecordButton addSubview:RecordButtonText];
    
    // 相册导入
    UIButton *importButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
    importButton.center = CGPointMake(self.view.lsqGetSizeWidth/2, centerY);
    [importButton setImage:[UIImage imageNamed:@"style_default_1.6.0_homepage_btn_normal"] forState:UIControlStateNormal];
    importButton.adjustsImageWhenHighlighted = NO;
    [importButton addTouchUpInsideTarget:self action:@selector(openImportVideo)];
    [self.view addSubview:importButton];
    
    UIImageView *importButtonIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    importButtonIcon.center = CGPointMake(45, btnHeight/2);
    importButtonIcon.image = [UIImage imageNamed:@"style_default_1.11_homepage_edit_icon"];
    importButtonIcon.contentMode = UIViewContentModeScaleAspectFit;
    [importButton addSubview:importButtonIcon];

    UIImageView *importButtonNext = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    importButtonNext.center = CGPointMake(btnWidth - 24, btnHeight/2);
    importButtonNext.image = [UIImage imageNamed:@"style_default_1.6.0_homepage_next_icon"];
    [importButton addSubview:importButtonNext];

    UILabel *importButtonText = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    importButtonText.center = CGPointMake(76+75, btnHeight/2);
    importButtonText.text = NSLocalizedString(@"lsq_video_mainVC_edit" , @"编辑视频");
    importButtonText.textColor = [UIColor lsqClorWithHex:@"#553213"];
    importButtonText.font = [UIFont systemFontOfSize:19];
    [importButton addSubview:importButtonText];
    
    centerY = centerY + btnHeight + btnInterval;
    
    // 功能列表
    UIButton *componentListButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
    componentListButton.center = CGPointMake(self.view.lsqGetSizeWidth/2, centerY);
    [componentListButton setImage:[UIImage imageNamed:@"style_default_1.6.0_homepage_btn_normal"] forState:UIControlStateNormal];
    componentListButton.adjustsImageWhenHighlighted = NO;
    [componentListButton addTouchUpInsideTarget: self action:@selector(openComponentListView)];
    [self.view addSubview:componentListButton];
    
    UIImageView *componentListButtonIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    componentListButtonIcon.center = CGPointMake(45, btnHeight/2);
    componentListButtonIcon.image = [UIImage imageNamed:@"style_default_1.8.0_homepage_tools_icon"];
    [componentListButton addSubview:componentListButtonIcon];

    UIImageView *componentListButtonNext = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    componentListButtonNext.center = CGPointMake(btnWidth - 24, btnHeight/2);
    componentListButtonNext.image = [UIImage imageNamed:@"style_default_1.6.0_homepage_next_icon"];
    [componentListButton addSubview:componentListButtonNext];

    UILabel *importLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    importLabel.center = CGPointMake(76+75, btnHeight/2);
    importLabel.text = NSLocalizedString(@"lsq_video_componentlist" , @"功能列表");
    importLabel.textColor = [UIColor lsqClorWithHex:@"#553213"];
    importLabel.font = [UIFont systemFontOfSize:19];
    [componentListButton addSubview:importLabel];
}

#pragma mark - 自定义事件方法
// 开启视频录制
- (void)openRecordVideo;
{
    MovieRecordFullScreenController *vc = [MovieRecordFullScreenController new];
    vc.inputRecordMode = lsqRecordModeKeep;
    [self.navigationController pushViewController:vc animated:YES];
}

// 开启相册选择视频

// 相册选择 + preview
- (void)openImportVideo;
{
    [TuAssetManager sharedManager].ifRefresh = YES;
    TuAlbumViewController *videoSelector = [[TuAlbumViewController alloc] init];
    videoSelector.selectedDelegate = self;
    // 若需要选择视频后进行预览 设置为YES，默认为NO
    videoSelector.isPreviewVideo = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:videoSelector];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - TuVideoSelectedDelegate

- (void)selectedModel:(TuVideoModel *)model;
{
    NSURL *url = model.url;
    MoviePreviewAndCutFullScreenController *vc = [MoviePreviewAndCutFullScreenController new];
    vc.inputURL = url;
    [self.navigationController pushViewController:vc animated:YES];
    
}
// 打开功能展示列表
- (void)openComponentListView;
{
    ComponentListViewController *vc = [ComponentListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
