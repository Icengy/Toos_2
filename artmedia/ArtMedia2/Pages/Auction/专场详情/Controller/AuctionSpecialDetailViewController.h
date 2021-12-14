//
//  AuctionSpecialDetailViewController.h
//  ArtMedia2
//
//  Created by LY on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseViewController.h"
#import "AuctionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AuctionSpecialDetailViewController : BaseViewController
/// 拍场ID
@property (nonatomic , copy) NSString *auctionFieldId;
@end

NS_ASSUME_NONNULL_END
