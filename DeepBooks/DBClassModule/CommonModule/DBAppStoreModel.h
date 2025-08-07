//
//  DBAppStoreModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBAppStoreModel : NSObject
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *releaseNotes;
@property (nonatomic, copy) NSString *trackViewUrl;
@property (nonatomic, copy) NSString *currentVersionReleaseDate;
@end

NS_ASSUME_NONNULL_END
