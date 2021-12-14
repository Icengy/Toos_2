//
//  TOCropRatioSelectView.h
//  ArtMedia2
//
//  Created by icnengy on 2020/10/29.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "BasePopView.h"

#import "TOCropViewConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface TOCropRatioSelectView : BasePopView

@property (nonatomic, copy) void(^selectedRatioPresetBlock)(TOCropViewControllerAspectRatioPreset ratioPreset);
@property (nonatomic ,assign) TOCropViewControllerAspectRatioPreset ratioPreset;

@end

NS_ASSUME_NONNULL_END
