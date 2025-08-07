//
//  DBBooksStyle11TableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/21.
//

#import "DBBooksStyle11TableViewCell.h"
#import "DBBooksItemView.h"

@interface DBBooksStyle11TableViewCell ()
@property (nonatomic, strong) DBBooksItemView *bookView;
@end

@implementation DBBooksStyle11TableViewCell

- (void)setUpSubViews{
    [self.contentView addSubview:self.bookView];
    [self.bookView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
    }];
}

- (void)setModel:(DBBooksDataModel *)model{
    _model = model;
    self.bookView.model = model;
}

- (DBBooksItemView *)bookView{
    if (!_bookView){
        _bookView = [[DBBooksItemView alloc] init];
    }
    return _bookView;
}

@end
