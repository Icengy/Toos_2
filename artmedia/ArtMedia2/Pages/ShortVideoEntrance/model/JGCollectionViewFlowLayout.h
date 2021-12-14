//
//  JGCollectionViewFlowLayout.h
//  UICollectionDemo
//
//  Created by 郭军 on 2019/6/5.
//  Copyright © 2019 JG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol JGCollectionViewFlowLayoutDelegate <NSObject>

- (void)collectionViewDidScrollowTo:(NSInteger)index;

@end
@interface JGCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic,assign)id<JGCollectionViewFlowLayoutDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
