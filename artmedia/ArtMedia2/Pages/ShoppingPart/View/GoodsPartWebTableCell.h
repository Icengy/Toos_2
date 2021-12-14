//
//  GoodsPartWebTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/7/22.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsPartWebTableCell;
NS_ASSUME_NONNULL_BEGIN

@protocol GoodsPartWebDelegate <NSObject>

@optional
- (void)webCell:(GoodsPartWebTableCell *)webCell didFinishLoadWithScrollHeight:(CGFloat)scrollHeight;

@end

@interface GoodsPartWebTableCell : UITableViewCell

@property (nonatomic ,weak) id <GoodsPartWebDelegate> delegate;
@property (nonatomic ,assign) BOOL needWeb;
@property (nonatomic ,strong) NSDictionary *webInfo;

@end

NS_ASSUME_NONNULL_END
