//
//  PersonalEditListHeaderView.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/30.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonalEditListHeaderView : UIView

@property(nonatomic,strong)void(^showGoodsSwitchBlock)(BOOL show);
///status--1：全部、2：待审核、3：已审核
@property(nonatomic,strong)void(^selectedVideoStatusBlock)(NSInteger status);

- (void)updateToolBar;

@end

NS_ASSUME_NONNULL_END
