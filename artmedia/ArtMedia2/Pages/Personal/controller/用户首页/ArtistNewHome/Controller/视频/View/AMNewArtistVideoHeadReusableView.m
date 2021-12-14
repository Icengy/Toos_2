//
//  AMNewArtistVideoHeadReusableView.m
//  ArtMedia2
//
//  Created by 刘洋 on 2020/9/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMNewArtistVideoHeadReusableView.h"

#define ArtistVideoHeadButtonTagDefault 202010210

@interface AMNewArtistVideoHeadReusableView ()

@property (weak, nonatomic) IBOutlet AMButton *allButton;
@property (weak, nonatomic) IBOutlet AMButton *creatButton;
@property (weak, nonatomic) IBOutlet UILabel *countNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTypeLabel;

@end
@implementation AMNewArtistVideoHeadReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _countNumLabel.font = [UIFont addHanSanSC:13.0 fontType:0];
    _videoTypeLabel.font = [UIFont addHanSanSC:17.0 fontType:2];
    
    _allButton.selected = YES;
    _creatButton.selected = NO;
    [self suitBtnUIs];
}

- (IBAction)click:(AMButton *)sender {
    NSInteger tag = sender.tag - ArtistVideoHeadButtonTagDefault;
    if (tag == 0) {
        self.allButton.selected = YES;
        self.creatButton.selected = NO;
        
        self.videoTypeLabel.text = @"全部视频";
    }else{
        self.allButton.selected = NO;
        self.creatButton.selected = YES;
        
        self.videoTypeLabel.text = @"创作视频";
    }
    
    [self suitBtnUIs];
    
    self.allButton.userInteractionEnabled = NO;
    self.creatButton.userInteractionEnabled = NO;
    
    if (self.buttonClickBlock) self.buttonClickBlock(tag);
}

- (void)suitBtnUIs {
    _allButton.titleLabel.font = [UIFont addHanSanSC:13.0 fontType:_allButton.selected];
    _creatButton.titleLabel.font = [UIFont addHanSanSC:13.0 fontType:_creatButton.selected];
}

- (void)setCount_num:(NSString *)count_num {
    _count_num = count_num;
    
    self.allButton.userInteractionEnabled = YES;
    self.creatButton.userInteractionEnabled = YES;
    
    self.countNumLabel.text = [NSString stringWithFormat:@"共%@个",[ToolUtil isEqualToNonNull:_count_num replace:@"0"]];
}



@end
