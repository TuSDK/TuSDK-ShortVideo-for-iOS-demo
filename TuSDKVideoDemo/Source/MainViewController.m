//
//  MainViewController.m
//  TuSDKVideoDemo
//
//  Created by tutu on 2017/3/9.
//  Copyright © 2017年 TuSDK. All rights reserved.
//

#import "MainViewController.h"
#import "TuSDKFramework.h"
#import "RecordCameraViewController.h"
#import "ComponentListViewController.h"

@interface MainViewController ()<TuSDKFilterManagerDelegate>

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
    
    //设置全屏
    self.wantsFullScreenLayout = YES;
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
    UIButton *recordButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
    recordButton.center = CGPointMake(self.view.lsqGetSizeWidth/2, centerY);
    [recordButton setImage:[UIImage imageNamed:@"style_default_1.6.0_homepage_btn_normal"] forState:UIControlStateNormal];
    recordButton.adjustsImageWhenHighlighted = NO;
    [recordButton addTouchUpInsideTarget:self action:@selector(openRecordVideo)];
    [self.view addSubview:recordButton];
    
    UIImageView *recordButtonIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    recordButtonIcon.center = CGPointMake(45, btnHeight/2);
    recordButtonIcon.image = [UIImage imageNamed:@"style_default_1.8.0_homepage_video_icon"];
    [recordButton addSubview:recordButtonIcon];

    UIImageView *recordButtonNext = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    recordButtonNext.center = CGPointMake(btnWidth - 24, btnHeight/2);
    recordButtonNext.image = [UIImage imageNamed:@"style_default_1.6.0_homepage_next_icon"];
    [recordButton addSubview:recordButtonNext];

    UILabel *recordButtonText = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    recordButtonText.center = CGPointMake(76+75, btnHeight/2);
    recordButtonText.text = NSLocalizedString(@"lsq_video_mainVC_record" , @"录制视频");
    recordButtonText.textColor = [UIColor lsqClorWithHex:@"#553213"];
    recordButtonText.font = [UIFont systemFontOfSize:19];
    [recordButton addSubview:recordButtonText];
    
    centerY = centerY + btnHeight + btnInterval;
    
    // 开始页面 导入视频btn
    UIButton *importButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
    importButton.center = CGPointMake(self.view.lsqGetSizeWidth/2, centerY);
    [importButton setImage:[UIImage imageNamed:@"style_default_1.6.0_homepage_btn_normal"] forState:UIControlStateNormal];
    importButton.adjustsImageWhenHighlighted = NO;
    [importButton addTouchUpInsideTarget: self action:@selector(openComponentListView)];
    [self.view addSubview:importButton];
    
    UIImageView *importButtonIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    importButtonIcon.center = CGPointMake(45, btnHeight/2);
    importButtonIcon.image = [UIImage imageNamed:@"style_default_1.8.0_homepage_tools_icon"];
    [importButton addSubview:importButtonIcon];

    UIImageView *importButtonNext = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    importButtonNext.center = CGPointMake(btnWidth - 24, btnHeight/2);
    importButtonNext.image = [UIImage imageNamed:@"style_default_1.6.0_homepage_next_icon"];
    [importButton addSubview:importButtonNext];

    UILabel *importLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    importLabel.center = CGPointMake(76+75, btnHeight/2);
    importLabel.text = NSLocalizedString(@"lsq_video_componentlist" , @"功能列表");
    importLabel.textColor = [UIColor lsqClorWithHex:@"#553213"];
    importLabel.font = [UIFont systemFontOfSize:19];
    [importButton addSubview:importLabel];
}

#pragma mark - 自定义事件方法
// 开启视频录制
- (void)openRecordVideo;
{
    RecordCameraViewController *vc = [RecordCameraViewController new];
    vc.inputRecordMode = lsqRecordModeKeep;
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
