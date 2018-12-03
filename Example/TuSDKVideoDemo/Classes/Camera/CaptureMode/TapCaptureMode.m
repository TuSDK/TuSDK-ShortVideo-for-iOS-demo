//
//  TapCaptureMode.m
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/7/17.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "TapCaptureMode.h"
#import "CameraControllerProtocol.h"
#import "RecordButton.h"

@interface TapCaptureMode ()

/**
 录制按钮
 */
@property (nonatomic, strong) RecordButton *recordButton;

@end

@implementation TapCaptureMode

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
    RecordButton *recordButton = [RecordButton buttonWithType:UIButtonTypeCustom];
    _recordButton = recordButton;
    recordButton.contentSize = CGSizeMake(72, 72);
    [recordButton setImage:[UIImage imageNamed:@"video_ic_recording"] forState:UIControlStateNormal];
    [recordButton addTarget:self action:@selector(recordButtonTapAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_cameraController.controlMaskView.doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_cameraController.controlMaskView.undoButton addTarget:self action:@selector(undoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
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
    _cameraController.controlMaskView.moreMenuView.pitchHidden = NO;
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.cameraController.controlMaskView.speedButton.hidden = NO;
        [self.cameraController.controlMaskView updateSpeedSegmentDisplay];
        self.cameraController.controlMaskView.markableProgressView.hidden = NO;
    } completion:^(BOOL finished) {
        
    }];
}

/**
 相机录制状态
 
 @param state 相机录制状态
 */
- (void)recordStateDidChange:(lsqRecordState)state {
    switch (state) {
        case lsqRecordStatePaused:{
            _recordButton.selected = NO;
            [self pauseRecordAction];
        } break;
        case lsqRecordStateRecording:{
            
        } break;
        case lsqRecordStateCanceled:{
            if (_recordButton.selected) {
                _recordButton.selected = !_recordButton.selected;
                [self pauseRecordAction];
            }
        } break;
        default:{} break;
    }
}

/**
 录制进度
 
 @param progress 进度百分比
 */
- (void)recordProgressDidChange:(double)progress {
    _cameraController.controlMaskView.markableProgressView.progress = progress;
    NSLog(@"progress: %@", @(progress));
}

- (void)resetUI {
    [_cameraController.controlMaskView.markableProgressView reset];
    [_cameraController.controlMaskView updateRecordConfrimViewsDisplay];
}

#pragma mark - 按钮事件

/**
 开始录制事件
 
 @param sender 录制按钮
 */
- (void)recordButtonTapAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_cameraController startRecording];
        // 更新 UI
        [_cameraController.controlMaskView hideViewsWhenRecording];
    } else {
        [_cameraController pauseRecording];
    }
    _cameraController.controlMaskView.moreMenuView.disableRatioSwitching = YES;
}

/**
 完成录制事件
 
 @param sender 录制按钮
 */
- (void)doneButtonAction:(UIButton *)sender {
    [_cameraController finishRecording];
}

/**
 撤销上一段事件
 
 @param sender 录制按钮
 */
- (void)undoButtonAction:(UIButton *)sender {
    [_cameraController undoLastRecordedFragment];
    // 更新 UI
    [_cameraController.controlMaskView.markableProgressView popMark];
    [_cameraController.controlMaskView updateRecordConfrimViewsDisplay];
}

#pragma mark - private

/**
 暂停录制动作
 */
- (void)pauseRecordAction {
    [_cameraController.controlMaskView.markableProgressView pushMark];
    [_cameraController.controlMaskView showViewsWhenPauseRecording];
}

@end
