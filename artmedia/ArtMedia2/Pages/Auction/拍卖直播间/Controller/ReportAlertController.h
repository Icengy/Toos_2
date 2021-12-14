//
//  ReportAlertController.h
//  ArtMedia2
//
//  Created by LY on 2020/12/2.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReportAlertController : UIViewController
- (void)showAlertWithController:(UIViewController *)controller sureClickBlock:(void(^)(void))sureClickBlock;
@end

NS_ASSUME_NONNULL_END
