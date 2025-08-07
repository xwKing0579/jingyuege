//
//  DBBaseTableView.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/4/3.
//

#import "DBBaseTableView.h"

@implementation DBBaseTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return self.multipleGestures;
}

@end
