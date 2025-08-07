//
//  BFUserDefaultsTableViewCell.m
//  OCProject
//
//  Created by 王祥伟 on 2023/12/19.
//

#import "BFUserDefaultsTableViewCell.h"

@interface BFUserDefaultsTableViewCell ()
@property (nonatomic, strong) DBBaseLabel *titleLabel;
@property (nonatomic, strong) DBBaseLabel *contentLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation BFUserDefaultsTableViewCell

+ (instancetype)initWithTableView:(UITableView *)tableView withKey:(NSString *)key withValue:(id)value{
    BFUserDefaultsTableViewCell *cell = [self initWithTableView:tableView];
    cell.titleLabel.text = key;
    cell.contentLabel.text = [NSString stringWithFormat:@"class：%@\n%@",[value class],value];
    return cell;
}

- (void)setUpSubViews{
    [self.contentView bf_addSubviews:@[self.titleLabel,self.contentLabel,self.lineView]];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-15);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(4);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-10);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (DBBaseLabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[DBBaseLabel alloc] init];
        _titleLabel.font = UIFont.fontBold16;
        _titleLabel.textColor = UIColor.bf_c000000;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (DBBaseLabel *)contentLabel{
    if (!_contentLabel){
        _contentLabel = [[DBBaseLabel alloc] init];
        _contentLabel.font = UIFont.font14;
        _contentLabel.textColor = UIColor.bf_c000000;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIView *)lineView{
    if (!_lineView){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColor.bf_cEEEEEE;
    }
    return _lineView;
}
@end
