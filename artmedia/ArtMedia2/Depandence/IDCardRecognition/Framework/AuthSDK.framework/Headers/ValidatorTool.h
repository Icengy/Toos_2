//
//  ValidatorTool.h
//  MedPlus
//
//  Created by jardgechen on 16/5/18.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidatorTool : NSObject

//正则验证手机号码
+(BOOL)isValidateMobile:(NSString*)phoneNum;
//正则验证名字
+(BOOL)isValidateName:(NSString *)name;
//按规则验证身份证号
+(BOOL)isValidatedAllIdcard:(NSString *)idCard;
@end
