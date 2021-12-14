// Copyright (c) 2019 Tencent. All rights reserved.

#import "UGCKitBGMListViewController.h"
//#import "UGCKitBGMHelper.h"
#import "UGCKitBGMCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "UGCKitColorMacro.h"
#import <objc/runtime.h>
#import "UGCKitMem.h"

#import "AMEmptyView.h"
#import "UIScrollView+RefreshHandler.h"
#import <SVProgressHUD+AMProgressHUD.h>

#import "ToolUtil.h"
#import "NetworkMacro.h"

#define  UGCKitCompleteLocalPath(localPath)  [NSHomeDirectory() stringByAppendingPathComponent:localPath]

@interface TCBGMElement : NSObject

@property NSString* id;
@property NSString* name;
@property NSString* netUrl;
@property NSString* localUrl;
@property NSString* author;
@property NSString* title;
@property NSString* music_length;
@property NSNumber* duration;//float MicroSeconds
@property NSNumber* isValid;
@property NSString* category;//分类

@end

@implementation TCBGMElement

- (id) initWithCoder: (NSCoder *)coder {
    if (self = [super init]) {
        self.id = [coder decodeObjectForKey:@"id"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.netUrl = [coder decodeObjectForKey:@"netUrl"];
        self.localUrl = [coder decodeObjectForKey:@"localUrl"];
        self.author = [coder decodeObjectForKey:@"author"];
        self.title = [coder decodeObjectForKey:@"title"];
        self.music_length = [coder decodeObjectForKey:@"music_length"];
        self.isValid = [coder decodeObjectForKey:@"isValid"];
        self.duration = [coder decodeObjectForKey:@"duration"];
        self.category = [coder decodeObjectForKey:@"category"];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder *)coder {
    [coder encodeObject:_id forKey:@"id"];
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_netUrl forKey:@"netUrl"];
    [coder encodeObject:_localUrl forKey:@"localUrl"];
    [coder encodeObject:_author forKey:@"author"];
    [coder encodeObject:_music_length forKey:@"music_length"];
    [coder encodeObject:_title forKey:@"title"];
    [coder encodeObject:_isValid forKey:@"isValid"];
    [coder encodeObject:_duration forKey:@"duration"];
    [coder encodeObject:_category forKey:@"category"];
}

@end

@interface UGCKitBGMListViewController()<UGCKitBGMCellDelegate,MPMediaPickerControllerDelegate>{
    NSMutableDictionary* _progressList;
    NSTimeInterval lastUIFreshTick;
    UGCKitTheme *_theme;
}
@property(nonatomic,strong) NSDictionary* bgmDict;
@property(nonatomic,strong) NSArray* bgmKeys;
//@property(nonatomic,strong) UGCKitBGMHelper* bgmHelper;
@property(nonatomic,weak) id<TCBGMControllerListener> bgmListener;
@end


@implementation UGCKitBGMListViewController
{
    NSIndexPath *_BGMCellPath;
    BOOL      _useLocalMusic;
    NSInteger _page;
}

- (instancetype)initWithTheme:(UGCKitTheme *)theme {
    if (self = [self initWithStyle:UITableViewStylePlain]) {
        _theme = theme;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _progressList = [NSMutableDictionary new];
        _useLocalMusic = NO;
        _page = 0;
        _BGMCellPath = nil;
        self.selectedBGMPath = nil;
    }
    return self;
}

-(void)setBGMControllerListener:(id<TCBGMControllerListener>) listener{
    _bgmListener = listener;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_bgmKeys.count) {
        [self loadData:nil];
    }else {
        [self.tableView reloadData];
    }
}

-(void)viewDidLoad {
    [super viewDidLoad];
//
//    _bgmHelper = [UGCKitBGMHelper sharedInstance];
//    [_bgmHelper setDelegate:self];
    
    self.tableView.backgroundColor = RGB(25, 29, 38);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"UGCKitResources" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UGCKitBGMCell class]) bundle:bundle] forCellReuseIdentifier:@"UGCKitBGMCell"];
    
    [self.tableView addRefreshFooterWithTarget:self action:@selector(loadData:)];
    [self.tableView addRefreshHeaderWithTarget:self action:@selector(loadData:)];
    self.tableView.ly_emptyView = [AMEmptyView am_emptyActionViewWithTarget:self action:@selector(loadData:)];
}

- (void)goBack {
    [_bgmListener onBGMControllerPlay:nil];
}

- (void)loadBGMList {
    if (_useLocalMusic) {
        [self showMPMediaPickerController];
    }else {
        lastUIFreshTick = [[NSDate date] timeIntervalSince1970] *1000;
//        _bgmHelper = [UGCKitBGMHelper sharedInstance];
//        [_bgmHelper setDelegate:self];
//        NSString* jsonUrl = @"http://bgm-1252463788.cosgz.myqcloud.com/bgm_list.json";
//        [_bgmHelper initBGMListWithJsonFile:jsonUrl];
    }
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_bgmKeys count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGCKitBGMCell* cell = (UGCKitBGMCell *)[tableView dequeueReusableCellWithIdentifier:@"UGCKitBGMCell"];
    if (!cell) {
        cell = [[UGCKitBGMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UGCKitBGMCell"];
    }
    if (nil == cell.downloadButtonBackground) {
        cell.downloadButtonBackground = _theme.recordMusicDownloadIcon;
        cell.progressButtonBackground = _theme.nextIcon;
        cell.downloadText = [_theme localizedString:@"UGCKit.Common.Download"];
        cell.downloadingText = [_theme localizedString:@"UGCKit.UGCKit.Common.Downloading"];
        cell.applyText = [_theme localizedString:@"UGCKit.Common.Apply"];
        cell.applyingText = [_theme localizedString:@"UGCKit.UGCKit.Common.Applying"];
    }

    cell.delegate = self;
    
    TCBGMElement* ele =  _bgmDict[_bgmKeys[indexPath.row]];
    cell.musicLabel.text = ele.name;
    cell.authorLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",(ele.music_length.integerValue/60), (ele.music_length.integerValue%60)];
    cell.downloadUrlStr = ele.netUrl;
    MCDownloadReceipt *receipt = [[MCDownloadManager defaultInstance] downloadReceiptForURL:cell.downloadUrlStr];
    if (receipt.filePath && [receipt.filePath isEqualToString:_selectedBGMPath]) {
        [cell.downLoadBtn setTitle:cell.applyingText forState:UIControlStateNormal];
    }
    
    return cell;
}

- (void)onBGMDownLoad:(UGCKitBGMCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    _BGMCellPath = indexPath;
    
    TCBGMElement* ele =  _bgmDict[_bgmKeys[indexPath.row]];
    ele.isValid = [NSNumber numberWithBool:true];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    
    MCDownloadReceipt *receipt = [[MCDownloadManager defaultInstance] downloadReceiptForURL:cell.downloadUrlStr];
    [_bgmListener onBGMControllerPlay:receipt.filePath];
}

static void *mpcKey = &mpcKey;
- (void)showMPMediaPickerController
{
    MPMediaPickerController *mpc = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    mpc.delegate = self;
    mpc.editing = YES;
    mpc.allowsPickingMultipleItems = NO;
    mpc.showsCloudItems = NO;
    if (@available(iOS 9.2, *)) {
        mpc.showsItemsWithProtectedAssets = NO;
    }
    mpc.modalPresentationStyle = UIModalPresentationFullScreen;
    objc_setAssociatedObject(mpc, mpcKey, self, OBJC_ASSOCIATION_RETAIN);
    UINavigationController *nav = self.navigationController;
    [nav setNavigationBarHidden:YES animated:NO];
    [nav setViewControllers:@[mpc] animated:NO];
}

#pragma mark - BGM
//选中后调用
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    NSArray *items = mediaItemCollection.items;
    MPMediaItem *songItem = [items objectAtIndex:0];
    NSURL *url = [songItem valueForProperty:MPMediaItemPropertyAssetURL];
    AVAsset *songAsset = [AVAsset assetWithURL:url];
    if (songAsset != nil) {
        [_bgmListener onBGMControllerPlay:songAsset];
    }
}

//点击取消时回调
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [_bgmListener onBGMControllerPlay:nil];
}

// 清空选中状态
- (void)clearSelectStatus {
    _BGMCellPath = nil;
}

#pragma mark -
- (void)loadData:(id _Nullable)sender {
    self.tableView.allowsSelection = NO;
    
    if (!([sender isKindOfClass:[MJRefreshNormalHeader class]] || [sender isKindOfClass:[MJRefreshAutoNormalFooter class]])) {
        [SVProgressHUD show];
    }
    if (sender) {
        if ([sender isKindOfClass:[MJRefreshNormalHeader class]])  {
            _page = 0;
        }
        if ([sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) _page ++;
    }
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"category_id"] = [ToolUtil isEqualToNonNullKong:[_listPrams objectForKey:@"id"]];
    params[@"page"] = @(_page);
    
    [ApiUtil postWithParent:self url:[ApiUtilHeader getMusicList] needHUD:NO params:params.copy success:^(NSInteger code, id  _Nullable response) {
        [self.tableView endAllFreshing];
        NSArray *array = (NSArray *)[response objectForKey:@"data"];
        if (array && array.count) {
            NSString *category_name = [ToolUtil isEqualToNonNull:[self->_listPrams objectForKey:@"category_name"] replace:@"0"];
            NSDictionary *bgmDict = [self loadBGMListWihtArray:array needClear:YES withCategory:category_name];
            [self BGMListLoad:bgmDict wihtOriginalArray:array];
        }
    } fail:^(NSInteger errorCode, NSString * _Nullable errorMsg) {
        [self.tableView endAllFreshing];
        [SVProgressHUD showError:errorMsg];
    }];
}

- (NSDictionary *)loadBGMListWihtArray:(NSArray *_Nullable)infoList needClear:(BOOL)needClear withCategory:(NSString *)category {
    NSMutableDictionary *bgmDict = @{}.mutableCopy;
    if (infoList && infoList.count) {
        for (int i = 0; i < [infoList count]; i++) {
            TCBGMElement* ele = [TCBGMElement new];
            NSString *url_str = [[infoList objectAtIndex:i] objectForKey:@"music_url"];
            if ([url_str hasPrefix:@"group"]) {
                ele.netUrl = [ToolUtil isEqualToNonNull:url_str]? [NSString stringWithFormat:@"%@/%@",IMAGE_JAVA_HOST, url_str]: @"";
            }else {
                ele.netUrl = [ToolUtil isEqualToNonNull:url_str]? [NSString stringWithFormat:@"%@/%@",IMAGE_HOST, url_str]: @"";
            }
            
            ele.music_length = [ToolUtil isEqualToNonNull:[[infoList objectAtIndex:i] objectForKey:@"music_length"] replace:@"0"];
            ele.name = [[infoList objectAtIndex:i] objectForKey:@"music_name"];
            ele.category = [ToolUtil isEqualToNonNullKong:category];
            
            ele.isValid = [NSNumber numberWithBool:false];
            MCDownloadReceipt *receipt = [[MCDownloadManager defaultInstance] downloadReceiptForURL:ele.netUrl];
            if (receipt.state == MCDownloadStateCompleted) {
                ele.isValid = [NSNumber numberWithBool:true];
            }
            
            [bgmDict setObject:ele forKey:ele.netUrl];
        }
    }
    return bgmDict.copy;
}

- (void)BGMListLoad:(NSDictionary*)dict wihtOriginalArray:(NSArray *)array {
    BOOL foundKeyBGMToLoadRemote = NO;
    if(dict){
        NSLog(@"BGM List 加载成功");
        _bgmDict = dict;
        _bgmKeys = [_bgmDict keysSortedByValueUsingComparator:^(TCBGMElement* e1, TCBGMElement* e2){
            return [[e1 name] compare:[e2 name]];
        }];
        for (NSString* url in _bgmKeys) {
            TCBGMElement* ele = [_bgmDict objectForKey:url];
            if([[ele isValid] boolValue]){
                @synchronized (_progressList) {
                    [_progressList setObject :[NSNumber numberWithFloat:1.f] forKey:url];
                }
            }
            // 没有青花瓷时用本地音乐，AppStore审核用
//            NSRange range = [ele.name rangeOfString:@"青花瓷"]; //
//            if (range.location != NSNotFound) {
//                foundKeyBGMToLoadRemote = YES;
//            }
            foundKeyBGMToLoadRemote = YES;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (foundKeyBGMToLoadRemote) {
            self->_useLocalMusic = NO;
            [self.tableView updataFreshFooter:(self.bgmKeys.count && array.count != 10)];
            [self.tableView ly_updataEmptyView:!self.bgmKeys.count];
            self.tableView.mj_footer.hidden = !self.bgmKeys.count;
            
            [self.tableView reloadData];
        }else{
            self->_useLocalMusic = YES;
            [self showMPMediaPickerController];
        }
    });
}

@end
