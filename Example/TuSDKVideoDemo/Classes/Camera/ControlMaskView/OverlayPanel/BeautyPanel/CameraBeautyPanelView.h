//
//  CameraBeautyPanelView.h
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/7/23.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayViewPtotocol.h"
#import "CameraFilterPanelProtocol.h"

/**
 美化面板
 */
@interface CameraBeautyPanelView : UIView <OverlayViewPtotocol, CameraFilterPanelProtocol>

/// 触发者
@property (nonatomic, weak) UIControl *sender;

/**
 选中索引，0 为美颜页面，1 为微整形页面
 */
@property (nonatomic, assign, readonly) NSInteger selectedIndex;

@property (nonatomic, weak) id<CameraFilterPanelDelegate> delegate;
@property (nonatomic, weak) id<CameraFilterPanelDataSource> dataSource;

@end
