//
//  AddNewBankCardCell.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/21.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AddNewBankCardCell;
@protocol AddNewBankCardCellDelegate <NSObject>

@optional
- (void)cellClickToAddBankName;
- (void)writeTFValue:(NSString *)tfValue indexPath:(NSIndexPath *)indexPath;

@end

@interface AddNewBankCardCell : UITableViewCell

@property (nonatomic ,weak) id <AddNewBankCardCellDelegate> delegate;

- (void)addNameText:(NSString *)nameString detailName:(NSString *)detailName placeholder:(NSString *)placeholder indexPath:(NSIndexPath *)indexPath enabled:(BOOL)enabled;
- (void)addNameText:(NSString *)nameString detailName:(NSString *)detailName placeholder:(NSString *)placeholder indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
