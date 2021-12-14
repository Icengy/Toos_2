//
//  AMCourseMarkView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/10/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCourseMarkView.h"

@interface AMCourseMarkView ()

@property (weak, nonatomic) IBOutlet UIView *pointView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation AMCourseMarkView

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
    self.backgroundColor = [Color_Black colorWithAlphaComponent:0.5];
    
    _textLabel.font = [UIFont addHanSanSC:11.0 fontType:0];
}

- (void)setStyle:(AMCourseMarkStyle)style {
    _style = style;
    NSLog(@"AMCourseMarkStyle = %@",@(_style));
    self.hidden = NO;
    switch (_style) {
        case AMCourseMarkStyleDefault: {
            _textLabel.text = @"草稿  ";
            _pointView.backgroundColor = [UIColor clearColor];
            break;
        }
        case AMCourseMarkStyleExamining: {
            _textLabel.text = @"审核中";
            _pointView.backgroundColor = UIColorFromRGB(0xFF2C2C);
            break;
        }
        case AMCourseMarkStyleExamineFail: {
            _textLabel.text = @"审核失败";
            _pointView.backgroundColor = UIColorFromRGB(0xD8D8D8);
            break;
        }
        case AMCourseMarkStyleWaitingForClass: {
            _textLabel.text = @"待授课";
            _pointView.backgroundColor = UIColorFromRGB(0xFFE71A);
            break;
        }
        case AMCourseMarkStyleInClass: {
            _textLabel.text = @"授课中";
            _pointView.backgroundColor = UIColorFromRGB(0x44EE22);
            break;
        }
        case AMCourseMarkStyleInLive: {
            _textLabel.text = @"直播中";
            _pointView.backgroundColor = UIColorFromRGB(0x44EE22);
            break;
        }
        case AMCourseMarkStyleFinished: {
            _textLabel.text = @"已完成";
            _pointView.backgroundColor = UIColorFromRGB(0xD8D8D8);
            break;
        }
            
        default:
            self.hidden = YES;
            break;
    }
}

@end
