//
//  DBCoinPanView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/1.
//

#import "DBCoinPanView.h"
#import "DBCoinCollectionViewCell.h"

static NSString *identifierCollectCell = @"DBCoinCollectionViewCell";
@interface DBCoinPanView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) UIButton *orderRecordButton;
@property (nonatomic, strong) UICollectionView *myBookCollectionView;
@property (nonatomic, strong) UIButton *orderButton;

@end

@implementation DBCoinPanView

- (instancetype)init{
    if (self = [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.backgroundColor = DBColorExtension.whiteColor;
    [self addSubviews:@[self.titleTextLabel,self.orderRecordButton,self.myBookCollectionView,self.orderButton]];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.top.mas_equalTo(32);
    }];
    [self.orderRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-24);
        make.centerY.mas_equalTo(self.titleTextLabel);
        make.size.mas_equalTo(self.orderRecordButton.size);
    }];
    [self.myBookCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(71);
        make.height.mas_equalTo(247+24);
    }];
    [self.orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.myBookCollectionView.mas_bottom).offset(16);
        make.height.mas_equalTo(40);
    }];
}

- (void)clickOrderAction{
    
}

- (void)clickOrderRecordAction{
    
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DBCoinCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCollectCell forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(172+24, 247+24);
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.pingFangMediumXLarge;
        _titleTextLabel.textColor = DBColorExtension.blackColor;
        _titleTextLabel.text = @"购买金币";
    }
    return _titleTextLabel;
}

- (UIButton *)orderRecordButton{
    if (!_orderRecordButton){
        _orderRecordButton = [[UIButton alloc] init];
        _orderRecordButton.size = CGSizeMake(102, 30);
        _orderRecordButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        [_orderRecordButton setTitle:@"金币使用记录" forState:UIControlStateNormal];
        [_orderRecordButton setTitleColor:DBColorExtension.inkWashColor forState:UIControlStateNormal];
        [_orderRecordButton setImage:[UIImage imageNamed:@"arrow_42"] forState:UIControlStateNormal];
        [_orderRecordButton addTarget:self action:@selector(clickOrderRecordAction) forControlEvents:UIControlEventTouchUpInside];
        [_orderRecordButton setTitlePosition:TitlePositionLeft spacing:2];
    }
    return _orderRecordButton;
}

- (UICollectionView *)myBookCollectionView{
    if (!_myBookCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 4, 0, 4);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _myBookCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _myBookCollectionView.delegate = self;
        _myBookCollectionView.dataSource = self;
        _myBookCollectionView.showsVerticalScrollIndicator = NO;
        _myBookCollectionView.showsHorizontalScrollIndicator = NO;
        _myBookCollectionView.backgroundColor = DBColorExtension.whiteColor;
        [_myBookCollectionView registerClass:NSClassFromString(identifierCollectCell) forCellWithReuseIdentifier:identifierCollectCell];
    }
    return _myBookCollectionView;
}

- (UIButton *)orderButton{
    if (!_orderButton){
        _orderButton = [[UIButton alloc] init];
        _orderButton.layer.cornerRadius = 20;
        _orderButton.layer.masksToBounds = YES;
        _orderButton.titleLabel.font = DBFontExtension.pingFangMediumLarge;
        _orderButton.backgroundColor = DBColorExtension.sunsetOrangeColor;
        [_orderButton setTitle:@"提交订单" forState:UIControlStateNormal];
        [_orderButton setTitleColor:DBColorExtension.whiteColor forState:UIControlStateNormal];
        [_orderButton addTarget:self action:@selector(clickOrderAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderButton;
}

- (PanModalHeight)longFormHeight{
    return PanModalHeightMake(PanModalHeightTypeContent, 426);
}

- (CGFloat)cornerRadius{
    return 16;
}

- (HWBackgroundConfig *)backgroundConfig{
    HWBackgroundConfig *config = [HWBackgroundConfig new];
    config.backgroundAlpha = 0.6;
    config.blurTintColor = DBColorExtension.blackColor;
    return config;
}

- (BOOL)showDragIndicator{
    return NO;
}

- (BOOL)allowsDragToDismiss{
    return YES;
}

- (BOOL)allowsPullDownWhenShortState{
    return NO;
}

- (BOOL)allowScreenEdgeInteractive{
    return NO;
}

- (BOOL)allowsTouchEventsPassingThroughTransitionView{
    return NO;
}


@end
