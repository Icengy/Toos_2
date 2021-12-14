/*
 * Module:   TRTCVideoViewLayout
 * 
 * Function: 用于计算每个视频画面的位置排布和大小尺寸
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TRTCVideoViewLayoutDelegate <NSObject>

@required
- (void)trtcVideoForVisibleSupplementary:(NSArray <NSString *>* _Nullable) videoArray;

@end

@interface TRTCVideoViewLayout : NSObject

@property (nonatomic ,weak) id <TRTCVideoViewLayoutDelegate> delegate;

@property (nonatomic) UIView *view;           // 主view
@property (nonatomic, readonly) UIView *list;           // list
@property (nonatomic, readonly) UIView *label;    //label

@property (nonatomic) TCLayoutType type;

@property NSArray<UIView *> *subViews;
@property (nonatomic ,strong) NSArray<UIView *> *visibleViews;

- (void)relayout:(NSArray<UIView *> *)players;
- (void)reload;

- (void)hideWith:(BOOL)hidden;

@end

NS_ASSUME_NONNULL_END
