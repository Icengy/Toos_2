//
//  SearchBarView.h
//  ArtMedia2
//
//  Created by 美术传媒 on 2019/10/15.
//  Copyright © 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SearchBarView;
@protocol SearchBarViewDelegate <NSObject>

@optional
- (void)searchView:(SearchBarView *)search didClickToCancel:(id)sender;
- (void)searchView:(SearchBarView *)search didClickToHideTag:(BOOL)hidden;
- (void)searchView:(SearchBarView *)search didClickToSearch:(NSString *)keyword;

@end

@interface SearchBarView : UIView

@property (nonatomic ,weak) id <SearchBarViewDelegate> delegate;

@property (nonatomic ,copy) NSString *searchText;
@property (nonatomic ,copy) NSString *placeholder;

+ (SearchBarView *)shareInstance;

- (void)enterFirstResponse;
- (void)endFirstResponse;

@end

NS_ASSUME_NONNULL_END
