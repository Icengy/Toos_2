//
//  AMCoursePriceEditView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/10/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCoursePriceEditView.h"

@interface AMCoursePriceEditView ()
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@end

@implementation AMCoursePriceEditView

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
    [self.inputTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _unitLabel.font = [UIFont addHanSanSC:13.0 fontType:0];
    _inputTF.font = [UIFont addHanSanSC:13.0 fontType:0];
}
-(void)textFieldDidChange:(UITextField*)textField{
    CGFloat maxLength = 8;
    NSString *toBeString = textField.text;
    //获取高亮部分
    UITextRange*selectedRange = [textField markedTextRange];
    UITextPosition*position = [textField positionFromPosition:selectedRange.start offset:0];
    if(!position || !selectedRange)
    {
        if(toBeString.length > maxLength){
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
            if(rangeIndex.length ==1){
                textField.text = [toBeString substringToIndex:maxLength];
            }else{
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
            
        }
        
    }
    
}
@end
