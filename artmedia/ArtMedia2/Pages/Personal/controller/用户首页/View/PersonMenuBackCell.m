//
//  PersonMenuBackCell.m
//  ArtMedia2
//
//  Created by LY on 2020/10/16.
//  Copyright © 2020 翁磊. All rights reserved.
//

#import "PersonMenuBackCell.h"

#import "PersonMenuCollectionCell.h"
@interface PersonMenuBackCell ()<UICollectionViewDelegate , UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray *listData;
@end
@implementation PersonMenuBackCell
- (NSMutableArray *)listData{
    if (!_listData) {
        _listData = [[NSMutableArray alloc] init];
        _listData = [NSMutableArray arrayWithArray:@[
            @{
                @"title":@"权属证书",
                @"imageName":@"mine_权属证书"
            },
            @{
                @"title":@"我的学习",
                @"imageName":@"mine_我的学习"
            },
            @{
                @"title":@"我的艺币",
                @"imageName":@"mine_我的易币"
            },
            @{
                @"title":@"我的邀请",
                @"imageName":@"mine_邀请"
            },
            @{
                @"title":@"地址管理",
                @"imageName":@"mine_地址管理"
            },
            @{
                @"title":@"帮助中心",
                @"imageName":@"mine_帮助中心"
            },
        ]
                     ];
    }
    return _listData;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = YES;
    self.contentView.layer.cornerRadius = 10;
    self.contentView.layer.masksToBounds = YES;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((K_Width - 30)/3, 70);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    self.collectionView.collectionViewLayout = flowLayout;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PersonMenuCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([PersonMenuCollectionCell class])];
    
    [self.collectionView reloadData];
}
- (void)setFrame:(CGRect)frame {
    frame.origin.x += 15.0f;
    frame.size.width -= 30.0f;
    [super setFrame:frame];
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.listData[indexPath.row];
    PersonMenuCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PersonMenuCollectionCell class]) forIndexPath:indexPath];
    cell.headImage.image = [UIImage imageNamed:dic[@"imageName"]];
    cell.nameLabel.text = dic[@"title"];
    return cell;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listData.count;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(PersonMenuBackCellCollectionDidSelect:collectionView:indexPath:)]) {
        [self.delegate PersonMenuBackCellCollectionDidSelect:self collectionView:collectionView indexPath:indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
