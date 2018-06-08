//
//  TuSDKMediaStickerAudioEffectData.h
//  TuSDKVideo
//
//  Created by wen on 06/07/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoImport.h"
#import "TuSDKMediaEffectData.h"
#import "TuSDKMediaStickerEffectData.h"
#import "TuSDKMediaAudioEffectData.h"

/**
 video MV 特效
 */
@interface TuSDKMediaStickerAudioEffectData : TuSDKMediaEffectData

/**
 本地音频地址
*/
@property (nonatomic,readonly) TuSDKMediaAudioEffectData *audioEffect;

/**
 贴纸数据
 */
@property (nonatomic,strong,readonly) TuSDKMediaStickerEffectData *stickerEffect;

/**
 音频音量
 */
@property (nonatomic, assign) CGFloat audioVolume;


/**
 初始化方法
 */
- (instancetype)initWithAudioURL:(NSURL *)audioURL stickerGroup:(TuSDKPFStickerGroup *)stickerGroup;

@end
