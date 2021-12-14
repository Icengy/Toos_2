//
//  AMMeetingDetailMeetingInfoView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/9/2.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMMeetingDetailMeetingInfoView.h"

#import "HK_tea_managerModel.h"

@interface AMMeetingDetailMeetingInfoView ()

@property (nonatomic ,weak) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UILabel *existLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (assign, nonatomic) double teaSignUpEndNum;

@end

@implementation AMMeetingDetailMeetingInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }return self;
}

- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.view];
    self.view.frame = self.bounds;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _timeLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    _beginLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    _maxLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    _existLabel.font = [UIFont addHanSanSC:12.0f fontType:0];
    _tipsLabel.font = [UIFont addHanSanSC:13.0f fontType:0];
}

- (void)setModel:(HK_tea_managerModel *)model {
    _model = model;
    
    switch (_model.infoStatus) {
        case 1:
            _timeLabel.text = [NSString stringWithFormat:@"报名截止：%@", [ToolUtil isEqualToNonNullKong:_model.teaSignUpEndTime]];
            _timeLabel.backgroundColor = UIColorFromRGB(0xF5E9E9);
            break;
        case 2:
            _timeLabel.text = nil;
            _timeLabel.backgroundColor = UIColorFromRGB(0xF5E9E9);
            break;
        case 3:
            _timeLabel.text = [NSString stringWithFormat:@"结束于：%@", [ToolUtil isEqualToNonNullKong:_model.teaSignUpEndTime]];
            _timeLabel.backgroundColor = UIColorFromRGB(0xCCCCCC);
            break;
        case 4:
            _timeLabel.text = [NSString stringWithFormat:@"取消于：%@", [ToolUtil isEqualToNonNullKong:_model.teaSignUpEndTime]];
            _timeLabel.backgroundColor = UIColorFromRGB(0xCCCCCC);
            break;
            
        default:
            break;
    }
    _beginLabel.text = [NSString stringWithFormat:@"会客时间：%@",[ToolUtil isEqualToNonNullKong:_model.teaStartTime]];
    _maxLabel.text = [NSString stringWithFormat:@"限额%@人", @(_model.peopleMax)];
    _existLabel.text = [NSString stringWithFormat:@"已报名%@人", @(_model.count)];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_existLabel.text];
    [attrString addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xE22020)} range:[_existLabel.text rangeOfString:StringWithFormat(@(_model.count))]];
    _existLabel.attributedText = attrString;
    
    _tipsLabel.text = [ToolUtil isEqualToNonNullForZanWu:_model.teaDesc];
    [_tipsLabel sizeToFit];
}

/*
 会客开始前为正值、开始后为负值
 "截止时间～开始前10分钟～会客开始时间～开始后2小时"
 time_num ~ self.teaSignUpEndNum 截止前
 time_num ~ TeaBeforeBeginOneHour 开始前1小时
 time_num ~ 600 倒计时10分钟后、会客开始前(预备时间)
 time_num ~ 0 会客已开始 （2小时持续）
 time_num ~ -TeaLastCountDown  会客已结束
 
 */
- (void)setTime_num:(double)time_num {
    _time_num = time_num;
    if (self.model.infoStatus == 1) {
//        if ([TimeTool getDifferenceSinceDate:self.model.currentTime toDate:self.model.teaSignUpEndTime] < 0) {
//
//        }else if ([TimeTool getDifferenceSinceDate:self.model.currentTime toDate:self.model.teaSignUpEndTime] >= 0 && [TimeTool getTimeSpWithDateString:self.model.currentTime] - ([TimeTool getTimeSpWithDateString:self.model.teaStartTime] - 3600) < 0){
//
//        }else{
//
//        }
        if (time_num > [TimeTool getDifferenceSinceDate:self.model.teaStartTime toDate:self.model.teaSignUpEndTime]) {//报名未截止
            _timeLabel.text = [NSString stringWithFormat:@"报名截止：%@", [ToolUtil isEqualToNonNullKong:_model.teaSignUpEndTime]];
            _timeLabel.backgroundColor = UIColorFromRGB(0xF5E9E9);
        }else{
            if (time_num <= 3600 ) {
                _timeLabel.text = [NSString stringWithFormat:@"开始倒计时：%@", [TimeTool timestampToTime:_time_num]];
                _timeLabel.backgroundColor = UIColorFromRGB(0xF5E9E9);
            }else{//截止报名后，开始前一小时之前
                _timeLabel.text = [NSString stringWithFormat:@"开始时间：%@", [ToolUtil isEqualToNonNullKong:_model.teaStartTime]];
                _timeLabel.backgroundColor = UIColorFromRGB(0xF5E9E9);
            }
        }
        
    }else if(self.model.infoStatus == 2){
        _timeLabel.text = [NSString stringWithFormat:@"进行中 %@", [TimeTool timestampToTime:_time_num]];
        _timeLabel.backgroundColor = UIColorFromRGB(0xF5E9E9);
    }
    
    
    
//    if (_time_num > self.teaSignUpEndNum) {
//        _timeLabel.text = [NSString stringWithFormat:@"报名截止：%@", [ToolUtil isEqualToNonNullKong:_model.teaSignUpEndTime]];
//        _timeLabel.backgroundColor = UIColorFromRGB(0xF5E9E9);
//        
//    }else if (_time_num > TeaBeforeBeginOneHour) {
//        _timeLabel.text = [NSString stringWithFormat:@"开始时间：%@", [ToolUtil isEqualToNonNullKong:_model.teaStartTime]];
//        _timeLabel.backgroundColor = UIColorFromRGB(0xF5E9E9);
//        
//    }else if ( _time_num >= TeaBeginCountDown) {
//        /// 预备期,(报名截止、会客开始前1小时)->(会客开始前十分钟)
//        _timeLabel.text = [NSString stringWithFormat:@"开始倒计时：%@", [TimeTool timestampToTime:_time_num]];
//        _timeLabel.backgroundColor = UIColorFromRGB(0xF5E9E9);
//        
//    }else if (_time_num > -TeaLastCountDown){
//        _timeLabel.text = [NSString stringWithFormat:@"进行中 %@", [TimeTool timestampToTime:(TeaLastCountDown - fabs(_time_num))]];
//        _timeLabel.backgroundColor = UIColorFromRGB(0xF5E9E9);
//        
//    }else {
//        _timeLabel.text = [NSString stringWithFormat:@"结束于：%@", [ToolUtil isEqualToNonNullKong:_model.teaSignUpEndTime]];
//        _timeLabel.backgroundColor = UIColorFromRGB(0xCCCCCC);
//    }
}

- (void)setTeaSignUpEndNum:(double)teaSignUpEndNum {
    _teaSignUpEndNum = teaSignUpEndNum;
    
}

@end
