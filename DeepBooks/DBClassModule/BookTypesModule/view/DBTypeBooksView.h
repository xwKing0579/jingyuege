//
//  DBTypeBooksView.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/22.
//

#import <UIKit/UIKit.h>
#import "DBBookTypesModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBTypeBooksView : UIView
@property (nonatomic, copy) DBBookTypesGenderModel *typeModel;

@property (nonatomic, strong) NSString *stype; //分类
@property (nonatomic, strong) NSString *end;   //连载 完结
@property (nonatomic, strong) NSString *score; //评分

@property (nonatomic, copy) void (^filterBlock)(void);
@end

NS_ASSUME_NONNULL_END
