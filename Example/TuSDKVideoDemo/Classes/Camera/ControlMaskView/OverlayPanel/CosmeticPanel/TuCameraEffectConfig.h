//
//  TuCameraEffectConfig.h
//  TuSDKVideoDemo
//
//  Created by 刘鹏程 on 2020/12/8.
//  Copyright © 2020 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TuCameraEffectConfig : NSObject

/**
 *  相机特效参数配置
 *
 *  @return 相机特效参数配置
 */
+ (instancetype)sharePackage;

/**设置默认的微整形参数值*/
- (NSDictionary *)defaultPlasticValue;

/**设置默认的美妆参数值*/
- (NSDictionary *)defaultCosmeticValue;

@end

NS_ASSUME_NONNULL_END
