//
//  ArtManagerClassCell.h
//  ArtMedia2
//
//  Created by LY on 2020/10/22.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArtManagerClassCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *classNumLabel;
@property (nonatomic , copy) NSString *courseNumber;
@end

NS_ASSUME_NONNULL_END
