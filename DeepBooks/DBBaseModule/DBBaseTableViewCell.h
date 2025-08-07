//
//  DBBaseTableViewCell.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBBaseTableViewCell : UITableViewCell
+ (instancetype)initWithTableView:(UITableView *)tableView;//同一个cell复用
+ (instancetype)initWithTableView:(UITableView *)tableView andIdentifier:(NSString *)identifier;//多个cell建议使用这种，内存优化
- (void)setUpSubViews;

- (void)setUserInterfaceStyleOrLight;
@end

NS_ASSUME_NONNULL_END
