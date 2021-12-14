//
//  JoinClassResultViewVontroller.h
//  ArtMedia2
//
//  Created by LY on 2020/10/26.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECoinModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JoinClassResultViewVontroller : UIViewController
- (void)showWithController:(UIViewController *)controller title:(NSString *)title ecoinBalance:(NSString *)ecoinBalance sureButtonTitle:(NSString *)sureButtonTitle completionBlock:(void(^)(void))completionBlock;
@end

NS_ASSUME_NONNULL_END
