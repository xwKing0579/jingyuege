//
//  DBBookDetailModel.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/2.
//

#import "DBBookDetailModel.h"

@implementation DBBookDetailModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"author_book": DBBooksDataModel.class,
        @"relevant_book":   DBBooksDataModel.class,
    };
}



- (instancetype)init{
    if (self == [super init]){
        self.numberOfLines = 3;
    }
    return self;
}
@end


@implementation DBBookDetailCustomModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"bookList": DBBooksDataModel.class,
    };
}
@end
