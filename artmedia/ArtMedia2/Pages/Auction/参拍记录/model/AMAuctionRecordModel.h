//
//  AMAuctionRecordModel.h
//  ArtMedia2
//
//  Created by icnengy on 2020/11/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AMAuctionRecordModel : BaseModel

///用户参拍记录表主键id
@property (nonatomic ,copy) NSString *recordId;
/// pm专场关联id
@property (nonatomic ,copy) NSString *auctionFieldId;
/// 主办方用户id（艺术家id）
@property (nonatomic ,copy) NSString *hostUserId;
/// 主办方名称(艺术家名称)
@property (nonatomic ,copy) NSString *hostUserName;
/// 专场名称
@property (nonatomic ,copy) NSString *auctionFieldTitle;
/// 专场拍品表关联id
@property (nonatomic ,copy) NSString *auctionGoodId;
/// 艺术家作品主键id
@property (nonatomic ,copy) NSString *artistOpusId;
/// 艺术家作品标题
@property (nonatomic ,copy) NSString *opusTitle;
@property (nonatomic ,copy) NSString *composeTitle;
///规格描述
@property (nonatomic ,copy) NSString *opusSpecs;
/// 作品编号
@property (nonatomic ,copy) NSString *goodNumber;
/// 艺术家作品封面图片
@property (nonatomic ,copy) NSString *opusCoverImage;
/// 是否得标：1 未得标；2 已得标未结算；3 已结算
@property (nonatomic ,copy) NSString *isWinner;
/// 备注
@property (nonatomic ,copy) NSString *remark;

@end

NS_ASSUME_NONNULL_END
