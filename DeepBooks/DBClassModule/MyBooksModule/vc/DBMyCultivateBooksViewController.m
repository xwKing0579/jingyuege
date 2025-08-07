//
//  DBMyCultivateBooksViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/1.
//

#import "DBMyCultivateBooksViewController.h"
#import "DBMyCultivateBooksTableViewCell.h"
@interface DBMyCultivateBooksViewController ()

@end

@implementation DBMyCultivateBooksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(reloadDataList) name:DBUpdateCollectBooks object:nil];
}

- (void)setUpSubViews{
    self.title = @"养肥区";
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
    
    [self reloadDataList];
}

- (void)reloadDataList{
    self.dataList = DBBookModel.getAllCultivateBooks;
    [self.listRollingView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBMyCultivateBooksTableViewCell *cell = [DBMyCultivateBooksTableViewCell initWithTableView:tableView];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

@end
