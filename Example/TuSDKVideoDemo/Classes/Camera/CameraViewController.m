//
//  CameraViewController.m
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/7/17.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import "CameraViewController.h"
#import "TuSDKFramework.h"
// 相机模式
#import "LongPressCaptureMode.h"
#import "TapCaptureMode.h"
#import "PhotoCaptureMode.h"
// 资源配置列表
#import "Constants.h"
#import "CameraFilterPanelView.h"

#define kNormalFilterCodes @[@"Normal", kCameraNormalFilterCodes]
#define kComicsFilterCodes @[@"Normal", kCameraComicsFilterCodes]

// 顶部工具栏高度
static const CGFloat kTopBarHeight = 64.0;
// 滤镜参数默认值键
static NSString * const kFilterParameterDefaultKey = @"default";
// 滤镜参数最大值键
static NSString * const kFilterParameterMaxKey = @"max";

@interface CameraViewController (UIDelegate) <
CameraControlMaskViewDelegate,
CameraMoreMenuViewDelegate,
CameraFilterPanelDelegate,
StickerPanelViewDelegate,
UIGestureRecognizerDelegate
>
@end
@interface CameraViewController (State) <TuSDKVideoCameraDelegate>
@end
@interface CameraViewController (Record) <TuSDKRecordVideoCameraDelegate>
@end
@interface CameraViewController (Capture) <TuSDKVideoCameraDelegate>
@end


@interface CameraViewController ()

/**
 录制相机对象
 */
@property (nonatomic, strong) TuSDKRecordVideoCamera *camera;

/**
 当前获取的滤镜对象
 */
@property (nonatomic, weak) TuSDKFilterWrap *currentFilter;

/**
 相机预览
 */
@property (weak, nonatomic) IBOutlet UIView *cameraView;

/**
 滤镜码 filterCode
 */
@property (nonatomic, strong) NSArray *filterCodes;

/**
 默认滤镜码
 */
@property (nonatomic, copy) NSString *defaultFilterCode;

/**
 美颜参数，该字典值从美颜面板中来，并应用到所有滤镜
 */
@property (nonatomic, strong) NSMutableDictionary *beautyFilterParameters;

/**
 滤镜参数默认值
 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSDictionary *> *filterParameterDefaultDic;

@end


@implementation CameraViewController

#pragma mark - 界面

+ (instancetype)recordController {
    return [[CameraViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 滤镜列表，获取滤镜前往 TuSDK.bundle/others/lsq_tusdk_configs.json
    // TuSDK 滤镜信息介绍 @see-https://tutucloud.com/docs/ios/self-customize-filter
    _filterCodes = kNormalFilterCodes;
    _beautyFilterParameters = [NSMutableDictionary dictionary];
    _filterParameterDefaultDic = [NSMutableDictionary dictionary];

    // 获取相册的权限
    [self requestAlbumPermission];
    
    // 添加后台、前台切换的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackFromFront) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFrontFromBack) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    // 设置UI
    [self setupUI];
}

- (void)viewDidLayoutSubviews {
    // 获取相机的权限并启动相机
    if (!_camera) [self requestCameraPermission];
    
    [_camera updateCameraViewBounds:_cameraView.bounds];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 当从别的页面返回相机页面时，需要判断相机状态
    // if (_camera && _camera.state == lsqCameraStatePaused) {
    //     [_camera resumeCameraCapture];
    // }
    // 设置屏幕常亮，默认是NO
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 相机跳转至其他页面，操作后如需返回相机界面，需要暂停相机
    // [_camera pauseCameraCapture];
    // 关闭屏幕常亮
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

/**
 界面配置
 */
- (void)setupUI {
    [self setNavigationBarHidden:YES animated:NO];
    if (![UIDevice lsqIsDeviceiPhoneX]) {
        [self setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
    
    [_controlMaskView.speedSegmentButton addTarget:self action:@selector(speedSegmentValueChangeAction:) forControlEvents:UIControlEventValueChanged];
}

/**
 配置相机摄像头和闪光灯信息
 */
- (void)setupUIAfterCameraSetup {
    // 同步相机镜头位置
    _controlMaskView.moreMenuView.disableFlashSwitching = _camera.cameraPosition == AVCaptureDevicePositionFront;
}

#pragma mark - 后台前台切换

/**
 进入后台
 */
- (void)enterBackFromFront {
    if (_camera) {
        // 取消录制
        [self cancelRecording];
        // 暂停捕捉画面
        [_camera stopCameraCapture];
    }
    // 关闭闪光灯
    _controlMaskView.moreMenuView.enableFlash = NO;
    // 同步相机闪光和和摄像头信息
    _controlMaskView.moreMenuView.disableFlashSwitching = _camera.cameraPosition == AVCaptureDevicePositionFront;
}

/**
 恢复前台
 */
- (void)enterFrontFromBack {
    if (_camera) {
        [_camera startCameraCapture];
    }
    // 恢复UI界面
    [_captureMode resetUI];
}

#pragma mark - 权限请求

/**
 相册权限请求
 */
-(void)requestAlbumPermission {
    // 测试相册访问权限
    [TuSDKTSAssetsManager testLibraryAuthor:^(NSError *error) {
         if (error) {
             [TuSDKTSAssetsManager showAlertWithController:self loadFailure:error];
         }
     }];
}

/**
 获取相机相关权限，并启动相机
 */
-(void)requestCameraPermission {
    // 开启访问相机权限
    [TuSDKTSDeviceSettings checkAllowWithController:self type:lsqDeviceSettingsCamera completed:^(lsqDeviceSettingsType type, BOOL openSetting) {
        if (openSetting) {
            lsqLError(@"Can not open camera");
            return;
        }
        [self setupCamera];
        // 启动相机
        [self.camera tryStartCameraCapture];
        // 设置默认滤镜
        self.defaultFilterCode = self.filterCodes[2];
        [self.camera switchFilterWithCode:self.defaultFilterCode];
    }];
}

#pragma mark - 启动相机

/**
 初始化相机
 */
- (void)setupCamera {
    // 启动摄像头
    if (_camera) return;
    _camera = [TuSDKRecordVideoCamera initWithSessionPreset:AVCaptureSessionPresetHigh
                                             cameraPosition:[AVCaptureDevice lsqFirstFrontCameraPosition]
                                                 cameraView:_cameraView];
    
    // 设置录制文件格式(默认：lsqFileTypeQuickTimeMovie)
    _camera.fileType = lsqFileTypeMPEG4;
    // 设置委托
    _camera.videoDelegate = self;
    // 配置相机参数
    // 相机预览画面区域显示算法
    //CGFloat offset = 64/self.view.lsqGetSizeHeight;
    //if ([UIDevice lsqIsDeviceiPhoneX]) {
    //    offset = 108/self.view.lsqGetSizeHeight;
    //}
    //_camera.regionHandler.offsetPercentTop = offset;
    
    // 输出全屏视频画面
    _camera.cameraViewRatio = 0;
    // 指定比例后，如不指定尺寸，SDK 会根据设备情况自动输出适应比例的尺寸
    // _camera.outputSize = CGSizeMake(640, 640);
    
    // 输出视频的画质，主要包含码率、分辨率等参数 (默认为空，采用系统设置)
    _camera.videoQuality = [TuSDKVideoQuality makeQualityWith:TuSDKRecordVideoQuality_Medium2];
    // 禁止触摸聚焦功能 (默认: NO)
    _camera.disableTapFocus = NO;
    // 是否禁用持续自动对焦
    _camera.disableContinueFoucs = NO;
    // 视频覆盖区域颜色 (默认：[UIColor blackColor])
    _camera.regionViewColor = [UIColor clearColor];
    // 禁用前置摄像头自动水平镜像 (默认: NO，前置摄像头拍摄结果自动进行水平镜像)
    _camera.disableMirrorFrontFacing = NO;
    // 默认闪光灯模式
    [_camera flashWithMode:AVCaptureFlashModeOff];
    // 相机采集帧率，默认30帧
    _camera.frameRate = 30;
    // 不保存到相册，可在代理方法中获取 result.videoPath（默认：YES，录制完成自动保存到相册）
    _camera.saveToAlbum = NO;
    // 启用动态贴纸权限
    _camera.enableLiveSticker = YES;
    // 设置是否启用人脸检测。 如果使用人脸贴纸及微整形功能，该项需置为 YES。 （注：须在相机启动之前调用）
    _camera.enableFaceDetection = YES;
    // 设置水印，默认为空
    _camera.waterMarkImage = [UIImage imageNamed:@"sample_watermark.png"];
    // 设置水印图片的位置
    _camera.waterMarkPosition = lsqWaterMarkBottomRight;
    // 最大录制时长 15s
    _camera.maxRecordingTime = 15;
    // 最小录制时长 3s
    _camera.minRecordingTime = 3;
    // 相机录制模式：续拍模式
    _camera.recordMode = lsqRecordModeKeep;
    //  设置使用录制相机最小空间限制，开发者可根据需要自行设置（单位：字节 默认：50M）
    _camera.minAvailableSpaceBytes  = 1024.f*1024.f*50.f;
    // 设置视频速率 默认：标准  包含：标准、慢速、极慢、快速、极快
    _camera.speedMode = lsqSpeedMode_Normal;
    // 设置检测框最小倍数 [取值范围: 0.1 < x < 0.5, 默认: 0.2] 值越大性能越高距离越近
    [_camera setDetectScale:0.2f];
    // 更新其他 UI
    [self setupUIAfterCameraSetup];
}

#pragma mark - 界面按钮事件

/**
 返回按钮事件

 @param sender 返回按钮事件
 */
- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 相机模式切换控件事件

 @param sender 相机模式切换按钮
 */
- (IBAction)captureModeChangeAction:(TextPageControl *)sender {
    switch (sender.selectedIndex) {
        case 0:{
            // 拍照模式
            self.captureMode = [[PhotoCaptureMode alloc] initWithCameraController:self];
        } break;
        case 1:{
            // 长按录制模式
            self.captureMode = [[LongPressCaptureMode alloc] initWithCameraController:self];
        } break;
        case 2:{
            // 点按录制模式
            self.captureMode = [[TapCaptureMode alloc] initWithCameraController:self];
        } break;
    }
    // 相机模式状态更新
    [_captureMode updateModeUI];
}

/**
 速率分段按钮值变更事件

 @param sender 录制速率改变按钮
 */
- (void)speedSegmentValueChangeAction:(CameraSpeedSegmentButton *)sender {
    lsqSpeedMode speedMode = _camera.speedMode;
    switch (sender.selectedIndex) {
        case 0:{
            // 极慢模式  原始速度 0.5 倍率
            speedMode = lsqSpeedMode_Slow2;
        } break;
        case 1:{
            // 慢速模式 原始速度 0.7 倍率
            speedMode = lsqSpeedMode_Slow1;
        } break;
        case 2:{
            // 标准模式 原始速度
            speedMode = lsqSpeedMode_Normal;
        } break;
        case 3:{
            // 快速模式 原始速度 1.5 倍率
            speedMode = lsqSpeedMode_Fast1;
        } break;
        case 4:{
            // 极快模式 原始速度 2.0 倍率
            speedMode = lsqSpeedMode_Fast2;
        } break;
    }
    _camera.speedMode = speedMode;
}

/**
 切换摄像头按钮事件

 @param sender 切换摄像头位置按钮
 */
- (IBAction)switchCameraButtonAction:(UIButton *)sender {
    [_camera rotateCamera];
    _controlMaskView.moreMenuView.enableFlash = NO;
    _controlMaskView.moreMenuView.disableFlashSwitching = _camera.cameraPosition == AVCaptureDevicePositionFront;
}

/**
 左滑手势响应事件

 @param sender 左滑手势
 */
- (IBAction)leftSwipeAction:(UISwipeGestureRecognizer *)sender {
    [self switchToNextFilter];
}

/**
 右滑手势响应事件

 @param sender 右滑手势
 */
- (IBAction)rightSwipeAction:(UISwipeGestureRecognizer *)sender {
    [self switchToPreviousFilter];
}

/**
 切换前一个滤镜
 */
- (void)switchToPreviousFilter {
    NSString *currentFilterCode = _currentFilter.code;
    NSInteger currentFilterIndex = [_filterCodes containsObject:currentFilterCode] ? [_filterCodes indexOfObject:currentFilterCode] : _filterCodes.count - 1;
    
    NSInteger previousFilterIndex = currentFilterIndex - 1;
    
    while (previousFilterIndex < 0) {
        previousFilterIndex += _filterCodes.count;
    }
    [_camera switchFilterWithCode:_filterCodes[previousFilterIndex]];
}

/**
 切换至后一个滤镜
 */
- (void)switchToNextFilter {
    NSString *currentFilterCode = _currentFilter.code;
    NSInteger currentFilterIndex = [_filterCodes containsObject:currentFilterCode] ? [_filterCodes indexOfObject:_currentFilter.code] : 0;
    
    NSInteger nextFilterIndex = (currentFilterIndex + 1) % _filterCodes.count;
    
    [_camera switchFilterWithCode:_filterCodes[nextFilterIndex]];
}

/**
 获取图片

 @return 拍照结果
 */
- (UIImage *)captureImage {
    UIImage *captureImage = [_camera syncCaptureImage];
    return captureImage;
}

/**
 获取相机预览比例

 @return 预览界面比例
 */
- (CGFloat)ratio {
    return _camera.cameraViewRatio;
}

#pragma mark - 相机操作

/**
 开始录制
 */
- (void)startRecording {
    [_camera startRecording];
}

/**
 暂停录制
 */
- (void)pauseRecording {
    [_camera pauseRecording];
}

/**
 结束录制
 */
- (void)finishRecording {
    [_camera finishRecording];
}

/**
 取消录制
 */
- (void)cancelRecording {
    [_camera cancelRecording];
}

/**
 撤销上一段
 */
- (void)undoLastRecordedFragment {
    // 删除最后一段录制的视频片段
    [_camera popMovieFragment];
}

#pragma mark - 滤镜相关

/**
 设置当前滤镜对象
 
 @param currentFilter 当前滤镜对象
 */
- (void)setCurrentFilter:(TuSDKFilterWrap *)currentFilter {
    _currentFilter = currentFilter;
    
    // 更新在相机界面上显示的滤镜名称
    NSString *filterName = [NSString stringWithFormat:@"lsq_filter_%@", currentFilter.code];
    self.controlMaskView.filterName = NSLocalizedStringFromTable(filterName, @"TuSDKConstants", @"无需国际化");
    
    // 恢复参数默认值
    [self resetParameterOfFilter:currentFilter];
    
    // 更新滤镜参数面板
    if (self.controlMaskView.filterPanelView.display) {
        self.controlMaskView.filterPanelView.selectedFilterCode = currentFilter.code;
        [self.controlMaskView.filterPanelView reloadFilterParamters];
    }
    
    // 更新美颜面板
    if (self.controlMaskView.beautyPanelView.display) {
        [self.controlMaskView.beautyPanelView reloadFilterParamters];
    };
}

/**
 滤镜参数调整

 @param filter 滤镜对象
 */
- (void)resetParameterOfFilter:(TuSDKFilterWrap *)filter {
    NSArray<TuSDKFilterArg *> *args = filter.filterParameter.args;
    BOOL needSubmitParameter = NO;
    
    for (TuSDKFilterArg *arg in args) {
        NSString *parameterName = arg.key;
        // NSLog(@"调节的滤镜参数名称 parameterName: %@",parameterName)
        // 应用保存的参数默认值、最大值
        NSDictionary *savedDefaultDic = _filterParameterDefaultDic[parameterName];
        if (savedDefaultDic) {
            if (savedDefaultDic[kFilterParameterDefaultKey])
                arg.defaultValue = [savedDefaultDic[kFilterParameterDefaultKey] doubleValue];
            
            if (savedDefaultDic[kFilterParameterMaxKey])
                arg.maxFloatValue = [savedDefaultDic[kFilterParameterMaxKey] doubleValue];
            
            // 把当前值重置为默认值
            [arg reset];
            needSubmitParameter = YES;
            continue;
        }
        
        // 是否需要更新参数值
        BOOL updateValue = NO;
        // 默认值的百分比，用于指定滤镜初始的效果（参数默认值 = 最小值 + (最大值 - 最小值) * defaultValueFactor）
        CGFloat defaultValueFactor = 1;
        // 最大值的百分比，用于限制滤镜参数变化的幅度（参数最大值 = 最小值 + (最大值 - 最小值) * maxValueFactor）
        CGFloat maxValueFactor = 1;
        if ([parameterName isEqualToString:@"eyeSize"]) {
            // 大眼
            defaultValueFactor = 0.3;
            maxValueFactor = 0.85;
            updateValue = YES;
        } else if ([parameterName isEqualToString:@"chinSize"]) {
            // 瘦脸
            defaultValueFactor = 0.2;
            maxValueFactor = 0.7;
            updateValue = YES;
        } else if ([parameterName isEqualToString:@"noseSize"]) {
            // 瘦鼻
            defaultValueFactor = 0.2;
            maxValueFactor = 0.6;
            updateValue = YES;
        } else if ([parameterName isEqualToString:@"mouthWidth"]) {
            // 嘴型
        } else if ([parameterName isEqualToString:@"archEyebrow"]) {
            // 细眉
        } else if ([parameterName isEqualToString:@"jawSize"]) {
            // 下巴
        } else if ([parameterName isEqualToString:@"eyeAngle"]) {
            // 眼角
        } else if ([parameterName isEqualToString:@"eyeDis"]) {
            // 眼距
        } else if ([parameterName isEqualToString:@"smoothing"]) {
            // 润滑
            maxValueFactor = 0.7;
            defaultValueFactor = 0.7;
            updateValue = YES;
        } else if ([parameterName isEqualToString:@"whitening"]) {
            // 白皙
            maxValueFactor = 0.7;
            defaultValueFactor = 0.6;
            updateValue = YES;
        }
        if (updateValue) {
            if (defaultValueFactor != 1)
                arg.defaultValue = arg.minFloatValue + (arg.maxFloatValue - arg.minFloatValue) * defaultValueFactor * maxValueFactor;
            
            if (maxValueFactor != 1)
                arg.maxFloatValue = arg.minFloatValue + (arg.maxFloatValue - arg.minFloatValue) * maxValueFactor;
            // 把当前值重置为默认值
            [arg reset];
            
            // 存储值
            _filterParameterDefaultDic[parameterName] = @{kFilterParameterDefaultKey: @(arg.defaultValue), kFilterParameterMaxKey: @(arg.maxFloatValue)};
            needSubmitParameter = YES;
        }
    }
    
    // 应用保存的美颜参数
    if (!isComicsFilterCode(filter.code) && _beautyFilterParameters.count) {
        for (TuSDKFilterArg *arg in args) {
            for (NSString *key in _beautyFilterParameters.allKeys) {
                if ([arg.key isEqualToString:key])
                    arg.precent = [_beautyFilterParameters[key] doubleValue];
            }
        }
        // 提交修改结果
        [filter submitParameter];
        needSubmitParameter = NO;
    }    
    // 提交修改结果
    if (needSubmitParameter)
        [filter submitParameter];
}

#pragma mark - 销毁操作

/**
 销毁相机对象
 */
- (void)destroyCamera {
    if (_camera) {
        // 取消录制状态
        [_camera cancelRecording];
        // 销毁并置空相机
        [_camera destory];
        _camera = nil;
    }
}

- (void)dealloc {
    [self destroyCamera];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s", __FUNCTION__);
}

@end


#pragma mark - 界面事件回调

@implementation CameraViewController (UIDelegate)

#pragma mark - CameraControlMaskViewDelegate

/**
 滤镜，美颜栏点击回调

 @param controlMask 相机界面遮罩视图
 @param filterPanel 滤镜回调事件
 */
- (void)controlMask:(CameraControlMaskView *)controlMask didShowFilterPanel:(id<CameraFilterPanelProtocol>)filterPanel {
    if ([filterPanel isKindOfClass:[CameraFilterPanelView class]]) {
        CameraFilterPanelView *filterPanelView = (CameraFilterPanelView *)filterPanel;
        _filterCodes = filterPanelView.selectedTabIndex == 0 ? kComicsFilterCodes : kNormalFilterCodes;
    }
    
    NSString *filterCode = _currentFilter.code;
    if (filterPanel == _controlMaskView.beautyPanelView && isComicsFilterCode(filterCode)) {
        [_camera switchFilterWithCode:_defaultFilterCode];
        return;
    }
    controlMask.filterPanelView.selectedFilterCode = filterCode;
    [filterPanel reloadFilterParamters];
}

#pragma mark - RecordMoreMenuViewDelegate

/**
 更多菜单切换预览画面比率回调
 
 @param moreMenu 更多菜单视图
 @param ratio 相机视图比例
 */
- (void)moreMenu:(CameraMoreMenuView *)moreMenu didSelectedRatio:(CGFloat)ratio {
    // 相机预览画面区域显示算法
    CGFloat percentOffset = 0;
    if (ratio == 1.0 || ratio == 3.0/4) {
        if (ratio == 1.0) percentOffset = kTopBarHeight / self.view.lsqGetSizeHeight;
        if (@available(iOS 11.0, *)) {
            CGFloat topOffset = self.view.safeAreaInsets.top;
            if (topOffset > 0) percentOffset = (kTopBarHeight + topOffset) / self.view.lsqGetSizeHeight;
        }
    }
    _camera.regionHandler.offsetPercentTop = percentOffset;
    // 更新画面比率
    [_camera changeCameraViewRatio:ratio];
}

/**
 更多菜单切换自动聚焦回调
 
 @param moreMenu 更多菜单视图
 @param autoFocus 自动聚焦
 */
- (void)moreMenu:(CameraMoreMenuView *)moreMenu didSwitchAutoFocus:(BOOL)autoFocus {
    _camera.disableContinueFoucs = !autoFocus;
}

/**
 更多菜单切换闪光灯回调
 
 @param moreMenu 更多菜单视图
 @param enableFlash 闪光灯开启状态
 */
- (void)moreMenu:(CameraMoreMenuView *)moreMenu didSwitchFlashMode:(BOOL)enableFlash {
    [_camera flashWithMode:enableFlash ? AVCaptureFlashModeOn : AVCaptureFlashModeOff];
}

/**
 更多菜单切换变声回调
 
 @param moreMenu 更多菜单视图
 @param pitchType 变声类型
 */
- (void)moreMenu:(CameraMoreMenuView *)moreMenu didSwitchPitchType:(lsqSoundPitch)pitchType {
    _camera.soundPitch = pitchType;
}

#pragma mark - CameraFilterPanelDataSource

/**
 滤镜参数个数

 @return 滤镜参数数量
 */
- (NSInteger)numberOfParamter {
    return _currentFilter.filterParameter.count;
}

/**
 滤镜参数名称

 @param index 滤镜索引
 @return 参数名称
 */
- (NSString *)paramterNameAtIndex:(NSUInteger)index {
    return _currentFilter.filterParameter.args[index].key;
}

/**
 滤镜参数值

 @param index 滤镜参数索引
 @return 滤镜参数百分比
 */
- (double)percentValueAtIndex:(NSUInteger)index {
    TuSDKFilterArg *arg = _currentFilter.filterParameter.args[index];
    double percentValue = arg.precent;
    if (percentValue == 0) percentValue = 0;
    
    return percentValue;
}

#pragma mark - RecordFilterPanelDelegate

/**
 滤镜面板切换标签回调
 
 @param filterPanel 滤镜面板
 @param tabIndex 标签索引
 */
- (void)filterPanel:(id<CameraFilterPanelProtocol>)filterPanel didSwitchTabIndex:(NSInteger)tabIndex {
    if ([filterPanel isKindOfClass:[CameraFilterPanelView class]]) {
        _filterCodes = tabIndex == 0 ? kComicsFilterCodes : kNormalFilterCodes;
    }
}

/**
 滤镜面板选中回调

 @param filterPanel 滤镜面板
 @param code 滤镜码
 */
- (void)filterPanel:(id<CameraFilterPanelProtocol>)filterPanel didSelectedFilterCode:(NSString *)code {
    // 通过滤镜码切换滤镜
    [_camera switchFilterWithCode:code];
}

/**
 滤镜面板值变更回调

 @param filterPanel 滤镜面板
 @param percentValue 滤镜参数变更数值
 @param index 滤镜参数索引
 */
- (void)filterPanel:(id<CameraFilterPanelProtocol>)filterPanel didChangeValue:(double)percentValue paramterIndex:(NSUInteger)index {
    // 设置当前滤镜的参数，并 `-submitParameter` 提交参数让其生效
    TuSDKFilterArg *arg = _currentFilter.filterParameter.args[index];
    arg.precent = percentValue;
    [_currentFilter submitParameter];
    
    // 保存美颜参数
    if (filterPanel == _controlMaskView.beautyPanelView) {
        _beautyFilterParameters[_currentFilter.filterParameter.args[index].key] = @(percentValue);
    }
}

/**
 重置滤镜参数回调

 @param filterPanel 滤镜面板
 @param paramterKeys 滤镜参数
 */
- (void)filterPanel:(id<CameraFilterPanelProtocol>)filterPanel resetParamterKeys:(NSArray *)paramterKeys {
    void (^resetBlock)(void) = ^{
        for (NSString *parameterName in paramterKeys) {
            for (TuSDKFilterArg *arg in self.currentFilter.filterParameter.args) {
                if (![parameterName isEqualToString:arg.key]) continue;
                
                [arg reset];
            }
        }
        [self.currentFilter submitParameter];
    };
    
    if (filterPanel == _controlMaskView.beautyPanelView && _controlMaskView.beautyPanelView.selectedIndex == 1) {
        // 微整形
        NSString *title = NSLocalizedStringFromTable(@"tu_微整形", @"VideoDemo", @"微整形");
        NSString *message = NSLocalizedStringFromTable(@"tu_将所有参数恢复默认吗？", @"VideoDemo", @"将所有参数恢复默认吗？");
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"tu_取消", @"VideoDemo", @"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"tu_确定", @"VideoDemo", @"确定") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            resetBlock();
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        resetBlock();
    }
}

#pragma mark StickerPanelViewDelegate

/**
 贴纸选中回调

 @param stickerPanel 相机贴纸协议
 @param sticker 贴纸组
 */
- (void)stickerPanel:(StickerPanelView *)stickerPanel didSelectSticker:(TuSDKPFStickerGroup *)sticker {
    if (!sticker) {
        // 为nil时 移除已有贴纸组
        [_camera removeAllLiveSticker];
        return;
    }
    // 是否正在使用
    if (![_camera isGroupStickerUsed:sticker]) {
        // 展示对应贴纸组
        [_camera showGroupSticker:sticker];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 当美颜面板出现时则禁用左滑、右滑手势
    if (_controlMaskView.beautyPanelView.display) return NO;
    return YES;
}

@end


#pragma mark - TuSDKVideoCameraDelegate

@implementation CameraViewController (State)

/**
 相机状态 (如需操作UI线程， 请检查当前线程是否为主线程)

 @param camera 录制相机
 @param state 相机运行状态
 */
- (void)onVideoCamera:(id<TuSDKVideoCameraInterface>)camera stateChanged:(lsqCameraState)state {
    switch (state) {
        case lsqCameraStateStarting:
            // 相机正在启动
            NSLog(@"TuSDKRecordVideoCamera state: 相机正在启动");
            break;
        case lsqCameraStatePaused:
            // 相机录制暂停
            NSLog(@"TuSDKRecordVideoCamera state: 相机录制暂停");
            break;
        case lsqCameraStateStarted:
            // 相机启动完成
            NSLog(@"TuSDKRecordVideoCamera state: 相机启动完成");
            break;
        case lsqCameraStateCapturing:
            // 相机正在拍摄
            NSLog(@"TuSDKRecordVideoCamera state: 相机正在拍摄");
            break;
        case lsqCameraStateUnknow:
            // 相机状态未知
            NSLog(@"TuSDKRecordVideoCamera state: 相机状态未知");
            break;
        case lsqCameraStateCaptured:
            // 相机拍摄完成
            NSLog(@"TuSDKRecordVideoCamera state: 相机拍摄完成");
            break;
        default:
            break;
    }
}

/**
 相机滤镜改变 (如需操作UI线程， 请检查当前线程是否为主线程)

 @param camera 录制相机
 @param newFilter 新的滤镜对象
 */
- (void)onVideoCamera:(id<TuSDKVideoCameraInterface>)camera filterChanged:(TuSDKFilterWrap *)newFilter {
    // 在该滤镜变更回调中，更像滤镜属性，以方便在参数面板中配置参数
    self.currentFilter = newFilter;
}

@end


#pragma mark - TuSDKRecordVideoCameraDelegate

@implementation CameraViewController (Record)

/**
 录制结果回调

 @param camerea 录制相机
 @param result 录制结果
 */
- (void)onVideoCamera:(TuSDKRecordVideoCamera *)camerea result:(TuSDKVideoResult *)result {
    // 通过相机初始化设置  _camera.saveToAlbum = NO;  result.videoPath 拿到视频的临时文件路径
    
    if (result.videoPath) {
        // 进行自定义操作，例如保存到相册
        UISaveVideoAtPathToSavedPhotosAlbum(result.videoPath, nil, nil, nil);
        [[TuSDK shared].messageHub showSuccess:NSLocalizedStringFromTable(@"tu_保存成功", @"VideoDemo", @"保存成功")];
        
        // 如需相机跳转时间裁剪进入编辑需要进行 input 赋值
        // MovieCutViewController.inputAssets，NSArray<AVAsset *> *inputAssets;为不可变数组类型
        // 需要将文件处理后的 videoAsset 对象加入到数组中
        // NSURL *videoPathURL = [NSURL fileURLWithPath:result.videoPath];
        // AVAsset *videoAsset = [AVAsset assetWithURL:videoPathURL];
        // array add object
        // 跳转代码
        // MovieCutViewController *cutter = [[MovieCutViewController alloc] initWithNibName:nil bundle:nil];
        // input 赋值
        // cutter.inputAssets = assets;
    } else {
        [[TuSDK shared].messageHub showSuccess:NSLocalizedStringFromTable(@"tu_保存成功", @"VideoDemo", @"保存成功")];
    }
    NSLog(@"保存完成，result: %@", result);
    
    // 自动保存后设置为 恢复进度条状态
    [_captureMode resetUI];
}

/**
 进度条改变

 @param camerea 录制相机
 @param progress 进度条百分比
 @param durationTime 录制时长
 */
-(void)onVideoCamera:(TuSDKRecordVideoCamera *)camerea recordProgressChanged:(CGFloat)progress durationTime:(CGFloat)durationTime {
    // 更新进度条 UI 信息
    if ([self.captureMode respondsToSelector:@selector(recordProgressDidChange:)]) {
        [self.captureMode recordProgressDidChange:progress];
    }
}

/**
 录制状态

 @param camerea 录制相机
 @param state 相机录制操作状态
 */
- (void)onVideoCamera:(TuSDKRecordVideoCamera *)camerea recordStateChanged:(lsqRecordState)state {
    if ([_captureMode respondsToSelector:@selector(recordStateDidChange:)]) {
        [_captureMode recordStateDidChange:state];
    }
    switch (state) {
        case lsqRecordStateRecordingCompleted:
            // 录制完成
            NSLog(@"TuSDKRecordVideoCamera record state: 录制完成");
            [[TuSDK shared].messageHub showSuccess:NSLocalizedStringFromTable(@"tu_完成录制", @"VideoDemo", @"完成录制")];
            break;
        case lsqRecordStateRecording:
            // 正在录制
            NSLog(@"TuSDKRecordVideoCamera record state: 正在录制");
            break;
        case lsqRecordStatePaused:
            // 暂停录制
            NSLog(@"TuSDKRecordVideoCamera record state: 暂停录制");
            break;
        case lsqRecordStateMerging:
            // 正在合成视频
            NSLog(@"TuSDKRecordVideoCamera record state: 正在合成");
            [[TuSDK shared].messageHub setStatus:NSLocalizedStringFromTable(@"tu_正在合成...", @"VideoDemo", @"正在合成...")];
            break;
        case lsqRecordStateCanceled:
            // 取消录制 同时 重置UI
            [_captureMode resetUI];
            break;
        case lsqRecordStateSaveing:
            // 正在保存
            NSLog(@"TuSDKRecordVideoCamera record state: 正在保存");
            [[TuSDK shared].messageHub setStatus:NSLocalizedStringFromTable(@"tu_正在保存...", @"VideoDemo", @"正在保存...")];
            break;
        default:
            break;
    }
}

/**
 录制错误信息

 @param camerea 录制相机
 @param error 错误信息
 */
- (void)onVideoCamera:(TuSDKRecordVideoCamera *)camerea failedWithError:(NSError*)error {
    switch (error.code) {
        case lsqRecordVideoErrorUnknow:
            [[TuSDK shared].messageHub showError:NSLocalizedStringFromTable(@"tu_录制失败：未知原因失败", @"VideoDemo", @"录制失败：未知原因失败")];
            break;
        case lsqRecordVideoErrorSaveFailed:
            // 取消录制 同时 重置UI
            [_captureMode resetUI];
            [[TuSDK shared].messageHub showError:NSLocalizedStringFromTable(@"tu_录制失败", @"VideoDemo", @"录制失败")];
            break;
        case lsqRecordVideoErrorLessMinDuration:
            [[TuSDK shared].messageHub showError:NSLocalizedStringFromTable(@"tu_不能低于最小时间", @"VideoDemo", @"不能低于最小时间")];
            break;
        case lsqRecordVideoErrorMoreMaxDuration:
            [_controlMaskView showViewsWhenPauseRecording];
            [[TuSDK shared].messageHub showError:NSLocalizedStringFromTable(@"tu_大于最大时长，请保存视频后继续录制", @"VideoDemo", @"大于最大时长，请保存视频后继续录制")];
            break;
        case lsqRecordVideoErrorNotEnoughSpace:
            [[TuSDK shared].messageHub showError:NSLocalizedStringFromTable(@"tu_手机可用空间不足，请清理手机", @"VideoDemo", @"手机可用空间不足，请清理手机")];
            break;
        default:
            break;
    }
}

@end

#pragma mark - TuSDKVideoCameraDelegate

@implementation CameraViewController (Capture)

/**
 获取拍摄图片 (如需操作UI线程， 请检查当前线程是否为主线程)

 @param camera 相机对象
 @param result 获取的结果
 @param error 错误信息
 */
- (void)onVideoCamera:(id<TuSDKVideoCameraInterface>)camera takedResult:(TuSDKResult *)result error:(NSError *)error {
    if (result.image) {
        NSLog(@"result.image: %@",result.image);
        // 进行自定义操作，例如保存到相册
        // UIImageWriteToSavedPhotosAlbum(result.image, NULL, NULL, NULL);
    }
}

@end
