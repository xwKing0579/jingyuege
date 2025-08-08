//
//  DBBooksStyle8TableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/1.
//

#import "DBBooksStyle8TableViewCell.h"
#import "DBAllBooksItemView.h"

@interface DBBooksStyle8TableViewCell ()
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIView *partingLineView;

@property (nonatomic, strong) NSArray *viewsArray;
@end

@implementation DBBooksStyle8TableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.titleTextLabel,self.moreButton,self.partingLineView]];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(6);
    }];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.titleTextLabel);
        make.size.mas_equalTo(self.moreButton.size);
    }];
    
    [self.partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(6);
    }];
    
    NSMutableArray *viewsArray = [NSMutableArray array];
    self.viewsArray = viewsArray;
    
    CGFloat space = 12;
    CGFloat width = (UIScreen.screenWidth-60)/4;
    CGFloat height = width*5.0/4.0+84;
    CGFloat top = 50;
    
    for (NSInteger index = 0; index < 8; index++) {
        CGFloat left = (width + space) * (index % 4) + space;
        DBAllBooksItemView *itemView = [[DBAllBooksItemView alloc] init];
        itemView.tag = index;
        [itemView addTapGestureTarget:self action:@selector(clickBookDetailAction:)];
        [self.contentView addSubview:itemView];

        [viewsArray addObject:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(left);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            if (index > 3){
                make.top.mas_equalTo(top+height);
                make.bottom.mas_equalTo(-6);
            }else{
                make.top.mas_equalTo(top);
            }
        }];
    }
}

- (void)clickBookDetailAction:(UITapGestureRecognizer *)tap{
    [DBRouter openPageUrl:DBBookDetail params:@{@"bookId":DBSafeString(self.model.data[tap.view.tag].book_id)}];
}

- (void)setModel:(DBDataModel *)model{
    _model = model;
    
    self.titleTextLabel.text = model.name;
    
    for (NSInteger index = 0; index < 8; index++) {
        DBAllBooksItemView *itemView = self.viewsArray[index];
        if (index < model.data.count){
            itemView.hidden = NO;
            DBBooksDataModel *item = model.data[index];
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


@end
