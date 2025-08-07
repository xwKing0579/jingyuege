//
//  DBContryCodeViewController.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/23.
//

#import "DBBaseAdViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBContryCodeViewController : DBBaseAdViewController
@property (nonatomic, copy) void (^changeContryCodeBlock)(NSString *contryCode);
@end

NS_ASSUME_NONNULL_END
