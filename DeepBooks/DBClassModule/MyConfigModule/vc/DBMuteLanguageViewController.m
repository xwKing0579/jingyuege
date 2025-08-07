//
//  DBMuteLanguageViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/6/18.
//

#import "DBMuteLanguageViewController.h"
#import "DBMuteLanguageTableViewCell.h"
#import "DBMuteLanguageModel.h"
@interface DBMuteLanguageViewController ()
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) NSString *choiceAbbrev;
@end

@implementation DBMuteLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpSubViews];
}

- (void)setUpSubViews{
    self.title = @"语言设置";
    [self.view addSubviews:@[self.navLabel,self.listRollingView,self.saveButton]];
    [self.navLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.height.mas_equalTo(UIScreen.navbarNetHeight);
    }];
    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.navLabel.mas_bottom);
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self.navLabel);
        make.width.height.mas_equalTo(UIScreen.navbarNetHeight);
    }];
    
    self.choiceAbbrev = DBAppSetting.languageAbbrev;
    self.dataList = DBMuteLanguageModel.dataSourceList;
    [self.listRollingView reloadData];
}

- (void)clickSaveAction{
    if (!self.saveButton.selected) return;
    
    [DBMuteLanguageModel saveLanguageAbbrev:self.choiceAbbrev];
    
    [UIScreen.appWindow showAlertText:@"设置成功"];
    [DBRouter closePage];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBMuteLanguageTableViewCell *cell = [DBMuteLanguageTableViewCell initWithTableView:tableView];
    cell.model = self.dataList[indexPath.row];
    cell.abbrev = self.choiceAbbrev;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBMuteLanguageModel *model = self.dataList[indexPath.row];
    self.choiceAbbrev = model.abbrev;
    [self.listRollingView reloadData];
    
    self.saveButton.selected = ![DBAppSetting.languageAbbrev isEqualToString:self.choiceAbbrev];
}

- (UIButton *)saveButton{
    if (!_saveButton){
        _saveButton = [[UIButton alloc] init];
        _saveButton.titleLabel.font = DBFontExtension.pingFangMediumLarge;
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:DBColorExtension.paleGrayColor forState:UIControlStateNormal];
        [_saveButton setTitleColor:DBColorExtension.redColor forState:UIControlStateSelected];
        [_saveButton addTarget:self action:@selector(clickSaveAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

@end
