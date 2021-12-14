//
//  AMNewArtistReceptionSubViewController.h
//  ArtMedia2
//
//  Created by 刘洋 on 2020/9/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseItemViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AMNewArtistReceptionSubViewController : BaseItemViewController

@property (nonatomic , copy) NSString *artistID;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
