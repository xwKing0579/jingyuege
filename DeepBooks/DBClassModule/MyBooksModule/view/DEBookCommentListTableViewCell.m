//
//  DEBookCommentListTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/2.
//

#import "DEBookCommentListTableViewCell.h"
#import "DBBookCommentView.h"

@interface DEBookCommentListTableViewCell ()
@property (nonatomic, strong) DBBookCommentView *commentView;
@end

@implementation DEBookCommentListTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubview:self.commentView];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
}

- (void)setModel:(DBBookCommentModel *)model{
    _model = model;
    self.commentView.model = model;
}

- (void)setBookName:(NSString *)bookName{
    _bookName = bookName;
    self.commentView.bookName = self.bookName;
}

- (DBBookCommentView *)commentView{
    if (!_commentView){
        _commentView = [[DBBookCommentView alloc] init];
    }
    return _commentView;
}

@end
