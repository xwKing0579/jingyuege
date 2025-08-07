//
//  DBBookCommentView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/31.
//

#import "DBBookCommentView.h"
#import "DBStarRating.h"
#import "DBBookCommentPanView.h"
@interface DBBookCommentView ()
@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) DBBaseLabel *dateLabel;
@property (nonatomic, strong) DBStarRating *scoreView;
@property (nonatomic, strong) UIButton *blockButton;
@property (nonatomic, strong) UIButton *reportButton;
@property (nonatomic, strong) UIButton *favButton;
@property (nonatomic, strong) UIButton *commetnButton;
@property (nonatomic, strong) UIView *favView;
@property (nonatomic, strong) UIView *replyView;
@end

@implementation DBBookCommentView

- (instancetype)init{
    if (self == [super init]){
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{
    [self addSubviews:@[self.pictureImageView,self.titleTextLabel,self.contentTextLabel,self.dateLabel,self.scoreView,self.blockButton,self.reportButton,self.favButton,self.commetnButton,self.favView,self.replyView]];
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.width.height.mas_equalTo(24);
    }];
    [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pictureImageView.mas_right).offset(8);
        make.centerY.mas_equalTo(self.pictureImageView);
    }];
    [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleTextLabel);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(self.titleTextLabel.mas_bottom).offset(6);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleTextLabel);
        make.top.mas_equalTo(self.contentTextLabel.mas_bottom).offset(6);
    }];
    [self.scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-0);
        make.centerY.mas_equalTo(self.pictureImageView);
        make.size.mas_equalTo(self.scoreView.size);
    }];
    [self.blockButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dateLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.dateLabel);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(26);
    }];
    [self.reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.blockButton.mas_right);
        make.centerY.mas_equalTo(self.dateLabel);
        make.width.mas_equalTo(46);
        make.height.mas_equalTo(26);
    }];
    [self.commetnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.dateLabel);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(26);
    }];
    [self.favButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.commetnButton.mas_left);
        make.centerY.mas_equalTo(self.dateLabel);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(26);
    }];
    [self.favView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dateLabel);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.dateLabel.mas_bottom).offset(10);
    }];
    [self.replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.favView);
        make.top.mas_equalTo(self.favView.mas_bottom);
        make.bottom.mas_equalTo(-5);
    }];
}

- (void)setModel:(DBBookCommentModel *)model{
    _model = model;
    self.pictureImageView.imageObj = model.avatar;
    self.titleTextLabel.text = model.nick;
    self.contentTextLabel.text = model.content;
    self.dateLabel.text = model.created_at.timeToDate.dateToTimeString;
    self.scoreView.currentScore = model.score;
    self.favButton.selected = [model.fav_arr containIvar:@"user_id" value:DBCommonConfig.userId];
    
    [self.favView removeAllSubView];
    
    UIColor *color = DBColorExtension.charcoalColor;
    if (DBColorExtension.userInterfaceStyle) {
        self.favView.backgroundColor = DBColorExtension.snowColor;
        self.replyView.backgroundColor = DBColorExtension.snowColor;

    }else{
        self.favView.backgroundColor = DBColorExtension.platinumColor;
        self.replyView.backgroundColor = DBColorExtension.platinumColor;
    }
    
    if (model.fav_arr.count){
        UIView *lastView;
        for (DBBookFavModel *favModel in model.fav_arr) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = 12;
            imageView.layer.masksToBounds = YES;
            imageView.imageObj = favModel.avatar;
            [self.favView addSubview:imageView];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (lastView){
                    make.left.mas_equalTo(lastView.mas_right).offset(10);
                }else{
                    make.left.mas_equalTo(10);
                }
                
                make.top.mas_equalTo(10);
                make.bottom.mas_equalTo(-10);
                make.width.height.mas_equalTo(24);
            }];
            lastView = imageView;
        }
        DBBaseLabel *favLabel = [[DBBaseLabel alloc] init];
        favLabel.font = DBFontExtension.bodyMediumFont;
        favLabel.textColor = DBColorExtension.grayColor;
        favLabel.text = [NSString stringWithFormat:@"%ld人点赞",model.fav_arr.count];
        [self.favView addSubview:favLabel];
        [favLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lastView.mas_right).offset(10);
            make.centerY.mas_equalTo(lastView);
        }];
        
        if (model.reply_arr.count){
            UIView *partingLineView = [[UIView alloc] init];
            partingLineView.backgroundColor = DBColorExtension.lightSilverColor;
            [self.favView addSubview:partingLineView];
            [partingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
                make.height.mas_equalTo(1);
            }];
        }
    }
    
    
    [self.replyView removeAllSubView];
    if (model.reply_arr.count){
        UIView *lastReplyLabel;
        BOOL replyMore = model.reply_count > 0;
        for (DBBookReplyModel *replyModel in model.reply_arr) {
            NSMutableArray *textList = [NSMutableArray array];
            NSMutableArray *colorList = [NSMutableArray array];
            
            DBBaseLabel *replyLabel = [[DBBaseLabel alloc] init];
            replyLabel.numberOfLines = 0;
            
            [textList addObject:DBSafeString(replyModel.nick)];
            [colorList addObject:DBColorExtension.skyBlueColor];
            if (replyModel.floor_host) {
                [textList addObject:@" 楼主"];
                [colorList addObject:DBColorExtension.redColor];
            }
            if (replyModel.reply_to_comment.nick.length > 0){
                [textList addObject:@" 回复"];
                [colorList addObject:color];
                [textList addObject:[NSString stringWithFormat:@" %@",replyModel.reply_to_comment.nick]];
                [colorList addObject:DBColorExtension.skyBlueColor];
                if (replyModel.reply_to_comment.floor_host){
                    [textList addObject:@" 楼主"];
                    [colorList addObject:DBColorExtension.redColor];
                }
            }
            [textList addObject:[NSString stringWithFormat:@"：%@",replyModel.content]];
            [colorList addObject:color];
            replyLabel.attributedText = [NSAttributedString combineAttributeTexts:textList colors:colorList fonts:@[DBFontExtension.bodyMediumFont]];
            [self.replyView addSubview:replyLabel];
            
            [self.replyView.subviews.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10);
                make.right.mas_equalTo(-10);
                if (lastReplyLabel){
                    make.top.mas_equalTo(lastReplyLabel.mas_bottom).offset(5);
                }else{
                    make.top.mas_equalTo(10);
                }
                make.bottom.mas_equalTo(replyMore?-30:-5);
            }];
            lastReplyLabel = replyLabel;
        }

        if (replyMore){
            DBBaseLabel *replyMoreLabel = [[DBBaseLabel alloc] init];
            replyMoreLabel.font = DBFontExtension.bodySmallFont;
            replyMoreLabel.textColor = DBColorExtension.grayColor;
            replyMoreLabel.text = [NSString stringWithFormat:@"查看全部%ld条回复",model.reply_count];
            [self.replyView addSubview:replyMoreLabel];
            [replyMoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10);
                make.bottom.mas_equalTo(-5);
            }];
            
            UIControl *replyMoreControl = [[UIControl alloc] init];
            replyMoreControl.enlargedEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            [self.replyView addSubview:replyMoreControl];
            
            [replyMoreControl addTagetHandler:^(id  _Nonnull sender) {
                [DBRouter openPageUrl:DBBookComment params:@{@"bookName":DBSafeString(self.bookName),@"model":self.model}];
            } controlEvents:UIControlEventTouchUpInside];
            [replyMoreControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(replyMoreLabel);
            }];
        }
    }
 

}

- (void)setBookName:(NSString *)bookName{
    _bookName = bookName;
}
    
- (void)clickBlockAction{
    if (!DBCommonConfig.isLogin) {
        [DBCommonConfig toLogin];
        return;
    }
    LEEAlert.alert.config.LeeTitle(@"拉黑").
    LeeContent(@"确定要拉黑该用户吗？").
    LeeCancelAction(@"取消", ^{
        
    }).LeeAction(@"是的", ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIScreen.appWindow showAlertText:@"拉黑成功，已不能再接收对方消息！"];
        });
    }).LeeShow();
}

- (void)clickReportAction{
    if (!DBCommonConfig.isLogin) {
        [DBCommonConfig toLogin];
        return;
    }
    DBWeakSelf
    LEEAlert.actionsheet.config.
    LeeAction(@"色情低俗", ^{
        DBStrongSelfElseReturn
        [self showReportText];
    }).LeeAction(@"政治敏感", ^{
        DBStrongSelfElseReturn
        [self showReportText];
    }).LeeAction(@"广告", ^{
        DBStrongSelfElseReturn
        [self showReportText];
    }).LeeAction(@"令人恶心", ^{
        DBStrongSelfElseReturn
        [self showReportText];
    }).LeeAction(@"违纪违法", ^{
        DBStrongSelfElseReturn
        [self showReportText];
    }).LeeCancelAction(@"取消", ^{
        
    }).LeeShow();
}

- (void)showReportText{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIScreen.appWindow showAlertText:@"我们会在24小时内处理，确认违规后对内容进行相应处理！"];
    });
}

- (void)clickFavAction{
    if (!DBCommonConfig.isLogin) {
        [DBCommonConfig toLogin];
        return;
    }
    if (self.favButton.selected) return;
    [DBAFNetWorking postServiceRequestType:DBLinkCommentLike combine:nil parameInterface:@{@"id":DBSafeString(self.model.comment_id)} serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
        if (successfulRequest){
            self.favButton.selected = YES;
            [UIScreen.currentViewController dynamicAllusionTomethod:@"getDataSource"];
        }
        [UIScreen.appWindow showAlertText:message];
    }];
}

- (void)clickCommentAction{
    if (!DBCommonConfig.isLogin) {
        [DBCommonConfig toLogin];
        return;
    }
    
    DBBookCommentPanView *panView = [[DBBookCommentPanView alloc] init];
    panView.model = self.model;
    [panView presentInView:UIScreen.appWindow];
//    [DBRouter openPageUrl:DBBookComment params:@{@"bookName":DBSafeString(self.bookName),@"model":self.model}];
}

- (UIImageView *)pictureImageView{
    if (!_pictureImageView){
        _pictureImageView = [[UIImageView alloc] init];
        _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImageView.clipsToBounds = YES;
        _pictureImageView.layer.cornerRadius = 12;
        _pictureImageView.layer.masksToBounds = YES;
    }
    return _pictureImageView;
}

- (DBBaseLabel *)titleTextLabel{
    if (!_titleTextLabel){
        _titleTextLabel = [[DBBaseLabel alloc] init];
        _titleTextLabel.font = DBFontExtension.bodySixTenFont;
        _titleTextLabel.textColor = DBColorExtension.charcoalColor;
    }
    return _titleTextLabel;
}

- (DBBaseLabel *)contentTextLabel{
    if (!_contentTextLabel){
        _contentTextLabel = [[DBBaseLabel alloc] init];
        _contentTextLabel.font = DBFontExtension.bodyMediumFont;
        _contentTextLabel.textColor = DBColorExtension.grayColor;
        _contentTextLabel.numberOfLines = 0;
    }
    return _contentTextLabel;
}

- (DBBaseLabel *)dateLabel{
    if (!_dateLabel){
        _dateLabel = [[DBBaseLabel alloc] init];
        _dateLabel.font = DBFontExtension.bodyMediumFont;
        _dateLabel.textColor = DBColorExtension.grayColor;
    }
    return _dateLabel;
}

- (DBStarRating *)scoreView{
    if (!_scoreView){
        CGFloat width = 14;
        _scoreView = [[DBStarRating alloc] initWithFrame:CGRectMake(0, 0, width*5+6*4, width)];
        _scoreView.spacing = 6;
        _scoreView.checkedImage = [UIImage imageNamed:@"scoreRed_sel"];
        _scoreView.uncheckedImage = [UIImage imageNamed:@"scoreRed_unsel"];
        _scoreView.minimumScore = 0.0;
        _scoreView.maximumScore = 5;
        _scoreView.type = RatingTypeUnlimited;
    }
    return _scoreView;
}

- (UIButton *)blockButton{
    if (!_blockButton){
        _blockButton = [[UIButton alloc] init];
        _blockButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        [_blockButton setTitle:@"拉黑" forState:UIControlStateNormal];
        [_blockButton setTitleColor:DBColorExtension.oceanBlueColor forState:UIControlStateNormal];
        [_blockButton addTarget:self action:@selector(clickBlockAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _blockButton;
}

- (UIButton *)reportButton{
    if (!_reportButton){
        _reportButton = [[UIButton alloc] init];
        _reportButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        [_reportButton setTitle:@"举报" forState:UIControlStateNormal];
        [_reportButton setTitleColor:DBColorExtension.oceanBlueColor forState:UIControlStateNormal];
        [_reportButton addTarget:self action:@selector(clickReportAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reportButton;
}

- (UIButton *)favButton{
    if (!_favButton){
        _favButton = [[UIButton alloc] init];
        [_favButton setImage:[UIImage imageNamed:@"fav_unsel_icon"] forState:UIControlStateNormal];
        [_favButton setImage:[UIImage imageNamed:@"fav_sel_icon"] forState:UIControlStateSelected];
        [_favButton addTarget:self action:@selector(clickFavAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _favButton;
}

- (UIButton *)commetnButton{
    if (!_commetnButton){
        _commetnButton = [[UIButton alloc] init];
        [_commetnButton setImage:[UIImage imageNamed:@"comment_icon"] forState:UIControlStateNormal];
        [_commetnButton addTarget:self action:@selector(clickCommentAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commetnButton;
}

- (UIView *)favView{
    if (!_favView){
        _favView = [[UIView alloc] init];
        _favView.backgroundColor = DBColorExtension.platinumColor;
    }
    return _favView;
}

- (UIView *)replyView{
    if (!_replyView){
        _replyView = [[UIView alloc] init];
        _replyView.backgroundColor = DBColorExtension.platinumColor;
    }
    return _replyView;
}

@end
