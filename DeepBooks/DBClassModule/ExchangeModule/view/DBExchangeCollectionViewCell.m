//
//  DBExchangeCollectionViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/1.
//

#import "DBExchangeCollectionViewCell.h"
#import "DBExchangeControl.h"
@interface DBExchangeCollectionViewCell ()
@property (nonatomic, strong) DBExchangeControl *exchangeControl;
@end

@implementation DBExchangeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    [self.contentView addSubview:self.exchangeControl];
    [self.exchangeControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(12);
        make.bottom.mas_equalTo(-12);
    }];
}

- (DBExchangeControl *)exchangeControl{
    if (!_exchangeControl){
        _exchangeControl = [[DBExchangeControl alloc] init];
    }
    return _exchangeControl;
}

@end
