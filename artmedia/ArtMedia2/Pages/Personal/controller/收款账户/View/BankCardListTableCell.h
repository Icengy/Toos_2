//
//  BankCardListTableCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/24.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BankCardListModel : NSObject

@property (nonatomic, copy) NSString *back_icon;
@property (nonatomic, copy) NSString *bank_name;
@property (nonatomic, copy) NSString *id;

@end

@interface BankCardListTableCell : UITableViewCell

@property (nonatomic, strong) BankCardListModel *model;

@end

NS_ASSUME_NONNULL_END
