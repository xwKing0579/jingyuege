//
//  DBIpAddressModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/6/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBIpAddressModel : NSObject
@property (nonatomic, strong) NSArray <DBIpAddressModel *>*ip_map;
@end

@interface DBIpAddressMapModel : NSObject
@property (nonatomic, copy) NSString *domain;
@property (nonatomic, strong) NSArray *ip;
@end

NS_ASSUME_NONNULL_END
