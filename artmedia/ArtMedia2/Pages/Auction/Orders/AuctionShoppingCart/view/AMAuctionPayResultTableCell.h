//
//  AMAuctionPayResultTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/11/20.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMAuctionBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

/// 长按Label实现复制
@interface AMCopyLabel : UILabel
@property (nonatomic, strong) UIPasteboard *pasteBoard;
@end

@interface AMAuctionPayResultTableCell : AMAuctionBaseTableCell

@end

NS_ASSUME_NONNULL_END
