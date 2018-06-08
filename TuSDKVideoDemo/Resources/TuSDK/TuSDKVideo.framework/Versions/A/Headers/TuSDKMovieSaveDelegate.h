//
//  TuSDKMovieSaveDelegate.h
//  TuSDKVideo
//
//  Created by sprint on 08/05/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TuSDKVideoResult.h"

/**
 * TuSDKMovieSaveDelegate
 */
@protocol TuSDKMovieSaveDelegate <NSObject>

@required
/**
 保存结果信息

 @param result TuSDKVideoResult
 */
- (void)onSaveResult:(TuSDKVideoResult *)result;

@end
