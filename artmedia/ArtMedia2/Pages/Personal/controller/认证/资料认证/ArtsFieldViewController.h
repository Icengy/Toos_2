//
//  ArtsFieldViewController.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/24.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"

@class ArtsFieldModel;
NS_ASSUME_NONNULL_BEGIN

@protocol ArtsFieldViewControllerDelegate <NSObject>

@optional
- (void)viewController:(BaseViewController *)viewController didSelectedArtField:(ArtsFieldModel *)fieldModel;

@end

@interface ArtsFieldViewController : BaseViewController

@property (weak, nonatomic) id <ArtsFieldViewControllerDelegate> delegate;

@property (nonatomic ,strong) ArtsFieldModel *fieldModel;

@end

NS_ASSUME_NONNULL_END
