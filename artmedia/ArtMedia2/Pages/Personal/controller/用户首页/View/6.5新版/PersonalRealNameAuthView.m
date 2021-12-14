//
//  PersonalRealNameAuthView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "PersonalRealNameAuthView.h"

@interface PersonalRealNameAuthView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *detailTF;

@end

@implementation PersonalRealNameAuthView

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
    self.backgroundColor = UIColor.clearColor;
    self.view.frame = self.bounds;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    _detailTF.font = [UIFont addHanSanSC:14.0f fontType:0];
    _detailTF.delegate = self;
    [_detailTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    if (_titleStr) {
        _titleLabel.text = _titleStr;
    }
}

- (void)setDetailStr:(NSString *)detailStr {
    _detailStr = detailStr;
    if (_detailStr) {
        _detailTF.text = _detailStr;
    }
}

- (void)setPlaceholdStr:(NSString *)placeholdStr {
    _placeholdStr = placeholdStr;
    if (_placeholdStr) {
        _detailTF.placeholder = _placeholdStr;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return !self.isAuthed;
}

- (void)textFieldDidChange:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(authView:writeTFValue:)]) {
        [self.delegate authView:self writeTFValue:textField.text];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (![ToolUtil isEqualToNonNull:textField.text]) {
        _detailTF.font = [UIFont addHanSanSC:14.0f fontType:0];
    }
}

@end
