//
//  DBMyConfigViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import "DBMyConfigViewController.h"
#import "DBMyConfigTableViewCell.h"
#import "DBMyConfigModel.h"
#import "DBMyConfigHeaderView.h"
#import "DBAppSwitchModel.h"

@interface DBMyConfigViewController ()
@property (nonatomic, strong) DBMyConfigHeaderView *headerView;
@end

@implementation DBMyConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLoginSuccess) name:DBUserLoginSuccess object:nil];
}

- (void)userLoginSuccess{
    self.dataList = DBMyConfigModel.dataSourceList;
    [self.listRollingView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.headerView.contents = DBMyConfigModel.myConfigContent;
}

- (void)setUpSubViews{
    self.listRollingView.backgroundColor = DBColorExtension.whiteAltColor;
    [self.view addSubview:self.listRollingView];
    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.dataList = DBMyConfigModel.dataSourceList;
    [self.listRollingView reloadData];
    DBWeakSelf
    [DBUserModel getUserCenterCompletion:^(BOOL successfulRequest) {
        if (successfulRequest){
            DBStrongSelfElseReturn
            self.dataList = DBMyConfigModel.dataSourceList;
            [self.listRollingView reloadData];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBMyConfigTableViewCell *cell = [DBMyConfigTableViewCell initWithTableView:tableView];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBMyConfigModel *model = self.dataList[indexPath.row];
    if (model.needLogin && !DBCommonConfig.isLogin) {
        [DBCommonConfig toLogin];
        return;
    }
    if (model.vc){
        [DBRouter openPageUrl:model.vc params:@{@"title":DBSafeString(model.name)}];
    }else{
        if ([model.name isEqualToString:@"我要分享"]){
            [self.view showHudLoading];
            [DBUserModel getUserInviteCompletion:^(BOOL successfulRequest, DBUserInviteCodeModel * _Nonnull model) {
                [self.view removeHudLoading];
                
                NSString *shareURL = [NSString stringWithFormat:@"%@?invite_id=%@&invite_code=%@",model.share_link,model.inviter,model.invite_code];
                NSURL *url = [NSURL URLWithString:shareURL];
                UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[shareURL,url] applicationActivities:nil];
                
                [self presentViewController:activityVC animated:YES completion:nil];
            }];
        }else if ([model.name isEqualToString:@"绑定邀请码"]){
            if (DBCommonConfig.userCurrentInfo.master_user_id.length > 0){
                [self.view showAlertText:@"已绑定邀请码"];
                return;
            }
            __block UITextField *inputTextField = nil;
            [DBDefaultSwift disableKeyboard];
            DBWeakSelf
            [LEEAlert alert].config
                .LeeTitle(@"输入邀请码")
                .LeeContent(@"请输入您收到的邀请码")
                .LeeAddTextField(^(UITextField * _Nonnull textField) {
                    [textField becomeFirstResponder];
                    inputTextField = textField;
                })
                .LeeItemInsets(UIEdgeInsetsMake(10, 10, 10, 10))
                .LeeCancelAction(@"取消", ^{
                    [DBDefaultSwift enableKeyboard];
                })
                .LeeDestructiveAction(@"确定", ^{
                    DBStrongSelfElseReturn
                    [DBAppSwitchModel getAppSwitchWithInvitationCode:inputTextField.text.whitespace];
                    [DBDefaultSwift enableKeyboard];
                }).LeeShow();
        }else if ([model.name isEqualToString:@"点击联系客服"]){
            [DBCommonConfig jumpCustomerService];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.headerView.height;
}

- (DBMyConfigHeaderView *)headerView{
    if (!_headerView){
        _headerView = [[DBMyConfigHeaderView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.screenWidth, UIScreen.screenWidth/375.0*253.0+(DBCommonConfig.isUserVip?64.0:0))];
    }
    return _headerView;
}

@end
