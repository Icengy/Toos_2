//
//  AddAdressViewController.h
//  ArtMedia
//
//  Created by 美术传媒 on 2018/10/28.
//  Copyright © 2018 lcy. All rights reserved.
//

#import "BaseViewController.h"
#import "MyAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddAdressViewController : BaseViewController

@property (nonatomic, strong) void(^clickToNewAddress)(MyAddressModel *model);
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,strong) MyAddressModel *addressModel;

@end

NS_ASSUME_NONNULL_END
