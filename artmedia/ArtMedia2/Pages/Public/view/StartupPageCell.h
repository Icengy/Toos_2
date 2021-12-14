//
//  StartupPageCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/2/26.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StartupPageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *showIV;
@property (weak, nonatomic) IBOutlet AMButton *showBtn;
@property(nonatomic,copy) void(^clickToTouchBlock)(BOOL isLeft);
@end

NS_ASSUME_NONNULL_END
