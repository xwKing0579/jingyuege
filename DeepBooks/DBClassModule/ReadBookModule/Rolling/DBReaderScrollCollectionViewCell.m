//
//  DBReaderScrollCollectionViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/19.
//

#import "DBReaderScrollCollectionViewCell.h"
#import "DBReadBookView.h"
#import "DBReadBookSetting.h"

@interface DBReaderScrollCollectionViewCell ()
@property (nonatomic, strong) DBBaseLabel *chapterNameLabel;
@property (nonatomic, strong) DBReadBookView *readBookView;
@end

@implementation DBReaderScrollCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        self.backgroundColor = DBColorExtension.noColor;
        self.contentView.backgroundColor = DBColorExtension.noColor;
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    self.clipsToBounds = YES;
    [self.contentView addSubviews:@[self.readBookView]];

    [self.readBookView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.bottom.mas_equalTo(0);
    }];
}

- (void)setModel:(DBReaderScrollModel *)model{
    _model = model;
    if (model.content) {
        self.readBookView.attributeString = model.content;
    }else{
        
    }
}

- (void)setAttri:(NSAttributedString *)attri{
    _attri = attri;
    self.readBookView.attributeString = attri;
}

- (void)clickReloadReaderAction{
    [UIScreen.currentViewController dynamicAllusionTomethod:@"getBookContentDataSource"];
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
        _chapterNameLabel.font = [UIFont systemFontOfSize:20];
        _chapterNameLabel.textColor = DBColorExtension.onyxColor;
        _chapterNameLabel.numberOfLines = 0;
    }
    return _chapterNameLabel;
}
@end
