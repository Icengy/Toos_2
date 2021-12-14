//
//  ClassDetailArtistCell.h
//  ArtMedia2
//
//  Created by LY on 2020/10/20.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMCourseModel.h"
#import "CustomPersonalModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ClassDetailArtistCell : UITableViewCell
@property (nonatomic , strong) AMCourseModel *model;
@property (nonatomic , strong) CustomPersonalModel *userModel;
@property (nonatomic , copy) void(^focusClickBlock)(NSString *artistID);
@property (nonatomic , copy) void(^gotoArtistHomeBlock)(void);
@end

NS_ASSUME_NONNULL_END
