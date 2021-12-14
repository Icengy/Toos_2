//
//  AuctionItemBidRecordHeadView.m
//  ArtMedia2
//
//  Created by 刘洋 on 2020/11/23.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AuctionItemBidRecordHeadView.h"

@interface AuctionItemBidRecordHeadView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timesLabel;

@property (weak, nonatomic) IBOutlet AMReverseButton *rulersBtn;

@end

@implementation AuctionItemBidRecordHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.font = [UIFont addHanSanSC:14.0 fontType:2];
    self.timesLabel.font = [UIFont addHanSanSC:14.0 fontType:2];
    self.rulersBtn.titleLabel.font = [UIFont addHanSanSC:14.0 fontType:0];
    
}

- (void)setBidTotalTimes:(NSInteger)bidTotalTimes {
    _bidTotalTimes = bidTotalTimes;
    self.timesLabel.hidden = !_bidTotalTimes;
    self.timesLabel.text = [NSString stringWithFormat:@"（共%@次出价）", @(_bidTotalTimes)];
}


- (IBAction)clickToRuler:(id)sender {
    if (self.clickToRulersBlock) self.clickToRulersBlock();
}

@end
