//
//  DBBooksListViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/21.
//

#import "DBBooksListViewController.h"
#import "DBBooksListTableViewCell.h"
#import "DBBooksListDescTableViewCell.h"
#import "DBBooksListModel.h"

@interface DBBooksListViewController ()
@property (nonatomic, strong) DBBooksListModel *model;
@property (nonatomic, strong) UIButton *collectButton;
@end

@implementation DBBooksListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    [self getDataSource];
    [self checkCollectBookList];
}

- (void)setUpSubViews{
    self.title = DBConstantString.ks_listDescription;
    [self.view addSubviews:@[self.navLabel,self.listRollingView,self.collectButton]];
    [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.height.mas_equalTo(UIScreen.navbarNetHeight);
    }];
    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.navLabel.mas_bottom).offset(10);
    }];
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.navLabel);
    }];
}

- (void)getDataSource{
    if (!self.list_id) return;
    
    NSInteger index = [self.list_id integerValue]/1000;
    NSDictionary *combine = @{@"list_id":DBSafeString(self.list_id),@"index":[NSString stringWithFormat:@"%ld",index]};
    [DBAFNetWorking getServiceRequestType:DBLinkBookThemeDetailData combine:combine parameInterface:nil modelClass:DBBooksListModel.class serviceData:^(BOOL successfulRequest, DBBooksListModel *result, NSString * _Nullable message) {
        if (successfulRequest){
            self.model = result;
            self.dataList = result.books;
            [self.listRollingView reloadData];
        }else{
            [self.view showAlertText:message];
        }
    }];
}

- (void)checkCollectBookList{
    if (!DBCommonConfig.isLogin) {
        self.collectButton.hidden = NO;
        self.collectButton.selected = NO;
        return;
    }
    
    if (self.isCollected){
        self.collectButton.hidden = NO;
        self.collectButton.selected = YES;
        return;
    }
    
   
    if (!self.list_id) return;
    //检查是否收藏
    [DBAFNetWorking postServiceRequestType:DBLinkRBookThemeWhetherOrNot combine:nil parameInterface:@{@"id":self.list_id} modelClass:nil serviceData:^(BOOL successfulRequest, NSDictionary *result, NSString * _Nullable message) {
        if (successfulRequest){
            BOOL state = [result[@"state"] boolValue];
            self.collectButton.hidden = NO;
            self.collectButton.selected = state;
        }else{
            [self.view showAlertText:message];
        }
    }];
}

- (void)clickCollectAction{
    if (!DBCommonConfig.isLogin) {
        [DBCommonConfig toLogin];
        return;
    }
    
    if (!self.list_id) return;
    if (self.collectButton.selected){
        [self.view showHudLoading];
        [DBAFNetWorking postServiceRequestType:DBLinkRBookThemeDelete combine:nil parameInterface:@{@"id":self.list_id} serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
            [self.view removeHudLoading];
            if (successfulRequest){
                self.collectButton.selected = NO;
                [self.view showAlertText:DBConstantString.ks_unfavorited];
            }else{
                [self.view showAlertText:message];
            }
        }];
    }else{
        [self.view showHudLoading];
        [DBAFNetWorking postServiceRequestType:DBLinkRBookThemeAdd combine:nil parameInterface:@{@"id":self.list_id} serviceData:^(BOOL successfulRequest, id  _Nullable result, NSString * _Nullable message) {
            [self.view removeHudLoading];
            if (successfulRequest){
                self.collectButton.selected = YES;
                [self.view showAlertText:DBConstantString.ks_favoriteSuccess];
            }else{
                [self.view showAlertText:message];
            }
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row){
        DBBooksListTableViewCell *cell = [DBBooksListTableViewCell initWithTableView:tableView];
        cell.model = self.dataList[indexPath.row];
        return cell;
    }else{
        DBBooksListDescTableViewCell *cell = [DBBooksListDescTableViewCell initWithTableView:tableView];
        cell.model = self.model;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row){
        DBBooksModel *model = self.dataList[indexPath.row];
        [DBRouter openPageUrl:DBBookDetail params:@{@"bookId":DBSafeString(model.book_id)}];
    }
}

- (UIButton *)collectButton{
    if (!_collectButton){
        _collectButton = [[UIButton alloc] init];
        _collectButton.hidden = YES;
        _collectButton.titleLabel.font = DBFontExtension.pingFangMediumLarge;
        [_collectButton setTitle:DBConstantString.ks_favorite forState:UIControlStateNormal];
        [_collectButton setTitle:DBConstantString.ks_unfavorite forState:UIControlStateSelected];
        [_collectButton setTitleColor:DBColorExtension.charcoalColor forState:UIControlStateNormal];
        [_collectButton addTarget:self action:@selector(clickCollectAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectButton;
}

- (void)setDarkModel{
    [super setDarkModel];
    [self.listRollingView reloadData];
}

@end
