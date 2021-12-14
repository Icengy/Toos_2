//
//  MyInviterItemFilledView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InviteInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface MyInviterItemFilledView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;

@property (nonatomic ,strong ,nullable) InviteInfoModel *filledModel;
@end

NS_ASSUME_NONNULL_END
