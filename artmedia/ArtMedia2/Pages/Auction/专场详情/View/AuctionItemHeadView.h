//
//  AuctionItemHeadView.h
//  ArtMedia2
//
//  Created by LY on 2020/11/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BaseView.h"
#import "AuctionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AuctionItemHeadView : BaseView


@property (nonatomic , copy) void(^clickToGoAnyDetail)(BOOL isNum, NSString * _Nullable inputString);
- (void)setup:(NSString *)totalAmount nameTextF:(NSString *)nameTextFStr;

@end

NS_ASSUME_NONNULL_END
