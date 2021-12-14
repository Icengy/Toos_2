//
//  ECoinRecordDetailNormalCell.h
//  ArtMedia2
//
//  Created by LY on 2020/10/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECoinRecordDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ECoinRecordDetailNormalCell : UITableViewCell
@property (nonatomic , strong) ECoinRecordDetailModel *model;
@property (nonatomic , strong) NSIndexPath *indexPath;
@end

NS_ASSUME_NONNULL_END
