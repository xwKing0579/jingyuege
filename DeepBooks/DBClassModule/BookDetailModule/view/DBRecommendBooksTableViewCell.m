//
//  DBRecommendBooksTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/2.
//

#import "DBRecommendBooksTableViewCell.h"
#import "DBAllBooksItemView.h"
@interface DBRecommendBooksTableViewCell ()
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) NSArray *viewsArray;

@property (nonatomic, strong) UIView *partingLineView;
@end

@implementation DBRecommendBooksTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.titleTextLabel,self.partingLineView]];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(12);
    }];
    
    [self.partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(6);
    }];
    
    NSMutableArray *viewsArray = [NSMutableArray array];
    self.viewsArray = viewsArray;
    
    CGFloat space = 10;
    CGFloat width = (UIScreen.screenWidth-80)/3;
    CGFloat height = width*5.0/4.0+64;
    CGFloat top = 50;
    
    for (NSInteger index = 0; index < 6; index++) {
        CGFloat left = (width + 30) * (index % 3) + space;
        DBAllBooksItemView *itemView = [[DBAllBooksItemView alloc] init];
        itemView.tag = index;
        [itemView addTapGestureTarget:self action:@selector(clickBookDetailAction:)];
        [self.contentView addSubview:itemView];
        
        [viewsArray addObject:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(left);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            if (index > 2){
                make.top.mas_equalTo(top+height);
               
            }else{
                make.top.mas_equalTo(top);
            }
            if (index == 5) {
                make.bottom.mas_equalTo(-10);
            }
        }];
    }
}

- (void)clickBookDetailAction:(UITapGestureRecognizer *)tap{
    [DBRouter openPageUrl:DBBookDetail params:@{@"bookId":DBSafeString(self.model.bookList[tap.view.tag].book_id)}];
}

- (void)setModel:(DBBookDetailCustomModel *)model{
    _model = model;
    self.titleTextLabel.text = model.name;
    
    for (NSInteger index = 0; index < 6; index++) {
        DBAllBooksItemView *itemView = self.viewsArray[index];
        if (index < model.bookList.count){
            itemView.hidden = NO;
            DBBooksDataModel *item = model.bookList[index];
            itemView.titleTextLabel.text = item.name;
            if (DBColorExtension.userInterfaceStyle) {
                itemView.titleTextLabel.textColor = DBColorExtension.lightGrayColor;
            }else{
                itemView.titleTextLabel.textColor = DBColorExtension.charcoalColor;
            }
            itemView.scoreLabel.text = [NSString stringWithFormat:DBConstantString.ks_pointsSuffix,item.score];
            itemView.pictureImageView.imageObj = item.image;
        }else{
            itemView.hidden = YES;
        }
    }
    
    DBAllBooksItemView *itemView = self.viewsArray.lastObject;
    if (model.bookList.count < 4){
        [itemView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }else{
        CGFloat width = (UIScreen.screenWidth-80)/3;
        CGFloat height = width*5.0/4.0+64;
        [itemView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
    }
    
    if (DBColorExtension.userInterfaceStyle) {
        self.titleTextLabel.textColor = DBColorExtension.lightGrayColor;
    }else{
        self.titleTextLabel.textColor = DBColorExtension.charcoalColor;
    }
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.titleSmallFont;
        _titleTextLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _titleTextLabel;
}

- (UIView *)partingLineView{
    if (!_partingLineView){
        _partingLineView = [[UIView alloc] init];
        _partingLineView.backgroundColor = DBColorExtension.paleGrayColor;
    }
    return _partingLineView;
}
@end
