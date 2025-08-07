//
//  DBPageScrollCollectionViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/5.
//

#import "DBPageScrollCollectionViewCell.h"
#import "DBReadBookView.h"
#import "DBReadBookSetting.h"

@interface DBPageScrollCollectionViewCell ()
@property (nonatomic, strong) DBBaseLabel *chapterNameLabel;
@property (nonatomic, strong) DBReadBookView *readBookView;
@end

@implementation DBPageScrollCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        self.backgroundColor = DBColorExtension.noColor;
        self.contentView.backgroundColor = DBColorExtension.noColor;
        [self setUpSubViews];
    }
    return self;
}

- (void)setModel:(DBPageIGModel *)model{
    _model = model;
    
    if (model.content){
        self.readBookView.hidden = NO;
        self.chapterNameLabel.hidden = YES;
        self.readBookView.attributeString = model.content;
    }else{
        self.readBookView.hidden = YES;
        self.chapterNameLabel.hidden = NO;
        self.chapterNameLabel.text = model.title;
    }
}

- (void)clickReloadReaderAction{
    [UIScreen.currentViewController dynamicAllusionTomethod:@"getBookContentDataSource"];
}

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.readBookView,self.chapterNameLabel]];
    [self.readBookView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.bottom.mas_equalTo(0);
    }];
    [self.chapterNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(16);
        make.top.mas_equalTo(10);
    }];
}

- (DBReadBookView *)readBookView{
    if (!_readBookView){
        _readBookView = [[DBReadBookView alloc] init];
        _readBookView.backgroundColor = DBColorExtension.noColor;
    }
    return _readBookView;
}

- (DBBaseLabel *)chapterNameLabel{
    if (!_chapterNameLabel){
        _chapterNameLabel = [[DBBaseLabel alloc] init];
        _chapterNameLabel.font = [UIFont systemFontOfSize:24];
        _chapterNameLabel.textColor = DBColorExtension.onyxColor;
        _chapterNameLabel.numberOfLines = 2;
    }
    return _chapterNameLabel;
}

@end
