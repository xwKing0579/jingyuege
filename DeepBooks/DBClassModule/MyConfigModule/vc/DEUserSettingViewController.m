//
//  DEUserSettingViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/25.
//

#import "DEUserSettingViewController.h"
#import "DBUserSettingModel.h"
#import "DEUserSettingTableViewCell.h"


@interface DEUserSettingViewController ()

@end

@implementation DEUserSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    self.title = DBConstantString.ks_profile;
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
    self.dataList = DBUserSettingModel.dataSourceList;
    [self.listRollingView reloadData];
}

- (void)uploadAvaterImage:(UIImage *)image{
    NSData *imageData = [image compressImageMaxSize:100*1024 scale:0.8];
    [DBAFNetWorking uploadServiceRequestType:DBLinkUserAvatarUpload combine:nil parameInterface:nil fileData:imageData modelClass:nil serviceData:^(BOOL successfulRequest, NSDictionary *result, NSString * _Nullable message) {
        if ([[result valueForKey:@"code"] intValue] == 0){
            DBUserSettingModel *model = self.dataList.firstObject;
            model.avater = image;
            [self.listRollingView reloadData];
            
            [NSUserDefaults saveValue:imageData forKey:DBUserAvaterKey];
            
            [self.view showAlertText:DBConstantString.ks_avatarUploadSuccess];
        }else{
            [self.view showAlertText:result[@"msg"]];
        }

    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DEUserSettingTableViewCell *cell = [DEUserSettingTableViewCell initWithTableView:tableView];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        DBWeakSelf
        [DBImagePicker showYPImagePickerWithRatio:1 completion:^(UIImage * _Nonnull image) {
            DBStrongSelfElseReturn
            if (image) [self uploadAvaterImage:image];
        }];
    }else if (indexPath.row == 2){
        [DBRouter openPageUrl:DBChangeName];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        return 80;
    }
    return 50;
}


@end
