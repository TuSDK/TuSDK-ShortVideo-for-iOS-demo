//
//  PhotoCaptureMode.m
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/7/17.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "PhotoCaptureMode.h"
#import "CameraControllerProtocol.h"
#import "RecordButton.h"
#import "TuSDKFramework.h"

@interface PhotoCaptureMode ()

/**
 录制按钮（拍照功能）
 */
@property (nonatomic, strong) RecordButton *recordButton;

/**
 拍照结果
 */
@property (nonatomic, strong) UIImage *capturedImage;

@end

@implementation PhotoCaptureMode

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

/**
 初始化相机控制器
 
 @param cameraController 相机控制器
 @return 相机控制器
 */
- (instancetype)initWithCameraController:(id<CameraControllerProtocol>)cameraController {
    if (self = [super init]) {
        _cameraController = cameraController;
        [self commonInit];
    }
    return self;
}

/**
 创建按钮
 */
- (void)commonInit {
    RecordButton *recordButton = [RecordButton buttonWithType:UIButtonTypeSystem];
    _recordButton = recordButton;
    recordButton.contentSize = CGSizeMake(72, 72);
    recordButton.dotColor = [UIColor whiteColor];
    [recordButton addTarget:self action:@selector(recordButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];
}

/**
 更新界面
 */
- (void)updateModeUI {
    for (UIView *view in _cameraController.controlMaskView.captureButtonStackView.arrangedSubviews) {
        [_cameraController.controlMaskView.captureButtonStackView removeArrangedSubview:view];
        [view removeFromSuperview];
    }
    [_cameraController.controlMaskView.captureButtonStackView addArrangedSubview:_recordButton];
    _cameraController.controlMaskView.moreMenuView.pitchHidden = YES;
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.cameraController.controlMaskView.speedButton.hidden = YES;
        [self.cameraController.controlMaskView updateSpeedSegmentDisplay];
        self.cameraController.controlMaskView.markableProgressView.hidden = YES;
    } completion:^(BOOL finished) {
        
    }];
}

/**
 重置
 */
- (void)resetUI {}

#pragma mark - 按钮事件

/**
 拍照事件

 @param sender 录制按钮（拍照功能）
 */
- (void)recordButtonTapAction:(UIButton *)sender {
    UIImage *capturedImage = self.cameraController.captureImage;
    _capturedImage = capturedImage;
    CGFloat ratio = self.cameraController.ratio;
    [_cameraController.controlMaskView showPhotoCaptureConfirmViewWithConfig:^(PhotoCaptureConfirmView *confirmView) {
        confirmView.photoView.image = capturedImage;
        [confirmView.doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [confirmView.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        confirmView.photoRatio = ratio;
    }];
}

/**
 点击拍照事件

 @param sender 录制按钮（拍照功能）
 */
- (void)doneButtonAction:(UIButton *)sender {
    // 保存到相册
    [TuSDKTSAssetsManager saveWithImage:_capturedImage compress:0 metadata:nil toAblum:nil completionBlock:^(id<TuSDKTSAssetInterface> asset, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.capturedImage = nil;
                [[TuSDK shared].messageHub showSuccess:NSLocalizedStringFromTable(@"tu_保存成功", @"VideoDemo", @"保存成功")];
            });
        }
    } ablumCompletionBlock:nil];
    [_cameraController.controlMaskView hidePhotoCaptureConfirmView];
}

/**
 返回主页面

 @param sender 录制按钮（拍照功能）
 */
- (void)backButtonAction:(UIButton *)sender {
    [_cameraController.controlMaskView hidePhotoCaptureConfirmView];
}

@end
