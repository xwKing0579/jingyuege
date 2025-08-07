//
//  BFUiHierarchyViewController.m
//  OCProject
//
//  Created by 王祥伟 on 2024/3/14.
//

#import "BFUiHierarchyViewController.h"
#import "BFUIHierarchyManager.h"
@interface BFUiHierarchyViewController ()
@property (nonatomic, strong) NSMutableArray <BFUIHierarchyModel *>*dataSource;//展示数据
@property (nonatomic, strong) BFUIHierarchyModel *model;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) BOOL isVcs;
@end

@implementation BFUiHierarchyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = [NSString stringWithFormat:@"视图层级(%@)",[BFUIHierarchyManager isOn] ? @"开" : @"关"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"一键展开" style:(UIBarButtonItemStyleDone) target:self action:@selector(oneKeyExpansion)];
    [self setUpSubViews];
}

- (void)setUpSubViews{
    self.dataSource  = [NSMutableArray array];
    self.model = self.views;
    if (self.model) [self.dataSource addObject:self.model];
    self.data = self.dataSource;
    [self.tableView reloadData];
    
    if (!self.vcs) return;
    UIButton *customView = [[UIButton alloc] init];
    customView.backgroundColor = UIColor.redColor;
    customView.layer.cornerRadius = 20;
    [customView setTitle:self.isVcs ? @"V" : @"C" forState:UIControlStateNormal];
    [customView setTitleColor:UIColor.bf_cFFFFFF forState:UIControlStateNormal];
    [customView addTarget:self action:@selector(clickOn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:customView];
    [customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.width.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-50);
    }];
}

- (void)oneKeyExpansion{
    self.isOpen = YES;
    [self updateUIHierarchy];
}

- (void)clickOn:(UIButton *)sender{
    if (self.views && self.vcs) {
        self.isVcs = !self.isVcs;
        [sender setTitle:self.isVcs ? @"V" : @"C" forState:UIControlStateNormal];
        self.model = self.isVcs ? self.vcs : self.views;
        [self updateUIHierarchy];
    }
}

- (NSString *)cellClass{
    return BFString.tc_ui_hierarchy;
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BFUIHierarchyModel *model = self.dataSource[indexPath.row];
    model.isOpen = !model.isOpen;
    self.isOpen = NO;
    [self updateUIHierarchy];
}

- (void)updateUIHierarchy{
    if (!self.model) return;
    [self.dataSource removeAllObjects];
    [self.dataSource addObject:self.model];
    [self getUIHierarchy:self.model];
    self.data = self.dataSource;
    [self.tableView reloadData];
}

- (void)getUIHierarchy:(BFUIHierarchyModel *)model{
    if (self.isOpen) model.isOpen = YES;
    if (!model.isOpen) return;
    for (BFUIHierarchyModel *item in model.subviews) {
        [self.dataSource addObject:item];
        [self getUIHierarchy:item];
    }
}

@end
