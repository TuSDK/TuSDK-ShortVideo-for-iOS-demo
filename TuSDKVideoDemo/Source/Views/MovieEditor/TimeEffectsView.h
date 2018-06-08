//
//  TimeEffectsView.h
//  TuSDKVideoDemo
//
//  Created by sprint on 27/04/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKFramework.h"

@class TimeEffectsView;


/**
 TimeEffectsView 事件委托
 */
@protocol TimeEffectsViewDelegate <NSObject>

@optional
/**
 视频播放模式改变

 @param effectsView TimeEffectsView
 @param playMode 当前设置的播放模式
 */
-(void)timeEffectView:(TimeEffectsView *)effectsView playModeChanged:(lsqMovieEditorPlayMode)playMode;

/**
 设置时间特效模式i
 
 @param effectsView TimeEffectsView
 @param timeEffectMode 时间特效模式
 @param timeRange 触发时间区间
 */
-(void)timeEffectView:(TimeEffectsView *)effectsView timeEffectModeChanged:(lsqMovieEditorTimeEffectMode)timeEffectMode timeRange:(TuSDKTimeRange *)timeRange;

@end

/**
 * 时间特效视图
 */
@interface TimeEffectsView : UIView


@property (nonatomic,weak) id<TimeEffectsViewDelegate> delegate;


// 正序播放模式
@property (nonatomic, readonly) UIButton *sequencePlayModeButton;

// 倒序播放模式
@property (nonatomic, readonly) UIButton *reversePlayModeButton;


// 时间特效-慢动作
@property (nonatomic, readonly) UIButton *timeEffectSlowButton;

// 时间特效-反复
@property (nonatomic, readonly) UIButton *timeEffectRepeatButton;


@end
