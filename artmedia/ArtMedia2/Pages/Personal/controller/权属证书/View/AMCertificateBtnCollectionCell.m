//
//  AMCertificateBtnCollectionCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/14.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCertificateBtnCollectionCell.h"

#import <WXApi.h>

@interface AMCertificateBtnCollectionCell ()
@property (weak, nonatomic) IBOutlet AMButton *downloadBtn;
@property (weak, nonatomic) IBOutlet AMButton *shareBtn;

@end

@implementation AMCertificateBtnCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _downloadBtn.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    _shareBtn.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    
    _shareBtn.hidden = ![WXApi isWXAppInstalled];
}

- (IBAction)clickToDownload:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnCell:didSelectedForDownload:)]) {
        [self.delegate btnCell:self didSelectedForDownload:sender];
    }
}

- (IBAction)clickToShare:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnCell:didSelectedForShare:)]) {
        [self.delegate btnCell:self didSelectedForShare:sender];
    }
}

@end
