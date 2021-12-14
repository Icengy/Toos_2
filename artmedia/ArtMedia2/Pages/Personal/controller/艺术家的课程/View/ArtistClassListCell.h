//
//  ArtistClassListCell.h
//  ArtMedia2
//
//  Created by LY on 2020/10/22.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMCourseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ArtistClassListCell : UITableViewCell
@property (nonatomic , strong) AMCourseModel *model;
@property (nonatomic , copy) void(^editClassBlock)(AMCourseModel *model , NSString *buttonTitle);
@end

NS_ASSUME_NONNULL_END
