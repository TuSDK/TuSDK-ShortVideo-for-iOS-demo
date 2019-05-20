//
//  HomeViewController.m
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/6/15.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "HomeViewController.h"
#import "TuSDKFramework.h"
#import "MultiVideoPickerViewController.h"
#import "MovieCutViewController.h"
#import "MovieEditViewController.h"
#import "CameraViewController.h"
#import "MoviePreviewViewController.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *recordItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *editItemLabel;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"TuSDK.framework 的版本号 : %@",lsqSDKVersion);
    NSLog(@"TuSDKVideo.framework 的版本号 : %@",lsqVideoVersion);
    NSLog(@"TuSDKFace.framework 的版本号 : %@",lsqFaceVersion);
    
    // 配置 UI
    UIImageView *backgroundView = [self.navigationController.navigationBar valueForKey:@"_backgroundView"];
    for (UIView *view in backgroundView.subviews) {
        if (view.bounds.size.height <= 1.0f) {
            [view removeFromSuperview];
        }
    }
    
    // 国际化
    _recordItemLabel.text = NSLocalizedStringFromTable(@"tu_录制", @"VideoDemo", @"录制");
    _editItemLabel.text = NSLocalizedStringFromTable(@"tu_剪辑", @"VideoDemo", @"剪辑");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

/**
 启动相机事件

 @param sender 点击的按钮
 */
- (IBAction)recordButtonAction:(UIButton *)sender {
    CameraViewController *record = [CameraViewController recordController];
    [self.navigationController pushViewController:record animated:YES];
}

/**
 启动视频相册

 @param sender 点击的按钮
 */
- (IBAction)editButtonAction:(UIButton *)sender {
    // 若希望直接进入视频编辑，可直接解开下面注释
    // NSURL *inputURL = [[NSBundle mainBundle] URLForResource:@"tusdk_sample_video" withExtension:@"mov"];
    // [self actionAfterMovieCutWithURL:inputURL];
    
    // 先进入视频选择器，再对选取的视频时长进行裁剪，然后进入视频编辑
    MultiVideoPickerViewController *picker = [[MultiVideoPickerViewController alloc] initWithNibName:nil bundle:nil];
    picker.maxSelectedCount = 9;
    picker.rightButtonActionHandler = ^(MultiVideoPickerViewController *picker, UIButton *sender) {
        NSArray *assets = [picker allSelectedAssets];
        if (assets.count) [self actionAfterPickVideos:assets];
    };
    [self.navigationController pushViewController:picker animated:YES];
}

/**
 相册返回数据，进入视频时间裁剪

 @param assets 相册返回数据
 */
- (void)actionAfterPickVideos:(NSArray<AVURLAsset *> *)assets {
    MovieCutViewController *cutter = [[MovieCutViewController alloc] initWithNibName:nil bundle:nil];
    cutter.inputAssets = assets;
    cutter.rightButtonActionHandler = ^(MovieCutViewController *cutter, UIButton *sender) {
        [self actionAfterMovieCutWithURL:cutter.outputURL];
    };
    [self.navigationController pushViewController:cutter animated:YES];
}

/**
 相册进入视频编辑器

 @param inputURL 视频文件 URL 地址
 */
- (void)actionAfterMovieCutWithURL:(NSURL *)inputURL {
    MovieEditViewController *edit = [[MovieEditViewController alloc] initWithNibName:nil bundle:nil];
    edit.inputURL = inputURL;
    [self.navigationController pushViewController:edit animated:YES];
}

@end
