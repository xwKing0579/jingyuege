//
//  DBMySettingViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/26.
//

#import "DBMySettingViewController.h"
#import "DBMySettingTableViewCell.h"

#import "DBMySettingModel.h"
#import "DBReadBookSetting.h"
#import "DBBookChapterModel.h"
@interface DBMySettingViewController ()

@end

@implementation DBMySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    self.title = @"设置";
    self.listRollingView.rowHeight = 42;
    [self.view addSubviews:@[self.navLabel,self.listRollingView]];
    [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.height.mas_equalTo(UIScreen.navbarNetHeight);
    }];
    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.navLabel.mas_bottom);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.dataList = DBMySettingListModel.dataSourceList;
    [self.listRollingView reloadData];
    
    [UIApplication calculateDiskCacheSize:^(NSString * _Nonnull sizeString) {
        DBMySettingListModel *listData = self.dataList[1];
        for (DBMySettingModel *model in listData.data) {
            if ([model.name isEqualToString:@"清理网络缓存"]){
                model.content = sizeString;
                [self.listRollingView reloadData];
                break;
            }
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    DBMySettingListModel *model = self.dataList[section];
    return model.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBMySettingTableViewCell *cell = [DBMySettingTableViewCell initWithTableView:tableView];
    DBMySettingListModel *model = self.dataList[indexPath.section];
    cell.model = model.data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBMySettingListModel *modelList = self.dataList[indexPath.section];
    DBMySettingModel *model = modelList.data[indexPath.row];
    
    if (model.needLogin && !DBCommonConfig.isLogin){
        [DBCommonConfig toLogin];
        return;
    }
    if (indexPath.section == 0){
        
    }else if (indexPath.section == 1){
        if (model.target == 1){
            DBWeakSelf
            LEEAlert.actionsheet.config.LeeTitle(@"请选择排序规则").
            LeeAction(@"最近阅读", ^{
                DBStrongSelfElseReturn
                DBReadBookSetting *setting = DBReadBookSetting.setting;
                setting.orderType = 0;
                [setting reloadSetting];
            }).LeeAction(@"更新时间", ^{
                DBStrongSelfElseReturn
                DBReadBookSetting *setting = DBReadBookSetting.setting;
                setting.orderType = 1;
                [setting reloadSetting];
            }).LeeCancelAction(@"取消", ^{
                
            }).LeeShow();
        }else if (model.target == 2){
            [self.view showAlertText:@"已同步至最新"];
        }else if (model.target == 3){
            if ([model.content isEqualToString:@"0B"]){
                [self.view showAlertText:@"暂无网络缓存需要清理"];
                return;
            }
            [self.view showHudLoading];
            DBWeakSelf
            [UIApplication clearNetworkCacheWithCompletion:^{
                DBStrongSelfElseReturn
                [self.view removeHudLoading];
            
                DBMySettingListModel *listData = self.dataList[1];
                for (DBMySettingModel *model in listData.data) {
                    if ([model.name isEqualToString:@"清理网络缓存"]){
                        model.content = @"0B";
                        [self.listRollingView reloadData];
                        break;
                    }
                }
                [self.view showAlertText:@"网络缓存已清理"];
            }];
        }else if (model.target == 4){
            [DBRouter openPageUrl:DBClearBooksCache];
        }
    }else if (indexPath.section == 2){
        if (model.vc){
            [DBRouter openPageUrl:model.vc];
        }else{
            LEEAlert.alert.config.LeeTitle(@"退出登录，\n书架及阅读记录将会清空哦！").
            LeeAction(@"确定", ^{
                
                [DBRouter closePageRoot];
                [DBCommonConfig updateUserInfo:DBUserModel.new];
                [DBBookModel removeAllCollectBooks];
                [DBBookModel removeAllReadingBooks];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UITabBarController *tabbar = (UITabBarController *)UIScreen.appWindow.rootViewController;
                    tabbar.selectedIndex = 0;
                });
            }).LeeCancelAction(@"取消", ^{
                
            }).LeeShow();
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.screenWidth, 60)];
    
    DBMySettingListModel *model = self.dataList[section];
    DBBaseLabel *label = [[DBBaseLabel alloc] init];
    label.font = DBFontExtension.titleBigFont;
    label.textColor = DBColorExtension.charcoalColor;
    label.text = model.title;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(0);
    }];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

@end
