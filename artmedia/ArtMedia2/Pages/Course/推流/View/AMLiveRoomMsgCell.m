//
//  AMLiveRoomMsgCell.m
//  ArtMedia2
//
//  Created by LY on 2020/10/29.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMLiveRoomMsgCell.h"
@interface AMLiveRoomMsgCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *textBackView;
@end
@implementation AMLiveRoomMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.clipsToBounds = YES;
    // Initialization code
}
- (void)setModel:(AMLiveMsgModel *)model{
    _model = model;
    if (model.messageType == AMLiveMsgUserTypeChatTextMsg) {
//        if (model.userData.userType == AMLiveMsgUserTypeMember) {
            self.titleLabel.textColor = [UIColor whiteColor];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@",model.userData.userName , model.messageBody.messageText]];
            [attStr addAttributes:@{NSForegroundColorAttributeName : RGB(90, 195, 244)} range:NSMakeRange(0, model.userData.userName.length)];
            self.titleLabel.attributedText = attStr;
            self.textBackView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.3];
//        }else if(model.userData.userType == AMLiveMsgUserTypeTeacher){
//            self.titleLabel.textColor = [UIColor whiteColor];
//            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@",model.userData.userName , model.messageBody.messageText]];
//            [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(0, model.userData.userName.length)];
//            self.titleLabel.attributedText = attStr;
//            self.textBackView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.85];
//        }
    }else if(model.messageType == AMLiveMsgUserTypeMemberJoin){
        self.titleLabel.textColor = [UIColor blackColor];
        self.textBackView.backgroundColor = [UIColor whiteColor];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"欢迎%@进入直播间",model.userData.userName]];
        [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(2, model.userData.userName.length)];
        self.titleLabel.attributedText = attStr;
    }else if(model.messageType == AMLiveMsgUserTypeAlet){
        self.titleLabel.textColor = RGB(255, 33, 33);
        self.titleLabel.text = model.messageBody.messageText;
        self.textBackView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.3];
    }
    
}

- (UIColor*)RandomColor {
    NSInteger aRedValue =arc4random() %255;
    NSInteger aGreenValue =arc4random() %255;
    NSInteger aBlueValue =arc4random() %255;
    UIColor *randColor = [UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:1.0f];
    return randColor;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
