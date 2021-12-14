//
//  PersonMenuBackCell.h
//  ArtMedia2
//
//  Created by LY on 2020/10/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonMenuBackCell;
NS_ASSUME_NONNULL_BEGIN
@protocol PersonMenuBackCellDelegate <NSObject>

- (void)PersonMenuBackCellCollectionDidSelect:(PersonMenuBackCell *)cell collectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end
@interface PersonMenuBackCell : UITableViewCell

@property (weak, nonatomic) id<PersonMenuBackCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
