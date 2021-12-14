// Copyright (c) 2019 Tencent. All rights reserved.

#import <UIKit/UIKit.h>
#import "UGCKitTheme.h"

@protocol TCBGMControllerListener <NSObject>
-(void) onBGMControllerPlay:(NSObject*) path;
@end

@interface UGCKitBGMListViewController : UITableViewController

@property (nonatomic ,copy) NSString *selectedBGMPath;

@property (nonatomic ,strong) NSDictionary *listPrams;
- (instancetype)initWithTheme:(UGCKitTheme*)theme;
- (void)setBGMControllerListener:(id<TCBGMControllerListener>) listener;
- (void)loadBGMList;
- (void)clearSelectStatus;

@end
