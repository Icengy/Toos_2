//
//  LiveRoomHeadView.m
//  ArtMedia2
//
//  Created by LY on 2020/10/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "LiveRoomHeadView.h"
@interface LiveRoomHeadView ()

@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *watchCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *focusButton;


@end
@implementation LiveRoomHeadView
+ (instancetype)share{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
}

 

//-(instancetype)initWithFrame:(CGRect)frame
//
//{
//    self = [super initWithFrame:frame];
//
//    if (self) {
//
//        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
//
//
//    }
//
//    return self;
//
//}

@end
