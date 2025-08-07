//
//  DBMineViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/21.
//

#import "DBMineViewController.h"
#import "DBMyConfigTableViewCell.h"
#import "DBMyConfigModel.h"
#import <StoreKit/StoreKit.h>
#import "DBUserSettingModel.h"
#import "DBAppSwitchModel.h"

@interface DBMineViewController ()
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *avaterImageView;
@end

@implementation DBMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpSubViews];
}

- (void)setUpSubViews{
    [self.view addSubviews:@[self.headerView,self.listRollingView]];
    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.headerView.mas_bottom).offset(20);
    }];
    self.dataList = DBMyConfigModel.dataSourceList;
    [self.listRollingView reloadData];
    
    id imageObj = [UIImage imageNamed:@"avaterImage"];
    if (DBCommonConfig.userDataInfo.avatar.length > 0){
        imageObj = [DBLinkManager combineLinkWithType:DBLinkHeaderAvatarUrl combine:DBCommonConfig.userDataInfo.avatar];
    }
    id imageData = [NSUserDefaults takeValueForKey:DBUserAvaterKey];
    if (DBCommonConfig.isLogin){
        self.avaterImageView.imageObj = imageData ?: imageObj;
    }else{
        self.avaterImageView.imageObj = imageObj;
    }
}

- (void)changeAvaterAction{
    DBWeakSelf
    [DBImagePicker showYPImagePickerWithRatio:1 completion:^(UIImage * _Nonnull image) {
        DBStrongSelfElseReturn
        NSData *imageData = [image compressImageMaxSize:100*1024 scale:0.8];
        [NSUserDefaults saveValue:imageData forKey:DBUserAvaterKey];
        self.avaterImageView.imageObj = image;
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBMyConfigTableViewCell *cell = [DBMyConfigTableViewCell initWithTableView:tableView];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBMyConfigModel *model = self.dataList[indexPath.row];
    if (model.vc){
        [DBRouter openPageUrl:model.vc params:@{@"title":DBSafeString(model.name)}];
    }else{
        if ([model.name isEqualToString:@"五星好评"]){
            [SKStoreReviewController requestReview];
        }else if ([model.name isEqualToString:@"绑定邀请码"]){
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

- (UIView *)headerView{
    if (!_headerView){
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.screenWidth, UIScreen.navbarSafeHeight+120)];
        _headerView.backgroundColor = DBColorExtension.iceBlueColor;
        
        [_headerView addSubviews:@[self.avaterImageView]];
        [self.avaterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-30);
            make.width.height.mas_equalTo(68);
        }];
   
    }
    return _headerView;
}

- (UIImageView *)avaterImageView{
    if (!_avaterImageView){
        _avaterImageView = [[UIImageView alloc] init];
        _avaterImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avaterImageView.image = [UIImage imageNamed:@"appLogo"];
        _avaterImageView.layer.cornerRadius = 34;
        _avaterImageView.layer.masksToBounds = YES;
        _avaterImageView.imageObj = DBCommonConfig.userCurrentInfo.user_avatar;
        _avaterImageView.userInteractionEnabled = YES;
        [_avaterImageView addTapGestureTarget:self action:@selector(changeAvaterAction)];
    }
    return _avaterImageView;
}

@end
