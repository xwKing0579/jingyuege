//
//  DBContryCodeModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBContryCodeModel : NSObject
@property (nonatomic, copy) NSString *short_name;
@property (nonatomic, copy) NSString *regexp_literal;
@property (nonatomic, assign) NSInteger len;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *word;
@end

NS_ASSUME_NONNULL_END
