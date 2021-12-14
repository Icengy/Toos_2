//
//  AMCourseNewViewController.m
//  ArtMedia2
//
//  Created by icnengy on 2020/10/10.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "AMCourseNewViewController.h"
#import "AMCourseAddChaptersViewController.h"
#import "ClassDetailViewController.h"
#import <RSKImageCropper/RSKImageCropper.h>

#import "AMCourseCoverCell.h"
#import "AMCourseAddCell.h"
#import "AMCourseEditCell.h"
#import "AMDialogView.h"

#import "AMCourseModel.h"

@interface AMCourseNewViewController () <UITableViewDelegate, UITableViewDataSource, AMCourseEditDelegate , RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource>

@property (weak, nonatomic) IBOutlet BaseTableView *tableView;
@property (weak, nonatomic) IBOutlet AMButton *confirmBtn;

@end

@implementation AMCourseNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _confirmBtn.titleLabel.font = [UIFont addHanSanSC:15.0f fontType:0];
    [_confirmBtn setTitle:self.isCourseEdit?@"保存修改":@"下一步" forState:UIControlStateNormal];
    [_confirmBtn setBackgroundImage:[UIImage imageWithColor:Color_Black] forState:UIControlStateNormal];
    [_confirmBtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xCCCCCC)] forState:UIControlStateDisabled];
    
    _tableView.bgColorStyle = AMBaseTableViewBackgroundColorStyleGray;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMCourseCoverCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMCourseCoverCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMCourseAddCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMCourseAddCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AMCourseEditCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AMCourseEditCell class])];
    
    if (!self.model) {
        self.model = [AMCourseModel new];
        self.model.isFree = @"1";
        self.model.coursePrice = @"10";
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = self.isCourseEdit?@"编辑课程信息":@"创建直播课";
    
    [self uploadBottomState];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        AMCourseEditCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMCourseEditCell class]) forIndexPath:indexPath];
        
        cell.delegate = self;
        cell.model = self.model;
        return cell;
    }else {
        if (self.model && [ToolUtil isEqualToNonNull:self.model.coverImage]) {
            AMCourseCoverCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMCourseCoverCell class]) forIndexPath:indexPath];
            
            cell.needCornerRadius = YES;
            cell.needMargin = YES;
            
            cell.model = self.model;
            return cell;
        }else {
            AMCourseAddCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AMCourseAddCell class]) forIndexPath:indexPath];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section?CGFLOAT_MIN:10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section) return;
    /// 选择图片编辑
    [ToolUtil FK_showInController:self photoOfMax:1 withType:AMImageSelectedMeidaTypePhoto uploadType:5 completion:^(NSArray * _Nullable images) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = images.lastObject;
            RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCustom];
            imageCropVC.avoidEmptySpaceAroundImage = YES;

            imageCropVC.delegate = self;
            imageCropVC.dataSource = self;
            [self.navigationController pushViewController:imageCropVC animated:YES];
        });
    }];
}

#pragma mark - AMCourseEditDelegate
- (void)editCell:(AMCourseEditCell *)editCell didSeletedForCourseTitle:(NSString *)title {
    self.model.courseTitle = title;
    [self uploadBottomState];
}
- (void)editCell:(AMCourseEditCell *)editCell didSeletedForCourseDesc:(NSString *)desc {
    self.model.course_description = desc;
    [self uploadBottomState];
}
- (void)editCell:(AMCourseEditCell *)editCell didSeletedForCourseFree:(BOOL)isFree {
    self.model.isFree = isFree?@"1":@"2";
    [self uploadBottomState];
}
- (void)editCell:(AMCourseEditCell *)editCell didSeletedForCoursePrice:(NSString *)price {
    self.model.coursePrice = price;
    [self uploadBottomState];
}

#pragma mark -
- (void)uploadCoverImg:(NSArray *)images {
    self.model.coverImage = images.lastObject;
    [self.tableView reloadData];
    
    [self uploadBottomState];
}

- (void)uploadBottomState {
    BOOL enable = NO;
    if ([ToolUtil isEqualToNonNull:self.model.coverImage] &&
        [ToolUtil isEqualToNonNull:self.model.courseTitle] &&
        ((self.model.isFree.integerValue == 2 && [ToolUtil isEqualToNonNull:self.model.coursePrice]) || self.model.isFree.integerValue == 1)) {
        enable = YES;
    }
    self.confirmBtn.enabled = enable;
}

#pragma mark -
- (IBAction)clickToConfirm:(id)sender {
    if (self.isCourseEdit) {/// 保存修改
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"courseId"] = self.model.courseId;
        params[@"courseTitle"] = self.model.courseTitle;
        params[@"description"] = self.model.course_description;
        params[@"coverImage"] = self.model.coverImage;
        params[@"isFree"] = self.model.isFree;
        params[@"coursePrice"] = self.model.coursePrice;
        [ApiUtil postWithParent:self url:[ApiUtilHeader updateLiveCourseListOfCurrentTeacher] params:params.copy success:^(NSInteger code, id  _Nullable response) {
            [SVProgressHUD showSuccess:response[@"msg"] completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } fail:nil];
        
    }else {/// 下一步
        NSMutableDictionary *params = @{}.mutableCopy;
        params[@"courseTitle"] = self.model.courseTitle;
        params[@"description"] = self.model.course_description;
        params[@"coverImage"] = self.model.coverImage;
        params[@"isFree"] = self.model.isFree;
        params[@"coursePrice"] = self.model.coursePrice;
        [ApiUtil postWithParent:self url:[ApiUtilHeader addLiveCourse] params:params.copy success:^(NSInteger code, id  _Nullable response) {
            NSLog(@"%@",response);
            if ([ToolUtil isEqualToNonNull:[response objectForKey:@"data"]]) {
//                AMCourseAddChaptersViewController *addChaptersVC = [[AMCourseAddChaptersViewController alloc] init];
//                self.model.courseId = [response objectForKey:@"data"];
//                addChaptersVC.model = self.model;
//                [self.navigationController pushViewController:addChaptersVC animated:YES];
                
                ClassDetailViewController *vc = [[ClassDetailViewController alloc] init];
                vc.courseId = [response objectForKey:@"data"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else {
                [SVProgressHUD showError:@"创建失败，请重试"];
            }

        } fail:nil];
    }
}
#pragma mark - RSKImageCropViewControllerDelegate
// Crop image has been canceled.
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image has been cropped. Additionally provides a rotation angle used to produce image.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
                  rotationAngle:(CGFloat)rotationAngle
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [ToolUtil uploadImgs:@[croppedImage] uploadType:5 completion:^(NSArray * _Nullable imageURls) {
//            [self uploadCoverImg:imageURls];
//        }];
        [ToolUtil JAVA_uploadImgs:@[croppedImage] uploadType:5 completion:^(NSArray * _Nullable imageURls) {
            [self uploadCoverImg:imageURls];
        }];
        
    });
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image will be cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                  willCropImage:(UIImage *)originalImage
{
    // Use when `applyMaskToCroppedImage` set to YES.
    [SVProgressHUD show];
}
// Returns a custom rect for the mask.
- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller
{
    CGSize aspectRatio = CGSizeMake(16.0f, 9.0f);
    
    CGFloat viewWidth = CGRectGetWidth(controller.view.frame);
    CGFloat viewHeight = CGRectGetHeight(controller.view.frame);
    
    CGFloat maskWidth;
    if ([controller isPortraitInterfaceOrientation]) {
        maskWidth = viewWidth;
    } else {
        maskWidth = viewHeight;
    }
    
    CGFloat maskHeight;
    do {
        maskHeight = maskWidth * aspectRatio.height / aspectRatio.width;
        maskWidth -= 1.0f;
    } while (maskHeight != floor(maskHeight));
    maskWidth += 1.0f;
    
    CGSize maskSize = CGSizeMake(maskWidth, maskHeight);
    
    CGRect maskRect = CGRectMake((viewWidth - maskSize.width) * 0.5f,
                                 (viewHeight - maskSize.height) * 0.5f,
                                 maskSize.width,
                                 maskSize.height);
    
    return maskRect;
}

// Returns a custom path for the mask.
- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller
{
    CGRect rect = controller.maskRect;
    CGPoint point1 = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPoint point2 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPoint point3 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGPoint point4 = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    
    UIBezierPath *rectangle = [UIBezierPath bezierPath];
    [rectangle moveToPoint:point1];
    [rectangle addLineToPoint:point2];
    [rectangle addLineToPoint:point3];
    [rectangle addLineToPoint:point4];
    [rectangle closePath];
    
    return rectangle;
}

// Returns a custom rect in which the image can be moved.
- (CGRect)imageCropViewControllerCustomMovementRect:(RSKImageCropViewController *)controller
{
    if (controller.rotationAngle == 0) {
        return controller.maskRect;
    } else {
        CGRect maskRect = controller.maskRect;
        CGFloat rotationAngle = controller.rotationAngle;
        
        CGRect movementRect = CGRectZero;
        
        movementRect.size.width = CGRectGetWidth(maskRect) * fabs(cos(rotationAngle)) + CGRectGetHeight(maskRect) * fabs(sin(rotationAngle));
        movementRect.size.height = CGRectGetHeight(maskRect) * fabs(cos(rotationAngle)) + CGRectGetWidth(maskRect) * fabs(sin(rotationAngle));
        
        movementRect.origin.x = CGRectGetMinX(maskRect) + (CGRectGetWidth(maskRect) - CGRectGetWidth(movementRect)) * 0.5f;
        movementRect.origin.y = CGRectGetMinY(maskRect) + (CGRectGetHeight(maskRect) - CGRectGetHeight(movementRect)) * 0.5f;
        
        movementRect.origin.x = floor(CGRectGetMinX(movementRect));
        movementRect.origin.y = floor(CGRectGetMinY(movementRect));
        movementRect = CGRectIntegral(movementRect);
        
        return movementRect;
    }
}
@end
