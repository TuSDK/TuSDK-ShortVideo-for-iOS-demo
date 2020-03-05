//
//  APIMutipleVideoEditViewController.h
//  TuSDKVideoDemo
//
//  Created by KK on 2019/12/19.
//  Copyright © 2019 TuSDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIMutipleVideoEditViewController : UIViewController

/**
选取的视频
 */
@property (nonatomic, strong) NSArray<AVURLAsset *> *inputAssets;

@end

NS_ASSUME_NONNULL_END
