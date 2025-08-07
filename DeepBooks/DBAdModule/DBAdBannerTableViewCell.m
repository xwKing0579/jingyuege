//
//  DBAdBannerTableViewCell.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/5/21.
//

#import "DBAdBannerTableViewCell.h"

@implementation DBAdBannerTableViewCell

- (void)setObjView:(UIView *)objView{
    _objView = objView;
    
    [self.contentView removeAllSubView];
    if (objView.width > 0){
        objView.frame = CGRectMake(0, 0, UIScreen.screenWidth, objView.height/objView.width*UIScreen.screenWidth);
        [self.contentView addSubview:objView];
        [objView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(UIScreen.screenWidth);
            make.height.mas_equalTo(objView.height);
        }];
    }
}

@end
