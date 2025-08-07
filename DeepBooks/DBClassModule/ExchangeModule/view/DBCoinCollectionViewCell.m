//
//  DBCoinCollectionViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/1.
//

#import "DBCoinCollectionViewCell.h"
#import "DBCoinControl.h"

@interface DBCoinCollectionViewCell ()
@property (nonatomic, strong) DBCoinControl *coinControl;
@end

@implementation DBCoinCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    [self.contentView addSubview:self.coinControl];
    [self.coinControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(12);
        make.bottom.mas_equalTo(-12);
    }];
}

- (DBCoinControl *)coinControl{
    if (!_coinControl){
        _coinControl = [[DBCoinControl alloc] init];
    }
    return _coinControl;
}

@end
