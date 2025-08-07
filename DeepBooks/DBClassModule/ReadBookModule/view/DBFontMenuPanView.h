//
//  DBFontMenuPanView.h
//  DeepBooks
//
//  Created by 王祥伟 on 2025/3/14.
//

#import <HWPanModal/HWPanModal.h>
#import "DBFontModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBFontMenuPanView : HWPanModalContentView
@property (nonatomic, copy) void (^fontSwitchBlock)(DBFontModel *fontModel);
@end

NS_ASSUME_NONNULL_END
