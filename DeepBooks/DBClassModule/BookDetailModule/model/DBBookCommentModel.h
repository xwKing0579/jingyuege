//
//  DBBookCommentModel.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/31.
//

#import <Foundation/Foundation.h>
@class DBBookFavModel,DBBookReplyModel;
NS_ASSUME_NONNULL_BEGIN

@interface DBBookCommentModel : NSObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *comment_id;
@property (nonatomic, copy) NSString *reply_comment_id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger fav;
@property (nonatomic, strong) NSArray <DBBookFavModel *>*fav_arr;
@property (nonatomic, assign) BOOL is_choice;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *os;
@property (nonatomic, strong) NSArray <DBBookReplyModel *>*reply_arr;
@property (nonatomic, assign) NSInteger reply_count;

@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, assign) NSInteger comment_number;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, assign) CGFloat score;
@end

@interface DBBookFavModel : NSObject
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *avatar;
@end

@interface DBBookReplyModel : NSObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *comment_id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *fav_state;
@property (nonatomic, assign) BOOL floor_host;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *level_name;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *os;
@property (nonatomic, strong) DBBookReplyModel *reply_to_comment;
@property (nonatomic, copy) NSString *user_id;
@end
NS_ASSUME_NONNULL_END
