//
//  EmptyTableViewCell.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/13.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "EmptyTableViewCell.h"

@implementation EmptyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
    }return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
    }return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentCarrier mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0.0f);
    }];
}

- (void)setContentCarrier:(UIView *)contentCarrier {
    _contentCarrier = contentCarrier;
    [self addSubview:_contentCarrier];
}

@end
