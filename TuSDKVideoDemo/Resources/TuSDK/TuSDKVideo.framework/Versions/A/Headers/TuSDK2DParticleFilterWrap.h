//
//  TuSDK2DParticleFilterWrap.h
//  TuSDK
//
//  Created by sprint on 04/06/2018.
//  Copyright © 2018 tusdk.com. All rights reserved.
//

#import "TuSDKFilterWrap.h"

/**
 粒子特效FilterWrap
 @since     v3.0
 */
@interface TuSDK2DParticleFilterWrap : TuSDKFilterWrap

#pragma mark - particle

/**
 更新粒子发射器位置
 
 @param point 粒子发射器位置  左上角为(0,0)  右下角为(1,1)
 */
- (void)updateParticleEmitPosition:(CGPoint)point;

/**
 更新粒子特效材质大小 0~1
 
 @param size 粒子特效材质大小
 @since      v2.0
 */
- (void)updateParticleEmitSize:(CGFloat)size;

/**
 更新 下一次添加的 粒子特效颜色  注：对当前正在添加或已添加的粒子不生效
 
 @param color 粒子特效颜色
 @since      v2.0
 */
- (void)updateParticleEmitColor:(UIColor *)color;

@end
