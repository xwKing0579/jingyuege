//
//  DBBaseTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import "DBBaseTableViewCell.h"

@implementation DBBaseTableViewCell

+ (instancetype)initWithTableView:(UITableView *)tableView{
    return [self initWithTableView:tableView andIdentifier:NSStringFromClass([self class])];
}

+ (instancetype)initWithTableView:(UITableView *)tableView andIdentifier:(NSString *)identifier{
    id cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = DBColorExtension.noColor;
        self.contentView.backgroundColor = DBColorExtension.noColor;
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews{}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self setUserInterfaceStyleOrLight];
}

- (void)setUserInterfaceStyleOrLight{}
@end
