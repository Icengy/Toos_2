//
//  ArtworkListCell.h
//  ArtMedia2
//
//  Created by LY on 2020/12/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtWorkListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ArtworkListCell : UITableViewCell
@property (nonatomic , strong) ArtWorkListModel *model;
@end

NS_ASSUME_NONNULL_END
