//
//  BFNetworkMonitorTableViewCell.m
//  OCProject
//
//  Created by 王祥伟 on 2023/12/29.
//

#import "BFNetworkMonitorTableViewCell.h"
#import "BFNetworkModel.h"
@interface BFNetworkMonitorTableViewCell ()
@property (nonatomic, strong) DBBaseLabel *titleLabel;
@property (nonatomic, strong) DBBaseLabel *contentLabel;
@property (nonatomic, strong) DBBaseLabel *dateLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@end

@implementation BFNetworkMonitorTableViewCell

+ (instancetype)initWithTableView:(UITableView *)tableView withObject:(BFNetworkModel *)model{
    BFNetworkMonitorTableViewCell *cell = [self initWithTableView:tableView];
    cell.titleLabel.text = model.url;
    cell.contentLabel.text  = [NSString stringWithFormat:@"%@ > [%ld]",model.httpMethod,(long)model.statusCode];
    cell.contentLabel.backgroundColor = (model.statusCode == 0 || model.statusCode == 200) ? UIColor.whiteColor : UIColor.redColor;
    cell.dateLabel.text = [NSString stringWithFormat:@"%@ 耗时：%.3lf",model.startTime,model.totalDuration];
    return cell;
}

- (void)setUpSubViews{
    [self.contentView bf_addSubviews:@[self.titleLabel,self.contentLabel,self.dateLabel,self.lineView,self.arrowImageView]];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-25);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(4);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(4);
        make.right.mas_equalTo(-25);
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
        _titleLabel.font = UIFont.font12;
        _titleLabel.textColor = UIColor.bf_c333333;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (DBBaseLabel *)contentLabel{
    if (!_contentLabel){
        _contentLabel = [[DBBaseLabel alloc] init];
        _contentLabel.font = UIFont.fontBold14;
        _contentLabel.textColor = UIColor.bf_c000000;
        _contentLabel.numberOfLines = 0;
        _contentLabel.layer.cornerRadius = 2;
        _contentLabel.layer.masksToBounds = YES;
    }
    return _contentLabel;
}

- (DBBaseLabel *)dateLabel{
    if (!_dateLabel){
        _dateLabel = [[DBBaseLabel alloc] init];
        _dateLabel.font = UIFont.font12;
        _dateLabel.textColor = UIColor.bf_c333333;
    }
    return _dateLabel;
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
