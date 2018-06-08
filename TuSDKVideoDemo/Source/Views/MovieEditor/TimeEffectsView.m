//
//  TimeEffectsView.m
//  TuSDKVideoDemo
//
//  Created by sprint on 27/04/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TimeEffectsView.h"

#include <CoreGraphics/CGGeometry.h>

@implementation TimeEffectsView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initContentView];
    }
    return self;
}

-(void)initContentView
{
    CGFloat btnW = 160,btnH = 40;
    CGFloat hSpace = (CGRectGetWidth(self.frame) - btnW * 2) / 3;
    
    _timeEffectSlowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_timeEffectSlowButton setTitle:@"0-1秒慢动作特效" forState:UIControlStateNormal];
    [_timeEffectSlowButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_timeEffectSlowButton setBackgroundColor:[UIColor whiteColor]];
    [_timeEffectSlowButton addTarget:self action:@selector(onTimeEffectSlowModeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    _timeEffectSlowButton.frame = CGRectMake(hSpace, CGRectGetMaxY(self.frame)  - 60, btnW, btnH);
    [self addSubview:_timeEffectSlowButton];
    
    
    _timeEffectRepeatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_timeEffectRepeatButton setTitle:@"0-1秒反复特效" forState:UIControlStateNormal];
    [_timeEffectRepeatButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_timeEffectRepeatButton setBackgroundColor:[UIColor whiteColor]];
    [_timeEffectRepeatButton addTarget:self action:@selector(onTimeEffectRepeatModeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    _timeEffectRepeatButton.frame = CGRectMake(CGRectGetMaxX(_timeEffectSlowButton.frame) + hSpace, CGRectGetMinY(_timeEffectSlowButton.frame), btnW, btnH);
    [self addSubview:_timeEffectRepeatButton];
    
    _sequencePlayModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sequencePlayModeButton setTitle:@"正常模式" forState:UIControlStateNormal];
    [_sequencePlayModeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_sequencePlayModeButton setBackgroundColor:[UIColor whiteColor]];
    [_sequencePlayModeButton addTarget:self action:@selector(onSequencePlayModeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    _sequencePlayModeButton.frame = CGRectMake(hSpace, CGRectGetMinY(_timeEffectRepeatButton.frame)  - 60, btnW, btnH);
    [self addSubview:_sequencePlayModeButton];
    
    
    _reversePlayModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_reversePlayModeButton setTitle:@"倒序模式" forState:UIControlStateNormal];
    [_reversePlayModeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_reversePlayModeButton setBackgroundColor:[UIColor whiteColor]];
    [_reversePlayModeButton addTarget:self action:@selector(onReversePlayModeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    _reversePlayModeButton.frame = CGRectMake(CGRectGetMaxX(_sequencePlayModeButton.frame) + hSpace,CGRectGetMinY(_sequencePlayModeButton.frame), btnW, btnH);
    [self addSubview:_reversePlayModeButton];
}

#pragma mark Events

/**
 设置为正序播放时

 @param sender
 */
-(void)onSequencePlayModeButtonTapped:(id)sender
{
    if (!_delegate || ![_delegate respondsToSelector:@selector(timeEffectView:playModeChanged:)]) return;
    
    [_delegate timeEffectView:self playModeChanged:lsqMovieEditorPlayModeSequence];
}

/**
 设置为正序播放时
 
 @param sender
 */
-(void)onReversePlayModeButtonTapped:(id)sender
{
    if (!_delegate || ![_delegate respondsToSelector:@selector(timeEffectView:playModeChanged:)]) return;
    
    [_delegate timeEffectView:self playModeChanged:lsqMovieEditorPlayModeReverse];
}

/**
 设置慢动作时间特效模式
 
 @param sender
 */
-(void)onTimeEffectSlowModeButtonTapped:(id)sender
{
    if (!_delegate || ![_delegate respondsToSelector:@selector(timeEffectView:timeEffectModeChanged:timeRange:)]) return;
    
    [_delegate timeEffectView:self timeEffectModeChanged:lsqMovieEditorTimeEffectModeSlow timeRange:[TuSDKTimeRange makeTimeRangeWithStart:CMTimeMake(0, 1) end:CMTimeMake(1, 1)]];
}

/**
 设置反复时间特效模式
 
 @param sender
 */
-(void)onTimeEffectRepeatModeButtonTapped:(id)sender
{
    if (!_delegate || ![_delegate respondsToSelector:@selector(timeEffectView:timeEffectModeChanged:timeRange:)]) return;
    
    [_delegate timeEffectView:self timeEffectModeChanged:lsqMovieEditorTimeEffectModeRepeat timeRange:[TuSDKTimeRange makeTimeRangeWithStart:CMTimeMake(0, 1) end:CMTimeMake(1, 1)]];
}

@end
