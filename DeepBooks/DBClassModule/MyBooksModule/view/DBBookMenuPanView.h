//
//  DBBookMenuPanView.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/31.
//

#import <HWPanModal/HWPanModal.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBBookMenuPanView : HWPanModalContentView
@property (nonatomic, copy) DBBookModel *model;

@property (nonatomic, copy) void (^clickCatalogsIndex)(void);
@end

NS_ASSUME_NONNULL_END
