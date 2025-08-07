//
//  DBBookSocreTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/20.
//

#import "DBBookSocreTableViewCell.h"
#import "DBStarRating.h"
#import "DBBookCommentModel.h"
#import "DBBookCommentView.h"
@interface DBBookSocreTableViewCell ()
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) DBStarRating *scoreView;
@property (nonatomic, strong) DBBaseLabel *countLabel;

@property (nonatomic, strong) UIView *commentView;
@property (nonatomic, strong) UIView *partingLineView;
@end

@implementation DBBookSocreTableViewCell

- (void)setUpSubViews{
    [self.contentView addSubviews:@[self.titleTextLabel,self.commentButton,self.bottomView,self.commentView,self.partingLineView]];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(16);
    }];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.titleTextLabel);
        make.size.mas_equalTo(self.commentButton.size);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.titleTextLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(50);
    }];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.bottomView.mas_bottom).offset(10);
    }];
    [self.partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.commentView.mas_bottom).offset(5);
        make.height.mas_equalTo(6);
    }];
}

- (void)clickCommentAction{
    [self commentPanViewShow:0];
}

- (void)commentPanViewShow:(CGFloat)score{
    if (!DBCommonConfig.isLogin) {
        [DBCommonConfig toLogin];
        return;
    }
    if (self.commentInputBlock) self.commentInputBlock(score);
}

- (void)clickAllCommentAction{
    if (!DBCommonConfig.isLogin) {
        [DBCommonConfig toLogin];
        return;
    }
    if (self.commentListBlock) self.commentListBlock();
}

- (void)setTotal:(NSInteger)total{
    _total = total;
}

- (void)setBookName:(NSString *)bookName{
    _bookName = bookName;
}

- (void)setCommentList:(NSArray *)commentList{
    _commentList = commentList;
    
    [self.commentView removeAllSubView];

    if (commentList.count){
        UIView *lastView;
        for (DBBookCommentModel *model in commentList) {
            DBBookCommentView *commentView = [[DBBookCommentView alloc] init];
            commentView.model = model;
            commentView.bookName = self.bookName;
            [self.commentView addSubview:commentView];
            [commentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                if (lastView){
                    make.top.mas_equalTo(lastView.mas_bottom);
                }else{
                    make.top.mas_equalTo(0);
                }
            }];
            lastView = commentView;
        }
        
        [self.commentView addSubview:self.countLabel];
        self.countLabel.text = [NSString stringWithFormat:@"查看全部书评(%ld)",self.total];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(lastView.mas_bottom).offset(10);
            make.bottom.mas_equalTo(-10);
        }];
        [self.countLabel addTapGestureTarget:self action:@selector(clickAllCommentAction)];
    }
    
    [self setUserInterfaceStyleOrLight];
}

- (void)setUserInterfaceStyleOrLight{
    if (DBColorExtension.userInterfaceStyle) {
        self.bottomView.backgroundColor = DBColorExtension.jetBlackColor;
    }else{
        self.bottomView.backgroundColor = DBColorExtension.paleGrayAltColor;
    }
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.pingFangMediumXLarge;
        _titleTextLabel.textColor = DBColorExtension.charcoalColor;
        _titleTextLabel.text = @"书评";
    }
    return _titleTextLabel;
}

- (UIButton *)commentButton{
    if (!_commentButton){
        _commentButton = [[UIButton alloc] init];
        _commentButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        _commentButton.size = CGSizeMake(80, 30);
        [_commentButton setTitle:@"写书评" forState:UIControlStateNormal];
        [_commentButton setTitleColor:DBColorExtension.mediumGrayColor forState:UIControlStateNormal];
        [_commentButton setImage:[UIImage imageNamed:@"arrowIcon"] forState:UIControlStateNormal];
        [_commentButton setTitlePosition:TitlePositionLeft spacing:4];
        [_commentButton addTarget:self action:@selector(clickCommentAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
}

- (UIView *)bottomView{
    if (!_bottomView){
        _bottomView = [[UIView alloc] init];
        _bottomView.layer.cornerRadius = 4;
        _bottomView.layer.masksToBounds = YES;
        _bottomView.backgroundColor = DBColorExtension.paleGrayAltColor;
        
        DBBaseLabel *titleLabel = [[DBBaseLabel alloc] init];
        titleLabel.font = DBFontExtension.bodySixTenFont;
        titleLabel.textColor = DBColorExtension.mediumGrayColor;
        titleLabel.text = @"轻点评分";
        [_bottomView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.centerY.mas_equalTo(0);
        }];
        
        [_bottomView addSubview:self.scoreView];
        [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(self.scoreView.size);
        }];
    }
    return _bottomView;
}

- (UIView *)commentView{
    if (!_commentView){
        _commentView = [[UIView alloc] init];
    }
    return _commentView;
}

- (DBStarRating *)scoreView{
    if (!_scoreView){
        CGFloat width = 33;
        _scoreView = [[DBStarRating alloc] initWithFrame:CGRectMake(0, 0, width*5+6*4, width)];
        _scoreView.spacing = 6;
        _scoreView.checkedImage = [UIImage imageNamed:@"scoreRed_sel"];
        _scoreView.uncheckedImage = [UIImage imageNamed:@"scoreRed_unsel"];
        _scoreView.minimumScore = 0.0;
        _scoreView.maximumScore = 5.0;
        _scoreView.type = RatingTypeWhole;
        _scoreView.touchEnabled = YES;
        
        DBWeakSelf
        _scoreView.currentScoreChangeBlock = ^(CGFloat value) {
            DBStrongSelfElseReturn
            if (value == 0) return;
            [self commentPanViewShow:value];
        };
    }
    return _scoreView;
}

- (DBBaseLabel *)countLabel{
    if (!_countLabel){
        _countLabel = [[DBBaseLabel alloc] init];
        _countLabel.font = DBFontExtension.bodySmallFont;
        _countLabel.textColor = DBColorExtension.charcoalColor;
        _countLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _countLabel;
}

- (UIView *)partingLineView{
    if (!_partingLineView){
        _partingLineView = [[UIView alloc] init];
        _partingLineView.backgroundColor = DBColorExtension.paleGrayColor;
    }
    return _partingLineView;
}
@end
