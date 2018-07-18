//
//  TuSDKMediaStickerEffectData.h
//  TuSDKVideo
//
//  Created by wen on 06/07/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoImport.h"
#import "TuSDKMediaEffectData.h"

/**
 video 贴纸特效
 */
@interface TuSDKMediaStickerEffectData : TuSDKMediaEffectData

/**
 贴纸数据
 */
@property (nonatomic,readonly,strong) TuSDKPFStickerGroup *stickerGroup;

/**
  设置是否开启大眼瘦脸 默认：NO
  @since      v3.0
 */
@property (nonatomic) BOOL enablePlastic;

/**
 初始化方法
 */
- (instancetype)initWithStickerGroup:(TuSDKPFStickerGroup *)stickerGroup;


@end
