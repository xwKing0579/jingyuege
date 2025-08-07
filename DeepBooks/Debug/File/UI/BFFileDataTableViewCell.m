//
//  BFFileDataTableViewCell.m
//  OCProject
//
//  Created by 王祥伟 on 2023/12/15.
//

#import "BFFileDataTableViewCell.h"

@interface BFFileDataTableViewCell ()
@property (nonatomic, strong) UITextView *titleTextView;
@property (nonatomic, strong) UITextView *contentTextView;

@end

@implementation BFFileDataTableViewCell

+ (instancetype)initWithTableView:(UITableView *)tableView withObject:(NSDictionary *)dict{
    BFFileDataTableViewCell *cell = [self initWithTableView:tableView];
    cell.titleTextView.text = dict.allKeys.firstObject;
    cell.contentTextView.text = [NSString stringWithFormat:@"%@",dict.allValues.firstObject];
    return cell;
}

- (void)setUpSubViews{
    [self.contentView bf_addSubviews:@[self.titleTextView,self.contentTextView]];
    
    [self.titleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(128);
    }];
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleTextView.mas_right).offset(-0.5);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-5);
    }];
}

- (UITextView *)titleTextView{
    if (!_titleTextView) {
        _titleTextView = [[UITextView alloc] init];
        _titleTextView.scrollEnabled = NO;
        _titleTextView.userInteractionEnabled = NO;
        _titleTextView.font = UIFont.fontBold14;
        _titleTextView.textColor = UIColor.bf_c000000;
        _titleTextView.layer.borderColor = UIColor.bf_c333333.CGColor;
        _titleTextView.layer.borderWidth = 0.5;
        _titleTextView.textContainerInset = UIEdgeInsetsMake(10, 15, 10, 15);
    }
    return _titleTextView;
}

- (UITextView *)contentTextView{
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.scrollEnabled = NO;
        _contentTextView.userInteractionEnabled = NO;
        _contentTextView.font = UIFont.font14;
        _contentTextView.textColor = UIColor.bf_c000000;
        _contentTextView.layer.borderColor = UIColor.bf_c333333.CGColor;
        _contentTextView.layer.borderWidth = 0.5;
        _contentTextView.textContainerInset = UIEdgeInsetsMake(10, 15, 10, 15);
    }
    return _contentTextView;
}

@end
