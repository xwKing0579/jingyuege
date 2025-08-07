//
//  DBBaseViewController.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import <UIKit/UIKit.h>
#import "DBBaseTableView.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBBaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) DBBaseLabel *navLabel;
@property (nonatomic, strong) DBBaseTableView *listRollingView;
@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong, nullable) UIView *adContainerView;

- (void)setUpSubViews;
- (void)getDataSource;

- (BOOL)hiddenLeft;
- (void)setDarkModel;

@end

NS_ASSUME_NONNULL_END
