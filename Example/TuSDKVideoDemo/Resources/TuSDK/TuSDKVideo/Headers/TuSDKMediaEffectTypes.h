//
//  TuSDKMediaEffectTypes.h
//  TuSDKVideo
//
//  Created by sprint on 18/09/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 特效数据类型
 
 - TuSDKMediaEffectDataTypeFilter: 滤镜特效
 - TuSDKMediaEffectDataTypeAudio: 音频特效
 - TuSDKMediaEffectDataTypeSticker: 贴纸特效
 - TuSDKMediaEffectDataTypeStickerAudio: 贴纸+音效
 - TuSDKMediaEffectDataTypeScene: 场景特效
 - TuSDKMediaEffectDataTypeParticle: 粒子特效
 - TuSDKMediaEffectDataTypeStickerText: 字幕贴纸特效
 - TuSDKMediaEffectDataTypeStickerImage: 图片贴纸特效
 - TuSDKMediaEffectDataTypeComic : 漫画特效
 - TuSDKMediaEffectDataTypePlasticFace : 微整形 v1 大眼廋脸
 - TuSDKMediaEffectDataTypeSkinFace : 美肤特效
 - TuSDKMediaEffectDataTypeMonsterFace : 哈哈镜特效
 - TuSDKMediaEffectDataTypeTransition : 转场
 - TuSDKMediaEffectDataTypeTransition : 绿幕特效
 - TuSDKMediaEffectDataTypeCosmetic : 美妆特效
 - TuSDKMediaEffectDataTypeReshape: 微整形 v2 白牙祛皱

 */
typedef NS_ENUM(NSUInteger,TuSDKMediaEffectDataType)
{
    TuSDKMediaEffectDataTypeFilter = 0,
    TuSDKMediaEffectDataTypeAudio ,
    TuSDKMediaEffectDataTypeSticker,
    TuSDKMediaEffectDataTypeStickerAudio,
    TuSDKMediaEffectDataTypeScene,
    TuSDKMediaEffectDataTypeParticle,
    TuSDKMediaEffectDataTypeStickerText,
    TuSDKMediaEffectDataTypeStickerImage,
    TuSDKMediaEffectDataTypeComic,
    TuSDKMediaEffectDataTypePlasticFace,
    TuSDKMediaEffectDataTypeSkinFace,
    TuSDKMediaEffectDataTypeMonsterFace,
    TuSDKMediaEffectDataTypeTransition,
    TuSDKMediaEffectDataTypeScreenKeying,
    TuSDKMediaEffectDataTypeCosmetic,
    TuSDKMediaEffectDataTypeReshape,

};
