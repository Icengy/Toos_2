//
//  AMAuctionGoodsPartWebTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/11/27.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMAuctionGoodsPartWebTableCell;
NS_ASSUME_NONNULL_BEGIN

@protocol AMAuctionGoodsPartWebDelegate <NSObject>

@optional
- (void)webCell:(AMAuctionGoodsPartWebTableCell *)webCell didFinishLoadWithScrollHeight:(CGFloat)scrollHeight;

@end

@interface AMAuctionGoodsPartWebTableCell : UITableViewCell

@property (nonatomic ,weak) id <AMAuctionGoodsPartWebDelegate> delegate;
@property (nonatomic ,copy) NSString *webUrl;

@end

NS_ASSUME_NONNULL_END
