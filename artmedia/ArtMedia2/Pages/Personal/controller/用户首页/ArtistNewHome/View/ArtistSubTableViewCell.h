//
//  ArtistSubTableViewCell.h
//  ArtMedia2
//
//  Created by 刘洋 on 2020/9/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMSegment.h"
NS_ASSUME_NONNULL_BEGIN

@interface ArtistSubTableViewCell : UITableViewCell
@property (nonatomic ,strong) UIView *contentCarrier;
@property (nonatomic , strong) NSMutableArray *titleArray;

@end

NS_ASSUME_NONNULL_END
