//
//  DBServiceListViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/23.
//

#import "DBServiceListViewController.h"
#import "DBServiceTableViewCell.h"
#import "DBServiceModel.h"
@interface DBServiceListViewController ()

@end

@implementation DBServiceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    [self.view addSubviews:@[self.navLabel,self.listRollingView]];
    [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.height.mas_equalTo(UIScreen.navbarNetHeight);
    }];
    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.navLabel.mas_bottom).offset(10);
    }];
    self.listRollingView.rowHeight = 56;
    self.dataList = DBServiceModel.dataSourceList;
    [self.listRollingView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBServiceTableViewCell *cell = [DBServiceTableViewCell initWithTableView:tableView];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBServiceModel *model = self.dataList[indexPath.row];
    [DBRouter openPageUrl:model.url params:model.params];
}

@end
