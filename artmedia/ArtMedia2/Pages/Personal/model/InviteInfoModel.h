//
//  InviteInfoModel.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InviteInfoModel : NSObject

@property (nonatomic ,copy) NSString *id;
@property (nonatomic ,copy) NSString *uid;
@property (nonatomic ,copy) NSString *uname;
@property (nonatomic ,copy) NSString *headimg;
@property (nonatomic ,copy) NSString *addtime;
@property (nonatomic ,copy) NSString *ivcount;
@property (nonatomic ,copy) NSString *invitation_code;
@property (nonatomic ,copy) NSString *utype;

@end

NS_ASSUME_NONNULL_END
