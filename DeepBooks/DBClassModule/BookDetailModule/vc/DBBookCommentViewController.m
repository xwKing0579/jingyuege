//
//  DBBookCommentViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/10.
//

#import "DBBookCommentViewController.h"
#import "DBBookCommentTableViewCell.h"
#import "DBCommentReplyModel.h"

@interface DBBookCommentViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIImageView *pictureImageView;
@property (nonatomic, strong) DBBaseLabel *titleTextLabel;
@property (nonatomic, strong) DBBaseLabel *contentTextLabel;
@property (nonatomic, strong) DBBaseLabel *dateLabel;
@property (nonatomic, strong) UIView *favView;

@property (nonatomic, strong) UIButton *blockButton;
@property (nonatomic, strong) UIButton *reportButton;
@property (nonatomic, strong) UIButton *favButton;

@property (nonatomic, strong) UIControl *commentView;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *maskView;
@end

@implementation DBBookCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    [self getDataSource];
}

// 键盘弹出时触发
- (void)keyboardWillShow:(NSNotification *)notification {
    // 获取键盘高度和动画时间
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 调整 UI（例如输入框上移）
    [UIView animateWithDuration:duration animations:^{
        self.maskView.alpha = 1;
        self.commentView.frame = CGRectMake(self.commentView.x,
                     UIScreen.screenHeight - keyboardFrame.size.height-self.commentView.height+UIScreen.tabbarSafeHeight,self.commentView.width, self.commentView.height);
    }];
}

// 键盘收起时触发
- (void)keyboardWillHide:(NSNotification *)notification {
    // 恢复 UI 位置
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.maskView.alpha = 0;
        self.commentView.frame = CGRectMake(self.commentView.x, UIScreen.screenHeight-self.commentView.height,self.commentView.width, self.commentView.height);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [DBDefaultSwift disableKeyboard];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [DBDefaultSwift enableKeyboard];
}

- (void)setUpSubViews{
    self.maskView = [[UIButton alloc] init];
    self.maskView.layer.zPosition = 1001;
    self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.maskView.alpha = 0;
    
    self.currentPage = 1;
    self.title = self.bookName;
    [self.view addSubviews:@[self.navLabel,self.listRollingView,self.maskView,self.commentView]];
    [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.height.mas_equalTo(UIScreen.navbarNetHeight);
    }];
    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.navLabel.mas_bottom);
        make.bottom.mas_equalTo(self.commentView.mas_top);
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    DBWeakSelf
    [self.maskView addTagetHandler:^(id  _Nonnull sender) {
        DBStrongSelfElseReturn
        [self.view endEditing:YES];
    } controlEvents:UIControlEventTouchUpInside];
    
    // 监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // 监听键盘收起
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self.listRollingView reloadData];
    

    self.listRollingView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        DBStrongSelfElseReturn
        self.currentPage = 1;
        [self getDataSource];
    }];
    
    self.listRollingView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        DBStrongSelfElseReturn
        [self getDataSource];
    }];
}


- (void)getDataSource{
    NSString *page = [NSString stringWithFormat:@"%ld",self.currentPage];
    NSDictionary *parameInterface = @{@"id":DBSafeString(self.model.comment_id),@"page":page};
    [DBAFNetWorking getServiceRequestType:DBLinkCommentReplayList combine:nil parameInterface:parameInterface modelClass:DBCommentReplyModel.class serviceData:^(BOOL successfulRequest, DBCommentReplyModel *result, NSString * _Nullable message) {
        [self.listRollingView.mj_header endRefreshing];
        [self.listRollingView.mj_footer endRefreshing];
        if (successfulRequest){
            NSMutableArray *dataList = [NSMutableArray arrayWithArray:self.currentPage==1?@[]:self.dataList];
            [dataList addObjectsFromArray:result.lists.comment_reply_list];
            self.dataList = dataList;
            [self.listRollingView reloadData];
            if (self.dataList.count > 0){
                self.currentPage++;
            }else{
                [self.listRollingView.mj_footer endRefreshingWithNoMoreData];
            }
            self.listRollingView.mj_footer.hidden = self.dataList.count == 0;
        }else{
            [self.view showAlertText:message];
        }
    }];
}

- (void)clickBlockAction{
    DBWeakSelf
    LEEAlert.alert.config.LeeTitle(@"是否彻底删除已选中的书籍？").
    LeeCancelAction(@"取消", ^{
        
    }).LeeAction(@"确定", ^{
        DBStrongSelfElseReturn  
        [self clickReportAction];
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

- (void)sendMessage:(NSString *)message{
    [self.view endEditing:YES];
    [self.view showHudLoading];
    NSDictionary *parameInterface = @{@"id":DBSafeString(self.model.comment_id),@"content":DBSafeString(message),@"pid":@"0"};
    [DBAFNetWorking postServiceRequestType:DBLinkCommentReplaySubmit combine:nil parameInterface:parameInterface serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
        [self.view removeHudLoading];
        if (successfulRequest){
            self.searchTextField.text = nil;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getDataSource];
            });
            [UIScreen.appWindow showAlertText:@"回复成功"];
        }else{
            [UIScreen.appWindow showAlertText:message];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBBookCommentTableViewCell *cell = [DBBookCommentTableViewCell initWithTableView:tableView];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.headerView.height;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self clickSendAction];
    return YES;
}

- (void)clickSendAction{
    NSString *text = self.searchTextField.text.whitespace;
    if (text.length){
        [self sendMessage:text];
    }else{
        [self.view showAlertText:@"请输入内容"];
    }
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

- (UIView *)headerView{
    if (!_headerView){
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.screenWidth, 0)];
        [_headerView addSubviews:@[self.pictureImageView,self.titleTextLabel,self.contentTextLabel,self.dateLabel,self.blockButton,self.reportButton,self.favView,self.favButton]];
        [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.mas_equalTo(15);
            make.width.height.mas_equalTo(24);
        }];
        [self.titleTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.pictureImageView.mas_right).offset(8);
            make.centerY.mas_equalTo(self.pictureImageView);
        }];
        [self.contentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.top.mas_equalTo(self.pictureImageView.mas_bottom).offset(6);
        }];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentTextLabel);
            make.top.mas_equalTo(self.contentTextLabel.mas_bottom).offset(6);
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
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(26);
        }];
        
        [self.favView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(46);
            make.top.mas_equalTo(self.dateLabel.mas_bottom).offset(10);
        }];

        [self.favButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-26);
            make.centerY.mas_equalTo(self.favView);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(26);
        }];
        
        DBBookCommentModel *model = self.model;
        self.pictureImageView.imageObj = model.avatar;
        self.titleTextLabel.text = model.nick;
        self.contentTextLabel.text = model.content;
        self.dateLabel.text = model.created_at.timeToDate.dateToTimeString;
        self.favButton.selected = [model.fav_arr containIvar:@"user_id" value:DBCommonConfig.userId];
        
        if (model.fav_arr.count){
            UIView *lastView;
            for (DBBookFavModel *favModel in model.fav_arr) {
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.layer.cornerRadius = 12;
                imageView.layer.masksToBounds = YES;
                imageView.imageObj = favModel.avatar;
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                [self.favView addSubview:imageView];
                
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (lastView){
                        make.left.mas_equalTo(lastView.mas_right).offset(10);
                    }else{
                        make.left.mas_equalTo(10);
                    }
                    
                    make.top.mas_equalTo(10);
                    make.bottom.mas_equalTo(-10);
                    make.width.height.mas_equalTo(26);
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
        }
        
        UIView *lineView = [[UIView alloc] init];
        self.lineView = lineView;
        lineView.backgroundColor = DBColorExtension.paleGrayAltColor;
        [_headerView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.favView.mas_bottom).offset(10);
            make.height.mas_equalTo(4);
        }];
        
        DBBaseLabel *label = [[DBBaseLabel alloc] init];
        label.text = [NSString stringWithFormat:@"共%ld条",model.reply_count];
        label.textColor = DBColorExtension.silverColor;
        label.font = DBFontExtension.bodySmallFont;
        [_headerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.top.mas_equalTo(lineView.mas_bottom).offset(6);
            make.bottom.mas_equalTo(-6);
        }];
    }
    [_headerView setNeedsLayout];
    [_headerView layoutIfNeeded];
    CGFloat height = [_headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    _headerView.height = height;
    return _headerView;
}

- (UITextField *)searchTextField{
    if (!_searchTextField){
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.layer.cornerRadius = 6;
        _searchTextField.layer.masksToBounds = YES;
        _searchTextField.backgroundColor = DBColorExtension.whiteColor;
        _searchTextField.font = DBFontExtension.bodyMediumFont;
        _searchTextField.placeholder = @"我要评论";
        _searchTextField.textColor = DBColorExtension.charcoalColor;
     
        _searchTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;

        _searchTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _searchTextField.rightViewMode = UITextFieldViewModeAlways;
        _searchTextField.returnKeyType = UIReturnKeyDone;
//        _searchTextField.delegate = self;
    }
    return _searchTextField;
}

- (UIButton *)sendButton{
    if (!_sendButton){
        _sendButton = [[UIButton alloc] init];
        _sendButton.titleLabel.font = DBFontExtension.bodyMediumFont;
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:DBColorExtension.charcoalColor forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(clickSendAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (UIView *)favView{
    if (!_favView){
        _favView = [[UIView alloc] init];
        _favView.backgroundColor = DBColorExtension.snowColor;
    }
    return _favView;
}

- (UIControl *)commentView{
    if (!_commentView){
        _commentView = [[UIControl alloc] initWithFrame:CGRectMake(0, UIScreen.screenHeight-50-UIScreen.tabbarSafeHeight, UIScreen.screenWidth, 50+UIScreen.tabbarSafeHeight)];
        _commentView.layer.zPosition = 1002;
        _commentView.backgroundColor = DBColorExtension.snowColor;
        [_commentView addTagetHandler:^(id  _Nonnull sender) {
            
        } controlEvents:UIControlEventTouchUpInside];
        
        [_commentView addSubviews:@[self.searchTextField,self.sendButton]];
        [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(6);
            make.right.mas_equalTo(-60);
            make.bottom.mas_equalTo(-6-UIScreen.tabbarSafeHeight);
        }];
        [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.searchTextField.mas_right);
            make.right.mas_equalTo(0);
            make.top.bottom.mas_equalTo(self.searchTextField);
        }];
    }
    return _commentView;
}

- (void)setDarkModel{
    [super setDarkModel];
    if (DBColorExtension.userInterfaceStyle) {
        self.favView.backgroundColor = DBColorExtension.coolGrayColor;
        self.lineView.backgroundColor = DBColorExtension.blackColor;
        self.commentView.backgroundColor = DBColorExtension.blackColor;
        self.searchTextField.backgroundColor = DBColorExtension.jetBlackColor;
    }else{
        self.favView.backgroundColor = DBColorExtension.snowColor;
        self.lineView.backgroundColor = DBColorExtension.paleGrayAltColor;
        self.commentView.backgroundColor = DBColorExtension.snowColor;
        self.searchTextField.backgroundColor = DBColorExtension.whiteColor;
    }
}
@end
