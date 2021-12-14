//
//  AMCertificateListCollectionCell.h
//  ArtMedia2
//
//  Created by icnengy on 2020/9/12.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AMCertificateStyle) {
    /// 全部 （该参数不参与cell布局）
    AMCertificateStyleAll = 0,
    /// 正常
    AMCertificateStyleNormal,
    /// 已吊销
    AMCertificateStyleRevocation
};

NS_ASSUME_NONNULL_BEGIN

@interface AMCertificateListModel : NSObject

@property (nonatomic ,copy) NSString *certId; //权属证书ID
@property (nonatomic ,copy) NSString *certNumber;// 权属证书编号
@property (nonatomic ,copy) NSString *ownerUserId;// 权属人用户ID
@property (nonatomic ,copy) NSString *ownerRealName;//  权属人真实姓名
@property (nonatomic ,copy) NSString *goodId;//  商品ID
@property (nonatomic ,copy) NSString *goodOrderNumber;// 商品订单编号
@property (nonatomic ,copy) NSString *certImagePath;// 权属证书图片路径
@property (nonatomic ,copy) NSString *certStatus;// 权属证书状态：1持有中，2已吊销，3已删除
@property (nonatomic ,copy) NSString *createUserId;//
@property (nonatomic ,copy) NSString *createUserName;//
@property (nonatomic ,copy) NSString *createTime;//
@property (nonatomic ,copy) NSString *updateUserId;//
@property (nonatomic ,copy) NSString *updateUserName;//
@property (nonatomic ,copy) NSString *updateTime;//

@end

@interface AMCertificateListCollectionCell : UICollectionViewCell

@property (nonatomic, strong) AMCertificateListModel *model;
@property (nonatomic, assign) AMCertificateStyle style;
@property (nonatomic, strong, readonly) UIImage *cerImage;

@end

NS_ASSUME_NONNULL_END
