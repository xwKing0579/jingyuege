//
//  DBLoginoutViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/21.
//

#import "DBLoginoutViewController.h"
#import "DBMySettingTableViewCell.h"
#import "DBMySettingModel.h"
@interface DBLoginoutViewController ()

@end

@implementation DBLoginoutViewController

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
    
    self.dataList = DBMySettingListModel.dataSourceList2;
    [self.listRollingView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBMySettingTableViewCell *cell = [DBMySettingTableViewCell initWithTableView:tableView];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBMySettingModel *model = self.dataList[indexPath.row];
    if (indexPath.row == 2){
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
    }else{
        [DBRouter openPageUrl:model.vc];
    }
}

@end
