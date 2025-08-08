//
//  DBContryCodeViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/23.
//

#import "DBContryCodeViewController.h"
#import "DBContryCodeModel.h"
#import "DBContryCodeTableViewCell.h"
@interface DBContryCodeViewController ()

@end

@implementation DBContryCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    [self getDataSource];
}

- (void)setUpSubViews{
    self.title = DBConstantString.ks_countryCode;
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

- (void)getDataSource{
    NSString *value = [NSUserDefaults takeValueForKey:DBContryCodeValue];
    NSArray *dataList = [NSArray yy_modelArrayWithClass:DBContryCodeModel.class json:value];
    if (dataList.count){
        self.dataList = dataList;
        [self.listRollingView reloadData];
        return;
    }
    
    [DBAFNetWorking postServiceRequestType:DBLinkUserPhoneAreaCode combine:nil parameInterface:nil modelClass:DBContryCodeModel.class serviceData:^(BOOL successfulRequest, NSArray *result, NSString * _Nullable message) {
        if (successfulRequest){
            self.dataList = result;
            [self.listRollingView reloadData];
            
            [NSUserDefaults saveValue:result.yy_modelToJSONString forKey:DBContryCodeValue];
        }else{
            [self.view showAlertText:message];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBContryCodeTableViewCell *cell = [DBContryCodeTableViewCell initWithTableView:tableView];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBContryCodeModel *model = self.dataList[indexPath.row];
    if (self.changeContryCodeBlock) self.changeContryCodeBlock([NSString stringWithFormat:@"+%@",model.tel]);
    [NSUserDefaults saveValue:@(indexPath.row) forKey:DBChoiceCodeValue];
    [DBRouter closePage];
}

@end
