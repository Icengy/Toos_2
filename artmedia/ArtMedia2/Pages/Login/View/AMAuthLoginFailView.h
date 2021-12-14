//
//  AMAuthLoginFailView.h
//  ArtMedia2
//
//  Created by 美术拍卖 on 2020/12/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AMAuthLoginFailViewBlock)(void);

@interface AMAuthLoginFailView : UIView

@property (weak, nonatomic) IBOutlet AMLoginStyleView *loginStyleV;
@property (nonatomic, strong) AMAuthLoginFailViewBlock btnBlock;

@end

NS_ASSUME_NONNULL_END
