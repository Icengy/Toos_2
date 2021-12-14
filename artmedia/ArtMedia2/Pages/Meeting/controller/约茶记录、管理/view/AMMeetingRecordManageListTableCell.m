//
//  AMMeetingRecordManageListTableCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/8/17.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingRecordManageListTableCell.h"

#import "AMMeetingOrderManagerListModel.h"

@interface AMMeetingRecordManageListTableCell ()
@property (weak, nonatomic) IBOutlet AMIconImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bondLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *overdueTimeLabel;

@property (nonatomic ,assign) AMMeetingRecordManageListStyle cellStyle;
@end

@implementation AMMeetingRecordManageListTableCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _nameLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    _bondLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    _statusLabel.font = [UIFont addHanSanSC:14.0f fontType:0];
    _overdueTimeLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
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

- (void)setCellStyle:(AMMeetingRecordManageListStyle)cellStyle {
    _cellStyle = cellStyle;
//    NSString *keyStr = nil;
//    switch (_cellStyle) {
//        case AMMeetingRecordManageListStyleDaiYaoQing: {
//
//            _statusLabel.text = @"待邀请";
//            _statusLabel.textColor = UIColorFromRGB(0xE22020);
//            keyStr = self.style?@"后到期":@"前预约";
//            break;
//        }
//        case AMMeetingRecordManageListStyleYiYaoQing: {
//
//            _statusLabel.text = self.style?@"已邀请":@"待确认";
//            _statusLabel.textColor = UIColorFromRGB(0xE1991A);
//            keyStr = self.style?@"前邀请":@"前预约";
//            break;
//        }
//        case AMMeetingRecordManageListStyleYiQueRen: {
//
//            _statusLabel.text = @"已确认";
//            _statusLabel.textColor = UIColorFromRGB(0xE22020);
//            keyStr = @"前确认参加";
//            break;
//        }
//        case AMMeetingRecordManageListStyleYiQuXiao: {
//
//            _statusLabel.text = @"已取消";
//            _statusLabel.textColor = UIColorFromRGB(0x999999);
//            keyStr = @"前取消";
//            break;
//        }
//
//        default:
//            break;
//    }
//    if ([ToolUtil isEqualToNonNull:_model.statusTime]) {
//        self.overdueTimeLabel.hidden = NO;
//        self.overdueTimeLabel.text = [NSString stringWithFormat:@"%@%@",[TimeTool getDifferenceToCurrentSinceDateStr:_model.statusTime], keyStr];
//    }else {
//        self.overdueTimeLabel.hidden = YES;
//    }
}

- (void)setModel:(AMMeetingOrderManagerListModel *)model {
    _model = model;
    
    [self.iconIV am_setImageWithURL:_model.headimg placeholderImage:ImageNamed(@"logo") contentMode:(UIViewContentModeScaleAspectFill)];
    self.nameLabel.text = [ToolUtil isEqualToNonNullKong:_model.uname];
    if (_style == AMMeetingRecordManageStyleManage) {
        if ([ToolUtil isEqualToNonNull:_model.securityDeposit]) {
            self.bondLabel.text = [NSString stringWithFormat:@"约见保证金：¥%.2f",[ToolUtil isEqualToNonNull:_model.securityDeposit replace:@"0"].doubleValue];
        }else{
            self.bondLabel.text = @"";
        }
    }else {
        self.bondLabel.text = [ToolUtil isEqualToNonNullKong:_model.artistTitle];
    }
    
    NSString *keyStr = nil;
    switch (_model.orderStatus) {
        case AMMeetingRecordManageListStyleDaiYaoQing: {
            
            _statusLabel.text = @"待邀请";
            _statusLabel.textColor = UIColorFromRGB(0xE22020);
            keyStr = self.style?@"后到期":@"前预约";
            break;
        }
        case AMMeetingRecordManageListStyleYiYaoQing: {
            
            _statusLabel.text = self.style?@"已邀请":@"待确认";
            _statusLabel.textColor = UIColorFromRGB(0xE1991A);
            keyStr = self.style?@"前邀请":@"前预约";
            break;
        }
        case AMMeetingRecordManageListStyleYiQueRen: {
            
            _statusLabel.text = @"已确认";
            _statusLabel.textColor = RGB(153, 153, 153);
            keyStr = @"前确认参加";
            break;
        }
        case AMMeetingRecordManageListStyleYiQuXiao: {
            
            _statusLabel.text = @"已取消";
            _statusLabel.textColor = UIColorFromRGB(0x999999);
            keyStr = @"前取消";
            break;
        }
            
        default:
            break;
    }
    if ([ToolUtil isEqualToNonNull:_model.updateTime]) {
        self.overdueTimeLabel.hidden = NO;
        if (_model.orderStatus == AMMeetingRecordManageListStyleDaiYaoQing && self.style) {
            self.overdueTimeLabel.text = [NSString stringWithFormat:@"%@%@",[self getDifferenceToCurrentSinceDateStr:_model.updateTime], keyStr];
        }else {
            self.overdueTimeLabel.text = [NSString stringWithFormat:@"%@%@",[TimeTool getDifferenceToCurrentSinceDateStr:_model.updateTime], keyStr];
        }
    }else {
        self.overdueTimeLabel.hidden = YES;
    }
}

#pragma mark -
/// 当前时间与目标时间之间的差值
- (NSString *)getDifferenceToCurrentSinceDateStr:(NSString *)dateStr {
    if (![ToolUtil isEqualToNonNull:dateStr])  return 0;
    // 截止时间data格式
    NSDate *expireDate = [TimeTool getDateWithDateStr:dateStr];
    return [self getDifferenceToCurrentSinceTimeStamp:[expireDate timeIntervalSince1970]];
}

- (NSString *)getDifferenceToCurrentSinceTimeStamp:(NSTimeInterval)timeinterval {
    if (timeinterval == 0) return @"";
    NSInteger value = [TimeTool getCurrentTimeSp:nil] - timeinterval;
    
    if (value / 60 == 0) {
        return [NSString stringWithFormat:@"%02ld秒", value];
    }else if (value / (60*60) == 0) {
        return [NSString stringWithFormat:@"%02ld分钟", value/60];
    }else if (value / (60*60*24) == 0) {
        return [NSString stringWithFormat:@"%ld小时", value/(60*60)];
    }else if (value / (60 *60 *24 *30) == 0) {
        return [NSString stringWithFormat:@"%ld天", value/(60*60*24)];
    }else if (value / (60 *60 *24 *30 *12) == 0) {
        return [NSString stringWithFormat:@"%ld个月", value/(60*60*24*30)];
    }else
        return [NSString stringWithFormat:@"%ld年", value/(60*60*24*30*12)];
}

@end
