//
//  LivingRoomButton.m
//  ArtMedia2
//
//  Created by 名课 on 2020/9/2.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "LivingRoomButton.h"

@implementation LivingRoomButton

- (void)awakeFromNib{
    [super awakeFromNib];
    UIImageView * cloudImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tab_cloud"]];
    cloudImage.y = self.height - cloudImage.height;
    [self addSubview:cloudImage];
}

@end
