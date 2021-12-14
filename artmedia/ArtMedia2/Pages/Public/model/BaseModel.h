//
//  BaseModel.h
//  ArtMedia2
//
//  Created by icnengy on 2020/10/9.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseModel : NSObject

//@property (nonatomic ,copy) NSString *id; //主键id

@property (nonatomic ,copy) NSString *createUserId;                    //创建人ID
@property (nonatomic ,copy) NSString *createUserName;                 //创建人名称
@property (nonatomic ,copy) NSString *createTime;          //创建时间
@property (nonatomic ,copy) NSString *updateUserId;                        //修改人id
@property (nonatomic ,copy) NSString *updateUserName;                 //修改人名称
@property (nonatomic ,copy) NSString *updateTime;         //修改时间

@end

NS_ASSUME_NONNULL_END
