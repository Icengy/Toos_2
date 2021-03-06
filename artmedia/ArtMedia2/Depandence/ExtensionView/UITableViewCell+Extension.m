//
//  UITableViewCell+Extension.m
//  ArtMedia2
//
//  Created by icnengy on 2020/6/18.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "UITableViewCell+Extension.h"

@implementation UITableViewCell (Extension)

/// 替换UITableViewCell的右侧箭头
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        UIImageView *arror = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-right_cell"]];
        arror.contentMode = UIViewContentModeScaleAspectFit;
        arror.frame = CGRectMake(0, 0, 15.0f, 15.0f);
        self.accessoryView = arror;
    }
}
- (void)addSectionCornerWithTableView:(UITableView *)tableView tableViewCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath cornerRadius:(CGFloat)cornerRadius {
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    CGRect bounds = cell.bounds;
    
    if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
        
        /** 每组只有一行的时候 */
        CGPathMoveToPoint(pathRef, nil, CGRectGetMidX(bounds), CGRectGetMaxY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMinX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil,   CGRectGetMaxX(bounds), CGRectGetMaxY(bounds),CGRectGetMidX(bounds), CGRectGetMaxY(bounds),cornerRadius);
        
    } else if (indexPath.row == 0) {
        
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
        
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        
    }else if (indexPath.row != 0 && indexPath.row != [tableView numberOfRowsInSection:indexPath.section] - 1) {
        /** 每组中间的行 */
        CGPathAddRect(pathRef, nil, bounds);
    }
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = pathRef;
    CFRelease(pathRef);
    layer.fillColor = [UIColor whiteColor].CGColor;

    UIView *backView = [[UIView alloc] initWithFrame:bounds];
    [backView.layer addSublayer:layer];
    backView.backgroundColor = [UIColor clearColor];
    cell.backgroundView = backView;
}
@end
