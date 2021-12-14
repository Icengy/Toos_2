//
//  MyAddressModel.h
//  ArtMedia
//
//  Created by 程明 on 2018/11/15.
//  Copyright © 2018 程明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyAddressModel : NSObject

@property(nonatomic,copy)NSString*id;
///接收者
@property(nonatomic,copy)NSString*recipient;
///手机号
@property(nonatomic,copy)NSString*phone;
@property(nonatomic,copy)NSString*addrregion;
@property(nonatomic,copy)NSString*address;
@property(nonatomic,copy)NSString*is_default;

@end

NS_ASSUME_NONNULL_END
