// Copyright (c) 2019 Tencent. All rights reserved.

#import "UGCKitBGMCell.h"
#import "UGCKitBGMProgressView.h"

@implementation UGCKitBGMCell
{
    CGFloat _progress;
    UGCKitBGMProgressView *_progressView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.downLoadBtn setTitle:self.downloadText forState:UIControlStateNormal];
}

- (void)setDownloadProgress:(CGFloat)progress {
    UIImage *image = self.progressButtonBackground;

    if (_progressView == nil) {
        _progressView = [[UGCKitBGMProgressView alloc] initWithFrame:_downLoadBtn.bounds bgImage:self.progressButtonBackground];
        _progressView.label.text = self.downloadingText;
        _progressView.label.textColor = [UIColor whiteColor];
        _progressView.backgroundColor = [UIColor clearColor];
        _progressView.progressBackgroundColor = [UIColor colorWithRed:0.21 green:0.22 blue:0.27 alpha:1.00];
        _progressView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_progressView];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_progressView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY 
                                                                    multiplier:1
                                                                      constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_progressView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_downLoadBtn
                                                                     attribute:NSLayoutAttributeHeight 
                                                                    multiplier:1
                                                                      constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_progressView
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1
                                                                      constant:-8]];
    }
    _progress = progress;
    _progressView.progress = progress;
    if (progress == 1.0) {
        [self.downLoadBtn setTitle:self.applyText forState:UIControlStateNormal];
        [self.downLoadBtn setBackgroundImage:image forState:UIControlStateNormal];
        _downLoadBtn.hidden = NO;
        _progressView.hidden = YES;
    } else {
        [self.downLoadBtn setTitle:self.downloadText forState:UIControlStateNormal];
        [self.downLoadBtn setBackgroundImage:self.downloadButtonBackground forState:UIControlStateNormal];
        _progressView.hidden = NO;
    }
}

- (void)setDownloadUrlStr:(NSString *)downloadUrlStr {
    _downloadUrlStr = downloadUrlStr;
    
    MCDownloadReceipt *receipt = [[MCDownloadManager defaultInstance] downloadReceiptForURL:_downloadUrlStr];
    
    [self setDownloadProgress:receipt.progress.fractionCompleted];
    
    if (receipt.state == MCDownloadStateCompleted) {
        [self setCompleteBtnUIs];
    }else {
        [self setDefaultBtnUIs];
    }
    
    receipt.progressBlock = ^(NSProgress * _Nonnull downloadProgress, MCDownloadReceipt * _Nonnull receipts) {
        if ([receipts.url isEqualToString:self.downloadUrlStr]) {
            self.downLoadBtn.hidden = YES;
            self.progressView.hidden = NO;
            [self setDownloadProgress:receipts.progress.fractionCompleted];
        }
    };
    
    receipt.successBlock = ^(NSURLRequest * _Nullablerequest, NSHTTPURLResponse * _Nullableresponse, NSURL * _NonnullfilePath) {
        [self setCompleteBtnUIs];
    };
    
    receipt.failureBlock = ^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response,  NSError * _Nonnull error) {
        [self setDefaultBtnUIs];
    };
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self setDefaultBtnUIs];
}

- (void)setDefaultBtnUIs {
    self.downLoadBtn.hidden = NO;
    self.progressView.hidden = YES;
    
    [self.downLoadBtn setTitle:self.downloadText forState:UIControlStateNormal];
    [self.downLoadBtn setBackgroundImage: self.downloadButtonBackground forState:UIControlStateNormal];
}

- (void)setCompleteBtnUIs {
    self.downLoadBtn.hidden = NO;
    self.progressView.hidden = YES;
    
    [self.downLoadBtn setTitle:self.applyText forState:UIControlStateNormal];
    [self.downLoadBtn setBackgroundImage:self.progressButtonBackground forState:UIControlStateNormal];
}

- (void)setProgressUIs {
    
}

- (IBAction)download:(id)sender {
//    [self.delegate onBGMDownLoad:self];
//    [_downLoadBtn setTitle:self.downloadingText forState:UIControlStateNormal];
//    _downLoadBtn.titleLabel.alpha = 0.5;
    if (self.downloadUrlStr && self.downloadUrlStr.length > 0) {
        MCDownloadReceipt *receipt = [[MCDownloadManager defaultInstance] downloadReceiptForURL:self.downloadUrlStr];
        
        if (receipt.state == MCDownloadStateDownloading) {
            [self setDefaultBtnUIs];
            [[MCDownloadManager defaultInstance] suspendWithDownloadReceipt:receipt];
        }else if (receipt.state == MCDownloadStateCompleted) {
            [self setCompleteBtnUIs];
            if ([self.delegate respondsToSelector:@selector(onBGMDownLoad:)]) {
                [self.delegate onBGMDownLoad:self];
            }
        }else {
            [self setDefaultBtnUIs];
            [self download];
        }
    }
    
}

- (void)download {
    [[MCDownloadManager defaultInstance] downloadFileWithURL:self.downloadUrlStr
                                                    progress:^(NSProgress * _Nonnull downloadProgress, MCDownloadReceipt *receipt) {
        if ([receipt.url isEqualToString:self.downloadUrlStr]) {
            self.downLoadBtn.hidden = YES;
            self.progressView.hidden = NO;
            [self setDownloadProgress:receipt.progress.fractionCompleted];
        }
    } destination:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSURL * _Nonnull filePath) {
        [self setCompleteBtnUIs];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        [self setDefaultBtnUIs];
    }];
}

@end
