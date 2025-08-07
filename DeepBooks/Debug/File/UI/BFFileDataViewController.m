//
//  BFFileDataViewController.m
//  OCProject
//
//  Created by 王祥伟 on 2023/12/15.
//

#import "BFFileDataViewController.h"
#import "BFRouter.h"
@interface BFFileDataViewController ()
@end

@implementation BFFileDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.fileName;
    
    [self.tableView reloadData];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dic.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = self.dic.allKeys[indexPath.row];
    NSDictionary *dict = @{key:self.dic[key]};
    return [NSObject performTarget:BFString.tc_file_data.classString action:[self actionString] object:tableView object:dict] ?: [UITableViewCell new];
}

@end
