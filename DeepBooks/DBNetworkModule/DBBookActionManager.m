//
//  DBBookActionManager.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/7/4.
//

#import "DBBookActionManager.h"

@implementation DBBookActionManager

+ (void)bookFirstRecommendation{
    DBAppSetting *setting = DBAppSetting.setting;
    if (DBCommonConfig.isLogin || setting.isRec) return;
 
    DBHotBookModel *recBookModel = DBCommonConfig.appConfig.hot_book;
    NSArray *recList = recBookModel.book_default;
    if ([setting.sex isEqualToString:@"1"]){
        recList = recBookModel.book_male;
    }else if ([setting.sex isEqualToString:@"2"]){
        recList = recBookModel.book_female;
    }
    if (recList.count == 0) return;

    NSMutableArray *recBookList = [NSMutableArray array];
    dispatch_group_t group = dispatch_group_create();
    for (NSString *bookId in recList) {
        dispatch_group_enter(group);
        [DBAFNetWorking getServiceRequestType:DBLinkBookSelfRec combine:bookId parameInterface:nil modelClass:DBBookModel.class serviceData:^(BOOL successfulRequest, DBBookModel *result, NSString * _Nullable message) {
            if (successfulRequest){
                [recBookList addObject:result];
            }
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (recList.count == recBookList.count){
            //排序
            
            NSMutableArray *sortBookList = [NSMutableArray array];
            for (NSString *bookid in recList) {
                NSString *bookId = [NSString stringWithFormat:@"%@",bookid];
                for (DBBookModel *bookModel in recBookList) {
                    if ([bookId isEqualToString:bookModel.book_id]){
                        if (![sortBookList containsObject:bookModel]){
                            [sortBookList addObject:bookModel];
                        }
                        break;
                    }
                }
            }
            
            BOOL recSuccess = [DBBookModel insertCollectBooks:sortBookList];
            if (recSuccess){
                setting.isRec = YES;
                [setting reloadSetting];
                [NSNotificationCenter.defaultCenter postNotificationName:DBUpdateCollectBooks object:nil];
            }
        }
    });
}

@end
