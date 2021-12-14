//
//  TeaMeetingRecordCell.m
//  ArtMedia2
//
//  Created by 名课 on 2020/9/8.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "TeaMeetingRecordCell.h"

#import "HK_tea_managerModel.h"
@interface TeaMeetingRecordCell ()
@property (weak, nonatomic) IBOutlet UIImageView *peopleImageView;
@property (weak, nonatomic) IBOutlet UILabel *teaMeetingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *gotoRoomButton;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;


@end

@implementation TeaMeetingRecordCell
- (IBAction)gotoRoomClick:(UIButton *)sender {
    if (self.gotoMeetingRoomBlock) {
        self.gotoMeetingRoomBlock(self.model);
    }
}
- (IBAction)gotoDetailClick:(UIButton *)sender {
    if (self.gotoDetailBlock) {
        self.gotoDetailBlock(self.model.teaAboutInfoId);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(HK_tea_managerModel *)model{
    _model = model;
    if ([ToolUtil isEqualToNonNull:_model.createUserName]) {
        self.teaMeetingNameLabel.text = [NSString stringWithFormat:@"%@的会客",[ToolUtil isEqualToNonNullKong:model.createUserName]];
    }
    
    [self.peopleImageView am_setImageWithURL:model.headimg placeholderImage:ImageNamed(@"logo") contentMode:(UIViewContentModeScaleAspectFill)];
    
    self.timeLabel.text=[ToolUtil isEqualToNonNullKong:model.teaStartTime];
    self.contentLabel.text=[ToolUtil isEqualToNonNullKong:model.teaDesc];
    self.totalLabel.text=[NSString stringWithFormat:@"/%@",@(model.peopleMax)];
    self.currentLabel.text = [NSString stringWithFormat:@"%@",@(model.presentCount)];
    if (model.infoStatus == 1) {
        self.statusLabel.text=@"待开始";
        self.statusLabel.textColor=RGBA(225, 31, 31, 1);
        self.statusLabel.layer.borderColor = RGBA(225, 31, 31, 1).CGColor;
        self.gotoRoomButton.hidden = YES;
        if ([TimeTool getDifferenceSinceDateStr:_model.teaStartTime cloudTime:_model.currentTime] <= TeaBeginCountDown) {/// 时间进入开始倒计时10分钟 且 已参加
            self.gotoRoomButton.hidden = NO;
        }
        self.currentLabel.textColor = UIColorFromRGB(0xE29220);
    }else if (model.infoStatus==2){
        self.statusLabel.text=@"进行中";
        self.statusLabel.textColor=RGBA(226, 146, 32, 1);
        self.statusLabel.layer.borderColor = RGBA(226, 146, 32, 1).CGColor;
        self.gotoRoomButton.hidden = NO;
        self.currentLabel.textColor = UIColorFromRGB(0xE29220);
        
    }else if (model.infoStatus==3){
        self.statusLabel.text=@"已结束";
        self.statusLabel.textColor=RGB(153, 153, 153);
        self.statusLabel.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
        self.gotoRoomButton.hidden = YES;
        self.currentLabel.textColor = UIColorFromRGB(0x999999);
        
    }else if (model.infoStatus==4){
        self.statusLabel.text=@"已取消";
        self.statusLabel.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
        self.statusLabel.textColor=RGB(153, 153, 153);
        self.gotoRoomButton.hidden = YES;
        self.currentLabel.textColor = UIColorFromRGB(0x999999);
        
    }
}

- (void)setFrame:(CGRect)frame {
//    frame.origin.x += 15.0f;
//    frame.size.width -= 30.0f;
    [super setFrame:frame];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
