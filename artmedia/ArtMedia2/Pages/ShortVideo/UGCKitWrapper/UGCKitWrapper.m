//
//  UGCKitWrapper.m
//  XiaoShiPin
//
//  Created by cui on 2019/11/27.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "UGCKitWrapper.h"

#import "MainNavigationController.h"
#import "MainTabBarController.h"

#import "TCConstants.h"
#import "MBProgressHUD.h"
#import "PhotoUtil.h"

@import TXLiteAVSDK_Professional;

typedef NS_ENUM(NSInteger, TCVideoAction) {
    TCVideoActionNone,
    TCVideoActionSave,
    TCVideoActionPublish
};

@interface UGCKitWrapper () <TXVideoPublishListener> {
    __weak UIViewController *_viewController;
    UGCKitTheme   *_theme;
    TCVideoAction  _actionAfterSave;
    MBProgressHUD *_videoPublishHUD;
    TXUGCPublish  *_videoPublish;
    NSString      *_videoPublishPath;
}
@end

@implementation UGCKitWrapper
- (instancetype)initWithViewController:(UIViewController *)viewController theme:(UGCKitTheme *)theme
{
    if (self = [super init]) {
        _viewController = viewController;
        _theme = theme;
//        _videoPublish = [[TXUGCPublish alloc] initWithUserID:[[TCUserInfoModel sharedInstance] getUserProfile].identifier];
        _videoPublish = [[TXUGCPublish alloc] init];
        _videoPublish.delegate = self;
    }
    return self;
}

#pragma mark - View Controller Navigation
- (void)showRecordViewControllerWithConfig:(UGCKitRecordConfig *)config  {
    UGCKitRecordViewController *videoRecord = [[UGCKitRecordViewController alloc] initWithConfig:config theme:_theme];
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:videoRecord];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    __weak MainNavigationController *weakNav = nav;
    __weak __typeof(self) wself = self;
    videoRecord.completion = ^(UGCKitResult *result) {
        if (result.code == 0 && !result.cancelled) {
            [wself showEditViewController:result rotation:TCEditRotation0 inNavigationController:weakNav backMode:TCBackModePop];
        } else {
            [_viewController dismissViewControllerAnimated:YES completion:nil];
        }
    };
    [_viewController presentViewController:nav animated:YES completion:nil];
}

- (void)showEditFinishOptionsWithResult:(UGCKitResult *)result
                         editController:(UGCKitEditViewController *)editViewController
                           finishBloack:(void(^)(BOOL))finish {
    if (!self) return;
    _actionAfterSave = TCVideoActionPublish;
    finish(YES);
//    return;
//    __weak __typeof(self) wself = self;
//    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil
//                                                                        message:nil
//                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
//    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Common.Save", nil)
//                                                   style:UIAlertActionStyleDefault
//                                                 handler:^(UIAlertAction * _Nonnull action) {
//        __strong __typeof(wself) self = wself; if (!self) return;
//        self->_actionAfterSave = TCVideoActionSave;
//        finish(YES);
//    }]];
//    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Common.Release", nil)
//                                                   style:UIAlertActionStyleDefault
//                                                 handler:^(UIAlertAction * _Nonnull action) {
//        __strong __typeof(wself) self = wself; if (!self) return;
//        self->_actionAfterSave = TCVideoActionPublish;
//        finish(YES);
//    }]];
//    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Common.Cancel", nil)
//                                                   style:UIAlertActionStyleCancel
//                                                 handler:^(UIAlertAction * _Nonnull action) {
//        finish(NO);
//    }]];
//    [editViewController presentViewController:controller animated:YES completion:nil];
}


- (void)showEditViewController:(UGCKitResult *)result
                      rotation:(TCEditRotation)rotation
        inNavigationController:(UINavigationController *)nav
                      backMode:(TCBackMode)backMode {
    UGCKitMedia *media = result.media;
    UGCKitEditConfig *config = [[UGCKitEditConfig alloc] init];
    config.rotation = (TCEditRotation)(rotation / 90);

//    UIImage *tailWatermarkImage = [UIImage imageNamed:@"tcloud_logo"];
//    TXVideoInfo *info = [TXVideoInfoReader getVideoInfoWithAsset:media.videoAsset];
//    float w = 0.15;
//    float x = (1.0 - w) / 2.0;
//    float width = w * info.width;
//    float height = width * tailWatermarkImage.size.height / tailWatermarkImage.size.width;
//    float y = (info.height - height) / 2 / info.height;
//    config.tailWatermark = [UGCKitWatermark watermarkWithImage:tailWatermarkImage
//                                                     frame:CGRectMake(x, y, w, 0)
//                                                  duration:2];
    config.tailWatermark = nil;
    __weak __typeof(self) wself = self;
    UGCKitEditViewController *vc = [[UGCKitEditViewController alloc] initWithMedia:media
                                                                            config:config
                                                                             theme:_theme];
    __weak UGCKitEditViewController *weakEditController = vc;
    __weak UINavigationController *weakNavigation = nav;
    vc.onTapNextButton = ^(void (^finish)(BOOL)) {
        [wself showEditFinishOptionsWithResult:result editController:weakEditController finishBloack:finish];
    };
//    vc.completionCustom = ^(UGCKitResult *result) {
//        [wself dealVideoCover:result];
//    };
    vc.onTapFinishButton = ^(AMVideoEditer *videoEdit) {
        if (wself.delegate && [wself.delegate respondsToSelector:@selector(wrapper:onPublishWith:)]) {
            [wself.delegate wrapper:wself onPublishWith:videoEdit];
        }
    };

    vc.completion = ^(UGCKitResult *result) {
        __strong __typeof(wself) self = wself; if (self == nil) { return; }
        if (result.cancelled) {
            if (backMode == TCBackModePop)  {
                [weakNavigation popViewControllerAnimated:YES];
            } else {
                [self->_viewController dismissViewControllerAnimated:YES completion:nil];
            }
        } else {
            switch(self->_actionAfterSave) {
                case TCVideoActionSave:
                    [self _saveVideoWithResult:result editController:weakEditController];
                    break;
                case TCVideoActionPublish:
                    [self _publishVideoWithResult:result editController:weakEditController];
                    break;
                default:
                    break;
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:CACHE_PATH_LIST];
//        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [nav pushViewController:vc animated:YES];
}

#pragma mark - Video Publishing
- (void)_publishVideoWithResult:(UGCKitResult *)result editController:(UGCKitEditViewController *)editController {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:editController.view];
    if (hud == nil) {
        hud = [MBProgressHUD showHUDAddedTo:editController.view animated:YES];
    }
    _videoPublishHUD = hud;
    hud.label.text = @"视频上传中";
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    [hud showAnimated:YES];
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader getUploadSignature] needHUD:NO params:nil success:^(NSInteger code, id  _Nullable response) {
        NSString *signature = (NSString *)response[@"data"];
        if ([ToolUtil isEqualToNonNull:signature] && _videoPublish) {
            TXVideoInfo *videoInfo = [TXVideoInfoReader getVideoInfo:result.media.videoPath];
            TXPublishParam *publishParam = [[TXPublishParam alloc] init];
            publishParam.signature  = signature;
            publishParam.coverPath = [self _getCoverPath:videoInfo.coverImage];
            publishParam.videoPath  = result.media.videoPath;
            [_videoPublish publishVideo:publishParam];
        }
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        if (errorCode > 400) {
            NSString *message = [NSString stringWithFormat:@"错误码：%ld 错误信息：%@",(long)errorCode, errorMsg];
            [self showAlert:NSLocalizedString(@"视频上传失败", nil) message:message];
        }else {
            [MBProgressHUD hideHUDForView:_viewController.view animated:YES];
            [SVProgressHUD showError:showNetworkError];
        }
    }];
//    [[TCLoginModel sharedInstance] getVodSign:^(int errCode, NSString *msg, NSDictionary *resultDict) {
//        [TCUtil report:xiaoshipin_videosign userName:nil code:errCode msg:msg];
//        if (errCode == 200 && resultDict){
//            NSString *signature = resultDict[@"signature"];
//            if (signature && signature.length > 0 && _videoPublish) {
//                TXVideoInfo *videoInfo = [TXVideoInfoReader getVideoInfoWithAsset:result.media.videoAsset];
//                TXPublishParam *publishParam = [[TXPublishParam alloc] init];
//                publishParam.signature  = signature;
//                publishParam.coverPath = [self _getCoverPath:videoInfo.coverImage];
//                publishParam.videoPath  = result.media.videoPath;
//                [_videoPublish publishVideo:publishParam];
//            }
//        }else{
//            [MBProgressHUD hideHUDForView:_viewController.view animated:YES];
//            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Common.HintErrorCodeMessage", nil),(long)errCode,msg];
//            [self showAlert:NSLocalizedString(@"TCVideoEditView.VideoUploadingFailed", nil) message:message];
//        }
//    }];
}

-(NSString *)_getCoverPath:(UIImage *)coverImage
{
    UIImage *image = coverImage;
    if (image == nil) {
        return nil;
    }

    NSString *coverPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"TXUGC"];
    coverPath = [coverPath stringByAppendingPathComponent:[self _getFileNameByTimeNow:@"TXUGC" fileType:@"jpg"]];
    if (coverPath) {
        // 保证目录存在
        [[NSFileManager defaultManager] createDirectoryAtPath:[coverPath stringByDeletingLastPathComponent]
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];

        [UIImageJPEGRepresentation(image, 1.0) writeToFile:coverPath atomically:YES];
    }
    return coverPath;
}

-(NSString *)_getFileNameByTimeNow:(NSString *)type fileType:(NSString *)fileType {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd_HHmmss"];
    NSDate * NowDate = [NSDate dateWithTimeIntervalSince1970:now];
    ;
    NSString * timeStr = [formatter stringFromDate:NowDate];
    NSString *fileName = ((fileType == nil) ||
                          (fileType.length == 0)
                          ) ? [NSString stringWithFormat:@"%@_%@",type,timeStr] : [NSString stringWithFormat:@"%@_%@.%@",type,timeStr,fileType];
    return fileName;
}

- (void)_saveVideoWithResult:(UGCKitResult *)result editController:(UGCKitEditViewController *)editController {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:editController.view];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:editController.view animated:YES];
    }
    hud.label.text = NSLocalizedString(@"UGCKit.Edit.VideoEffect.VideoSaving", nil);
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES];
    [PhotoUtil saveAssetToAlbum:[NSURL fileURLWithPath: result.media.videoPath]
                     completion:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *message = nil;
            if (success) {
                message = NSLocalizedString(@"UGCKit.Edit.VideoEffect.VideoSavingSucceeded", nil);
            } else {
                message = NSLocalizedString(@"UGCKit.Edit.VideoEffect.VideoSavingFailed", nil);
            }
            hud.label.text = message;
            hud.mode = MBProgressHUDModeText;
            [hud hideAnimated:YES afterDelay:1];
            if (success) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_viewController dismissViewControllerAnimated:YES completion:nil];
                });
            }
        });
    }];
}


#pragma mark TXVideoPublishListener
-(void)onPublishProgress:(uint64_t)uploadBytes totalBytes: (uint64_t)totalBytes
{
    _videoPublishHUD.progress = (float)uploadBytes / totalBytes;
}

-(void)onPublishComplete:(TXPublishResult*)result
{
    NSLog(@"onPublishComplete = %@",[result yy_modelToJSONObject]);
    MBProgressHUD *hud = _videoPublishHUD;
    if (result.retCode != 0) {
        [hud hideAnimated:YES];
        [self showAlert:@"视频上传失败" message:result.descMsg];
    }else {
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"上传成功了！";
        [hud hideAnimated:YES afterDelay:0.3];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(wrapper:onPublishComplete:)]) {
            [self.delegate wrapper:self onPublishComplete:result];
        }
    }
}

#pragma mark - Alerting
- (UIAlertController *)_alertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Common.GotIt", nil)
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    return alertController;
}
- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [self _alertWithTitle:title message:message];
    [_viewController presentViewController:alertController animated:YES completion:nil];
}


@end
