//
//  AMNewArtistCourseViewController.h
//  ArtMedia2
//
//  Created by LY on 2020/11/26.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseItemViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AMNewArtistCourseViewController : BaseItemViewController

@property (nonatomic , copy) NSString *artistID;

- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
