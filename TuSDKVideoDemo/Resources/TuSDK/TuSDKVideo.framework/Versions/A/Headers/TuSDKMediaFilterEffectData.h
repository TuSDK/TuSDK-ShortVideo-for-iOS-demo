//
//  TuSDKMediaFilterEffectData.h
//  TuSDKVideo
//
//  Created by sprint on 19/05/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKMediaEffectData.h"

/**
 滤镜特效
 */
@interface TuSDKMediaFilterEffectData : TuSDKMediaEffectData

/**
 初级滤镜code初始化

 @param effectCode 滤镜code
 @return TuSDKMediaFilterEffectData
 */
-(instancetype)initWithEffectCode:(NSString *)effectCode;

/**
 * 特效code
 */
@property (nonatomic,copy,readonly) NSString * effectCode;

@end
