//
//  DBReadBookTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/10.
//

#import "DBReadBookTableViewCell.h"
#import "DBReadBookView.h"
@interface DBReadBookTableViewCell ()
@property (nonatomic, strong) DBReadBookView *readBookView;

@end

@implementation DBReadBookTableViewCell


- (void)setUpSubViews{
    [self.contentView addSubview:self.readBookView];
    [self.readBookView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
    }];
}


- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
}

- (void)setContent:(NSAttributedString *)content{
    _content = content;
    self.readBookView.attributeString = content;
}

- (DBReadBookView *)readBookView{
    if (!_readBookView){
        _readBookView = [[DBReadBookView alloc] init];
        _readBookView.backgroundColor = DBColorExtension.noColor;
    }
    return _readBookView;
}


@end
