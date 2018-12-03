//
//  TextEditAreaView+TextEffect.h
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/11/13.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "TextEditAreaView.h"

@class TuSDKMediaTextEffect;

@interface TextEditAreaView (TextEffect)

/**
 生成文字特效
 
 @param videoSize 视频尺寸
 @return 文字特效
 */
- (NSArray<TuSDKMediaTextEffect *> *)generateTextEffectsWithVideoSize:(CGSize)videoSize;

@end
