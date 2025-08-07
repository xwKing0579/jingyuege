//
//  BFAppInfoViewController.m
//  OCProject
//
//  Created by 王祥伟 on 2023/12/12.
//

#import "BFAppInfoViewController.h"
#import "BFAppInfoModel.h"

@interface BFAppInfoViewController ()
@end

@implementation BFAppInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"app信息";
    self.data = [BFAppInfoModel data];
    [self.tableView reloadData];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BFAppInfoModel *model = self.data[section];
    return model.item.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BFAppInfoModel *model = self.data[indexPath.section];
    return [NSObject performTarget:BFString.tc_app_info.classString action:[self actionString] object:tableView object:model.item[indexPath.row]] ?: [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bf_width, 50)];
    DBBaseLabel *titleLabel = [[DBBaseLabel alloc] initWithFrame:CGRectMake(15, 0, view.bf_width-30, view.bf_height)];
    titleLabel.text = ((BFAppInfoModel *)self.data[section]).title;
    titleLabel.font = UIFont.font20;
    [view addSubview:titleLabel];
    return view;
}

@end
