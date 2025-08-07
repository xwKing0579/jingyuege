//
//  NSObject+Category.h
//  OCProject
//
//  Created by 王祥伟 on 2023/12/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Category)

- (NSArray <NSDictionary *>*)propertyList;
- (NSArray <NSDictionary *>*)customPropertyList:(NSArray <NSString *>*)properties;

@end

NS_ASSUME_NONNULL_END
