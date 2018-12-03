//
//  CameraBeautySkinListView.h
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/9/17.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "HorizontalListView.h"

// 滤镜等级数量
static const int kBeautyLevelCount = 5;

/**
 美颜滤镜列表
 */
@interface CameraBeautySkinListView : HorizontalListView

/**
 点击回调
 */
@property (nonatomic, copy) void (^itemViewTapActionHandler)(CameraBeautySkinListView *listView, HorizontalListItemView *selectedItemView, int level);

/**
 选中的美颜等级
 */
@property (nonatomic, assign) int level;

@end
