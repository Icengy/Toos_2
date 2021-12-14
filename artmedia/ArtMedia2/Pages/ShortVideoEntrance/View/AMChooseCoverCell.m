//
//  AMChooseCoverCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/11/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMChooseCoverCell.h"

@interface AMChooseCoverCell ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation AMChooseCoverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self showSelectedView:YES];
}

- (void)setSelected:(BOOL)selected {
    [self showSelectedView:!selected];
    [super setSelected:selected];
}

- (void)setCoverImage:(UIImage *)coverImage {
    _coverImage = coverImage;
    self.imageView.image = coverImage;
}

- (void)showSelectedView:(BOOL)hidden {
    self.leftView.hidden = hidden;
    self.rightView.hidden = hidden;
    self.topView.hidden = hidden;
    self.bottomView.hidden = hidden;
}

@end
