//
//  MyInviterItemFillView.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "MyInviterItemFillView.h"

@implementation MyInviterItemFillView

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
    self.inputTF.delegate = self;
    [self.inputTF addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.endEditingBlock) self.endEditingBlock(textField.text);
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.inputTF endEditing:YES];
    return YES;
}

- (void)textDidChanged:(id)sender {
    if (self.endEditingBlock) self.endEditingBlock(self.inputTF.text);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
