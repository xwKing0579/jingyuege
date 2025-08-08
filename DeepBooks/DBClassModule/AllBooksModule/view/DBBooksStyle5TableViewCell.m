//
//  DBBooksStyle5TableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/1.
//

#import "DBBooksStyle5TableViewCell.h"
#import "DBAllBooksItemView.h"
#import "DBBooksItemView.h"

@interface DBBooksStyle5TableViewCell ()
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIView *partingLineView;

@property (nonatomic, strong) NSArray *viewsArray;

@property (nonatomic, strong) DBBooksItemView *bookView;

@end

@implementation DBBooksStyle5TableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.titleTextLabel,self.moreButton,self.bookView,self.partingLineView]];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(6);
    }];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.titleTextLabel);
        make.size.mas_equalTo(self.moreButton.size);
    }];
    [self.bookView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(46);
    }];
    
    [self.partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(6);
    }];
    
    NSMutableArray *viewsArray = [NSMutableArray array];
    self.viewsArray = viewsArray;
    for (NSInteger index = 0; index < 4; index++) {
        DBAllBooksItemView *itemView = [[DBAllBooksItemView alloc] init];
        itemView.tag = index+1;
        [itemView addTapGestureTarget:self action:@selector(clickBookDetailAction:)];
        [viewsArray addObject:itemView];
    }
    [self.contentView addSubviews:viewsArray];

    CGFloat width = (UIScreen.screenWidth-60)/4;
    CGFloat height = width*5/4+66;
    [viewsArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:12 leadSpacing:12 tailSpacing:12];
    [viewsArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bookView.mas_bottom).offset(16);
        make.bottom.mas_equalTo(-6);
        make.height.mas_equalTo(height);
    }];
}

- (void)clickBookDetailAction:(UITapGestureRecognizer *)tap{
    [DBRouter openPageUrl:DBBookDetail params:@{@"bookId":DBSafeString(self.model.data[tap.view.tag].book_id)}];
}

- (void)setModel:(DBDataModel *)model{
    _model = model;
    self.titleTextLabel.text = model.name;
    self.bookView.model = model.data.firstObject;
    
    for (NSInteger index = 0; index < 4; index++) {
        DBAllBooksItemView *itemView = self.viewsArray[index];
        if (index + 1 < model.data.count){
            itemView.hidden = NO;
            DBBooksDataModel *item = model.data[index+1];
            itemView.titleTextLabel.text = item.name;
            itemView.authorLabel.text = item.author;
            itemView.scoreLabel.text = [NSString stringWithFormat:@"%@分",item.score];
            itemView.pictureImageView.imageObj = item.image;
        }else{
            itemView.hidden = YES;
        }
    }
}


- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.pingFangSemiboldXLarge;
        _titleTextLabel.textColor = DBColorExtension.blackAltColor;
    }
    return _titleTextLabel;
}

- (UIButton *)moreButton{
    if (!_moreButton){
        _moreButton = [[UIButton alloc] init];
        _moreButton.titleLabel.font = DBFontExtension.bodySmallFont;
        _moreButton.size = CGSizeMake(38, 18);
        _moreButton.enlargedEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"jjPrecisionTrajectory"] forState:UIControlStateNormal];
        [_moreButton setTitleColor:DBColorExtension.inkWashColor forState:UIControlStateNormal];
        [_moreButton setTitlePosition:TitlePositionLeft spacing:2];
        DBWeakSelf
        [_moreButton addTagetHandler:^(id  _Nonnull sender) {
            DBStrongSelfElseReturn
            [DBRouter openPageUrl:DBBookCategory params:@{@"index":@(self.index),@"nameString":DBSafeString(self.model.name),@"category":DBSafeString(self.model.category)}];
        } controlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (UIView *)partingLineView{
    if (!_partingLineView){
        _partingLineView = [[UIView alloc] init];
        _partingLineView.backgroundColor = DBColorExtension.noColor;
    }
    return _partingLineView;
}

- (DBBooksItemView *)bookView{
    if (!_bookView){
        _bookView = [[DBBooksItemView alloc] init];
        _bookView.tag = 0;
        _bookView.backgroundColor = DBColorExtension.diatomColor;
        _bookView.layer.cornerRadius = 12;
        _bookView.layer.masksToBounds = YES;
        [_bookView addTapGestureTarget:self action:@selector(clickBookDetailAction:)];
    }
    return _bookView;
}
@end
