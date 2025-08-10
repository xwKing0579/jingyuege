//
//  DBHomeViewController.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/25.
//

#import "DBHomeViewController.h"
#import "DBBooksDataModel.h"
#import "DBBooksStyle11TableViewCell.h"
#import "DBKeywordModel.h"
@interface DBHomeViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UITextField *searchButton;
@end

@implementation DBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setUpSubViews];
    [self getDataSource];
 
}

- (void)setUpSubViews{
    self.view.backgroundColor = DBColorExtension.noColor;
    self.listRollingView.backgroundColor = DBColorExtension.noColor;
    [self.view addSubviews:@[self.listRollingView,self.searchButton]];
    [self.listRollingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarHeight);
    }];
    
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(UIScreen.navbarSafeHeight);
        make.height.mas_equalTo(40);
    }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *text = textField.text.whitespace;
    if (text.length){
        [self xx_hotSearchHandler:text];
    }else{
        [self.view showAlertText:@"请输入搜索内容".textMultilingual];
    }
 
    return YES;
}

- (void)xx_hotSearchHandler:(NSString *)text{
    [self.view endEditing:YES];
    [self.view showHudLoading];
    NSString *textResult = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [DBAFNetWorking postServiceRequestType:DBLinkBaseKeyword combine:textResult parameInterface:nil modelClass:DBKeywordModel.class serviceData:^(BOOL successfulRequest, DBKeywordModel *result, NSString * _Nullable message) {
        [self.view removeHudLoading];
        
        if ([result isKindOfClass:DBKeywordModel.class] && result.fttg.length > 0){
            DBAppSetting *setting = DBAppSetting.setting;
            setting.keyword = textResult;
            [setting reloadSetting];
            [DBCommonConfig cutUserSide];
        }else{
            [self.view showAlertText:@"未找到搜索内容".textMultilingual];
        }
        
    }];
}


- (void)getDataSource{
    NSString *combine = @"1";
    [self.view showHudLoading];
    [DBAFNetWorking getServiceRequestType:DBLinkBookBestseller combine:combine parameInterface:nil modelClass:DBBooksDataModel.class serviceData:^(BOOL successfulRequest, NSArray *result, NSString * _Nullable message) {
        [self.view removeHudLoading];
        if (successfulRequest){
            self.dataList = result;
        }else{
            [self.view showAlertText:message];
        }
        
        self.listRollingView.emptyDataSetSource = self;
        self.listRollingView.emptyDataSetDelegate = self;
        [self.listRollingView reloadData];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBBooksStyle11TableViewCell *cell = [DBBooksStyle11TableViewCell initWithTableView:tableView];
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBBooksDataModel *model = self.dataList[indexPath.row];
    [DBRouter openPageUrl:DBBookDetail params:@{@"bookId":DBSafeString(model.book_id)}];
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    DBEmptyView *emptyView = [[DBEmptyView alloc] init];
    emptyView.imageObj = [UIImage imageNamed:@"jjNullCanvas"];
    emptyView.content = @"暂无数据";
    emptyView.dataList = self.dataList;
    [scrollView addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(UIScreen.screenWidth);
    }];
    
    DBWeakSelf
    emptyView.reloadBlock = ^{
        DBStrongSelfElseReturn
        [self getDataSource];
    };
    return emptyView;
}

- (UITextField *)searchButton{
    if (!_searchButton){
        _searchButton = [[UITextField alloc] init];
        _searchButton.layer.cornerRadius = 20;
        _searchButton.layer.masksToBounds = YES;
        _searchButton.backgroundColor = [DBColorExtension activeTabColor];
        _searchButton.font = UIFont.pingFangRegular16;
        _searchButton.textColor = UIColor.whiteColor;
        _searchButton.attributedPlaceholder = [NSAttributedString combineAttributeTexts:@[@"输入搜索内容".textMultilingual] colors:@[UIColor.cDDDDDD] fonts:@[UIFont.pingFangRegular16]];
     
        _searchButton.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 34, 0)];
        _searchButton.leftViewMode = UITextFieldViewModeAlways;

        
        UIImageView *searchIconView = [[UIImageView alloc] init];
        searchIconView.image = [UIImage imageNamed:@"searchIcon"];
        [_searchButton addSubview:searchIconView];
        [searchIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(10);
            make.width.height.mas_equalTo(16);
        }];
        
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 16, 16)];
        [closeButton setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(clearSearchContent) forControlEvents:UIControlEventTouchUpInside];
        [rightView addSubview:closeButton];
        _searchButton.rightView = rightView;
        _searchButton.rightViewMode = UITextFieldViewModeWhileEditing;
        
        _searchButton.returnKeyType = UIReturnKeySearch;
        _searchButton.delegate = self;
    }
    return _searchButton;
}

- (void)clearSearchContent{
    self.searchButton.text = nil;
}

@end
