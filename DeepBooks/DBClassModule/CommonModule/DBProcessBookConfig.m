//
//  DBProcessBookConfig.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/2.
//

#import "DBProcessBookConfig.h"

@implementation DBProcessBookConfig

+ (NSArray *)bookTagList:(DBBookModel *)model{
    NSMutableArray *bookTags = [NSMutableArray array];
    
    [bookTags addObject:[self bookStausDesc:model.status]];
    if (model.ltype) [bookTags addObject:model.ltype];
    NSInteger works = model.words_number > 0 ? model.words_number : model.total_count;
    [bookTags addObject:[self bookWordNumberDesc:works]];
    return bookTags;
}

+ (NSString *)bookStausDesc:(NSInteger)status{
    return status == 1 ? @"已完结" : @"连载中";
}

+ (NSString *)bookStausSimpleDesc:(NSInteger)status{
    return status == 1 ? @"完结" : @"连载";
}

+ (NSString *)bookWordNumberDesc:(NSInteger)works{
    if (works >= 10000){
        return [NSString stringWithFormat:@"%ld万字",works/10000];
    }
    return @"少于1万字";
}

@end
