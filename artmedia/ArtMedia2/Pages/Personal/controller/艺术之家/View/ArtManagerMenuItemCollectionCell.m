//
//  ArtManagerMenuItemCollectionCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/3.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "ArtManagerMenuItemCollectionCell.h"

@interface ArtManagerMenuItemCollectionCell ()
@property (weak, nonatomic) IBOutlet PersonalMenuItemButton *item;
@end

@implementation ArtManagerMenuItemCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _item.titleLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    [_item setTitle:_titleStr forState:UIControlStateNormal];
}

- (void)setImageStr:(NSString *)imageStr {
    _imageStr = imageStr;
    [_item setImage:ImageNamed(_imageStr) forState:UIControlStateNormal];
}

- (IBAction)clickToSelected:(id)sender {
    if (_selectedItemBlock) _selectedItemBlock(sender);
}


@end
