//
//  TuCameraEffectConfig.m
//  TuSDKVideoDemo
//
//  Created by 刘鹏程 on 2020/12/8.
//  Copyright © 2020 TuSDK. All rights reserved.
//

#import "TuCameraEffectConfig.h"

@implementation TuCameraEffectConfig

/**
 *  相机特效参数配置
 *
 *  @return 相机特效参数配置
 */
+ (instancetype)sharePackage;
{
    static dispatch_once_t pred = 0;
    static TuCameraEffectConfig *object = nil;
    dispatch_once(&pred, ^{
        object = [[self alloc]init];
    });
    return object;
}

/**设置默认的微整形参数值*/
- (NSDictionary *)defaultPlasticValue
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[NSNumber numberWithFloat:0.3f] forKey:@"eyeSize"];
    [params setValue:[NSNumber numberWithFloat:0.5f] forKey:@"chinSize"];
    [params setValue:[NSNumber numberWithFloat:0.0f] forKey:@"cheekNarrow"];
    [params setValue:[NSNumber numberWithFloat:0.0f] forKey:@"smallFace"];
    [params setValue:[NSNumber numberWithFloat:0.2f] forKey:@"noseSize"];
    [params setValue:[NSNumber numberWithFloat:0.0f] forKey:@"noseHeight"];
    [params setValue:[NSNumber numberWithFloat:0.5f] forKey:@"mouthWidth"];
    [params setValue:[NSNumber numberWithFloat:0.5f] forKey:@"lips"];
    [params setValue:[NSNumber numberWithFloat:0.5f] forKey:@"philterum"];
    [params setValue:[NSNumber numberWithFloat:0.5f] forKey:@"archEyebrow"];
    [params setValue:[NSNumber numberWithFloat:0.5f] forKey:@"browPosition"];
    [params setValue:[NSNumber numberWithFloat:0.5f] forKey:@"jawSize"];
    [params setValue:[NSNumber numberWithFloat:0.0f] forKey:@"cheekLowBoneNarrow"];
    [params setValue:[NSNumber numberWithFloat:0.5f] forKey:@"eyeAngle"];
    [params setValue:[NSNumber numberWithFloat:0.0f] forKey:@"eyeInnerConer"];
    [params setValue:[NSNumber numberWithFloat:0.0f] forKey:@"eyeOuterConer"];
    [params setValue:[NSNumber numberWithFloat:0.5f] forKey:@"eyeDis"];
    [params setValue:[NSNumber numberWithFloat:0.5f] forKey:@"eyeHeight"];
    [params setValue:[NSNumber numberWithFloat:0.5f] forKey:@"forehead"];
    [params setValue:[NSNumber numberWithFloat:0.5f] forKey:@"cheekBoneNarrow"];
    
    
    return [params copy];
}
/**设置默认的美妆参数值*/
- (NSDictionary *)defaultCosmeticValue
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[NSNumber numberWithFloat:0.4f] forKey:@"lipAlpha"];
    [params setValue:[NSNumber numberWithFloat:0.5f] forKey:@"blushAlpha"];
    [params setValue:[NSNumber numberWithFloat:0.4f] forKey:@"eyebrowAlpha"];
    [params setValue:[NSNumber numberWithFloat:0.5f] forKey:@"eyeshadowAlpha"];
    [params setValue:[NSNumber numberWithFloat:0.5f] forKey:@"eyelineAlpha"];
    [params setValue:[NSNumber numberWithFloat:0.5f] forKey:@"eyeLashAlpha"];
    [params setValue:[NSNumber numberWithFloat:0.5f] forKey:@"facialAlpha"];
    
    return [params copy];
}

@end
