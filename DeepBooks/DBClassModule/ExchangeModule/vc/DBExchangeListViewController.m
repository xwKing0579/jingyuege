//
//  DBExchangeListViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/1.
//

#import "DBExchangeListViewController.h"
#import "DBExchangeTableViewCell.h"

@interface DBExchangeListViewController ()

@end

@implementation DBExchangeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    self.title = @"充值记录";
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBExchangeTableViewCell *cell = [DBExchangeTableViewCell initWithTableView:tableView];
    return cell;
}

@end
