//
//  TuSDKMediaSkinNaturalEffect.h
//  TuSDKVideo
//
//  Created by sprint on 2018/12/17.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKMediaEffectCore.h"

NS_ASSUME_NONNULL_BEGIN

/**
 美肤美颜特效
 @sicne v3.2.0
 */
@interface TuSDKMediaSkinFaceEffect : TuSDKMediaEffectCore

/**
 初始化美颜特效

 @param useSkinNatural 是否使用自然美颜
 @return TuSDKMediaSkinFaceEffect 美肤美颜特效实例
 @since v3.2.0
 */
-(instancetype)initUseSkinNatural:(BOOL)useSkinNatural;

@end

NS_ASSUME_NONNULL_END
