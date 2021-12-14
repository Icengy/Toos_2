//
//  PersonalRealNameAuthView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/6/15.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PersonalRealNameAuthView;
@protocol PersonalRealNameAuthDelegate <NSObject>

@optional
- (void)authView:(PersonalRealNameAuthView *)authView writeTFValue:(NSString *)tfValue;

@end

@interface PersonalRealNameAuthView : UIView
@property(nonatomic,strong) IBOutlet UIView* view;

@property (nonatomic ,weak) id <PersonalRealNameAuthDelegate> delegate;


@property (nonatomic ,copy ,nullable) NSString *titleStr;
@property (nonatomic ,copy ,nullable) NSString *detailStr;
@property (nonatomic ,copy ,nullable) NSString *placeholdStr;
@property (nonatomic ,assign) BOOL isAuthed;
@end

NS_ASSUME_NONNULL_END
