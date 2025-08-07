//
//  BFRouterTableViewCell.m
//  QuShou
//
//  Created by 王祥伟 on 2024/4/8.
//

#import "BFRouterTableViewCell.h"
@interface BFRouterTableViewCell ()
@property (nonatomic, strong) DBBaseLabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@end

@implementation BFRouterTableViewCell

+ (instancetype)initWithTableView:(UITableView *)tableView withObject:(NSString *)title{
    BFRouterTableViewCell *cell = [self initWithTableView:tableView];
    cell.titleLabel.text = title;
    return cell;
}

- (void)setUpSubViews{
    [self.contentView bf_addSubviews:@[self.titleLabel,self.lineView,self.arrowImageView]];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(-10);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(12);
    }];
}

- (DBBaseLabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[DBBaseLabel alloc] init];
        _titleLabel.font = UIFont.font14;
        _titleLabel.textColor = UIColor.bf_c333333;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIView *)lineView{
    if (!_lineView){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColor.bf_cEEEEEE;
    }
    return _lineView;
}

- (UIImageView *)arrowImageView{
    if (!_arrowImageView){
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"arrow"];
    }
    return _arrowImageView;
}
@end

