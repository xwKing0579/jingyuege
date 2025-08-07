//
//  DBBookEndView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/18.
//

#import "DBBookEndView.h"
#import "DBBookSourceUpdateModel.h"
@interface DBBookEndView ()
@property (nonatomic, strong) DBBaseLabel *titlePageLabel;
@end

@implementation DBBookEndView

- (instancetype)init{
    if (self == [super init]){
        [self setUpSubViews];
        
    }
    return self;
}

- (void)setUpSubViews{
    [self addSubview:self.titlePageLabel];
    [self.titlePageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(UIScreen.navbarHeight+100);
    }];
    
    NSArray *titles = @[@"刷新重试",@"查看其他书源",@"查看书架",@"查看书城"];
    if (DBCommonConfig.switchAudit){
        titles = @[@"刷新重试",@"查看其他书源",@"查看书架"];
    }
    __block UIView *lastView = self.titlePageLabel;
    [titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = idx;
        button.titleLabel.font = DBFontExtension.pingFangMediumLarge;
        button.layer.cornerRadius = 24;
        button.layer.masksToBounds = YES;
        button.backgroundColor = DBColorExtension.coralColor;
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:DBColorExtension.whiteColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.top.mas_equalTo(lastView.mas_bottom).offset(30);
            make.height.mas_equalTo(48);
        }];
        
        lastView = button;
    }];

}

- (void)clickAction:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
            [self checkbookSourceUpdate];
            break;
        case 1:
            [DBRouter openPageUrl:DBBookSource params:@{@"bookId":self.model.bookId,kDBRouterDrawerSideslip:@1}];
            break;
        case 2:
            [DBRouter closePage:nil params:@{kDBRouterPathRootIndex:@0}];
            break;
        case 3:
            [DBRouter closePage:nil params:@{kDBRouterPathRootIndex:@1,kDBRouterPathNoAnimation:@1}];
            break;
        default:
            break;
    }
}

- (void)checkbookSourceUpdate{
    [UIScreen.currentViewController.view showHudLoading];
    [DBAFNetWorking getServiceRequestType:DBLinkBookCatalog combine:self.model.site_path_reload parameInterface:nil modelClass:DBBookSourceUpdateModel.class serviceData:^(BOOL successfulRequest, DBBookSourceUpdateModel *result, NSString * _Nullable message) {
        [UIScreen.currentViewController.view removeHudLoading];
        if (successfulRequest){
            NSTimeInterval timeInterval = self.model.updated_at.timeToDate.timeStampInterval;

            if (timeInterval < result.updated_at){
                [NSNotificationCenter.defaultCenter postNotificationName:DBBookSourceUpdate object:nil];
            }else{
                [UIScreen.currentViewController.view showAlertText:@"暂无章节更新"];
            }
        }
    }];
}

- (DBBaseLabel *)titlePageLabel{
    if (!_titlePageLabel){
        _titlePageLabel = [[DBBaseLabel alloc] init];
        _titlePageLabel.font = DBFontExtension.bodySixTenFont;
        _titlePageLabel.textColor = DBColorExtension.charcoalColor;
        _titlePageLabel.text = @"已经是最后一章，试试其他书源";
    }
    return _titlePageLabel;
}

@end
