//
//  AMCertificateBtnCollectionCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/9/14.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMCertificateBtnCollectionCell;
NS_ASSUME_NONNULL_BEGIN

@protocol AMCertificateBtnCollectionCellDelegate <NSObject>

@required
- (void)btnCell:(AMCertificateBtnCollectionCell *)btnCell didSelectedForDownload:(id)sender;
- (void)btnCell:(AMCertificateBtnCollectionCell *)btnCell didSelectedForShare:(id)sender;

@end

@interface AMCertificateBtnCollectionCell : UICollectionViewCell

@property (weak, nonatomic) id <AMCertificateBtnCollectionCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
