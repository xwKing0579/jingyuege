//
//  DBServiceViewController.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/21.
//

#import "DBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBServiceViewController : DBBaseViewController
// 0 产品特性, 1 软件许可及用户服务协议, 2 免责声明
@property (nonatomic, assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
