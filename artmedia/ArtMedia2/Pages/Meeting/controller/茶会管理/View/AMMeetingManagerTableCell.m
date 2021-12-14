//
//  AMMeetingManagerTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/8.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingManagerTableCell.h"

#import "HK_tea_managerModel.h"
@interface AMMeetingManagerTableCell ()
@property (nonatomic,weak) IBOutlet UILabel *statusLabel;//状态
@property (nonatomic,weak) IBOutlet UILabel *peopleNumLabel;//总人数
@property (nonatomic,weak) IBOutlet UILabel *actualNumLabel;//实际人数
@property (nonatomic,weak) IBOutlet UILabel *titleLabel;//标题
@property (nonatomic,weak) IBOutlet UILabel *contentLabel;

@property (nonatomic,weak) IBOutlet AMButton *detalButton;//查看详情
@property (nonatomic,weak) IBOutlet AMButton *goRoomButton;
@property (nonatomic,weak) IBOutlet AMButton *lookInvitationButton;
@end

@implementation AMMeetingManagerTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _statusLabel.font = [UIFont addHanSanSC:11.0f fontType:0];
    _peopleNumLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    _actualNumLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    
    _titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    _contentLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
    
    _detalButton.titleLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    _goRoomButton.titleLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    _lookInvitationButton.titleLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 15.0f;
    frame.size.width -= 30.0f;
    [super setFrame:frame];
}

- (void)setModel:(HK_tea_managerModel *)model{
    _model = model;
    
    _goRoomButton.hidden = YES;
    NSString *title;
    UIColor *color;
    switch (_model.infoStatus) {
        case 1: {
            title = @"待开始";
            color = UIColorFromRGB(0xE22020);
            if ([TimeTool getDifferenceSinceDateStr:_model.teaStartTime cloudTime:_model.currentTime] <= TeaBeginCountDown) {/// 时间进入开始倒计时10分钟 且 已参加
                _goRoomButton.hidden = NO;
            }
            
            break;
        }
        case 2: {
            title = @"进行中";
            color = UIColorFromRGB(0xE29220);
            _goRoomButton.hidden = NO;
            break;
        }
        case 3: {
            title = @"已结束";
            color = UIColorFromRGB(0x999999);
            break;
        }
        case 4: {
            title = @"已取消";
            color = UIColorFromRGB(0x999999);
            break;
        }
            
        default:
            break;
    }
    
    self.statusLabel.text = title;
    self.statusLabel.textColor = color;
    self.statusLabel.layer.borderColor = color.CGColor;
    
    self.titleLabel.text=[NSString stringWithFormat:@"会客开始时间：%@",model.teaStartTime];
    self.peopleNumLabel.text = [NSString stringWithFormat:@"/%@",@(model.peopleMax)];
    self.actualNumLabel.text = [NSString stringWithFormat:@"%@",@(model.presentCount)];
    
    self.contentLabel.text = [ToolUtil isEqualToNonNullKong:model.teaDesc];
}

#pragma mark -

- (IBAction)clickToEnterRoom:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(managerCell:didSelectedToEnterRoom:)]) {
        [self.delegate managerCell:self didSelectedToEnterRoom:sender];
    }
}
- (IBAction)clickToLookInvitation:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(managerCell:didSelectedToLookInvtation:)]) {
        [self.delegate managerCell:self didSelectedToLookInvtation:sender];
    }
}
- (IBAction)clickToDetail:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(managerCell:didSelectedToDetail:)]) {
        [self.delegate managerCell:self didSelectedToDetail:sender];
    }
}

@end
