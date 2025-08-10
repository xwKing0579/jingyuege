//
//  YYKVStorage+Safe.m
//  FXTP
//
//  Created by 王祥伟 on 2024/10/21.
//

#import "YYKVStorage+Safe.h"
#import <UIKit/UIKit.h>
#import <time.h>
 
#if __has_include(<sqlite3.h>)
#import <sqlite3.h>
#else
#import "sqlite3.h"
#endif

@interface YYKVStorage ()
{
    dispatch_queue_t _trashQueue;
    
    NSString *_path;
    NSString *_dbPath;
    NSString *_dataPath;
    NSString *_trashPath;
    
    sqlite3 *_db;
    CFMutableDictionaryRef _dbStmtCache;
    NSTimeInterval _dbLastOpenErrorTime;
    NSUInteger _dbOpenErrorCount;
}
@end
@implementation YYKVStorage (Safe)

       

#pragma mark - db
 
- (BOOL)_dbOpen {
    if (_db) return YES;
    
    int result = sqlite3_open(_dbPath.UTF8String, &_db);
    if (result == SQLITE_OK) {
        CFDictionaryKeyCallBacks keyCallbacks = kCFCopyStringDictionaryKeyCallBacks;
        CFDictionaryValueCallBacks valueCallbacks = {0};
        _dbStmtCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &keyCallbacks, &valueCallbacks);
        _dbLastOpenErrorTime = 0;
        _dbOpenErrorCount = 0;
        return YES;
    } else {
        _db = NULL;
        if (_dbStmtCache) {
            CFIndex size = CFDictionaryGetCount(_dbStmtCache);
            CFTypeRef *valuesRef = (CFTypeRef *)malloc(size * sizeof(CFTypeRef));
            
            CFDictionaryGetKeysAndValues(_dbStmtCache, NULL, (const void **)valuesRef);
            const sqlite3_stmt **stmts = (const sqlite3_stmt **)valuesRef;
            for (CFIndex i = 0; i < size; i ++) {
                sqlite3_stmt *stmt = stmts[i];
                sqlite3_finalize(stmt);
            }
            free(valuesRef);
            CFRelease(_dbStmtCache);
        }
        _dbStmtCache = NULL;
        _dbLastOpenErrorTime = CACurrentMediaTime();
        _dbOpenErrorCount++;
        return NO;
    }
}



- (BOOL)_dbClose {
    if (!_db) return YES;
    
    int  result = 0;
    BOOL retry = NO;
    BOOL stmtFinalized = NO;
    
    if (_dbStmtCache) {
        CFIndex size = CFDictionaryGetCount(_dbStmtCache);
        CFTypeRef *valuesRef = (CFTypeRef *)malloc(size * sizeof(CFTypeRef));
        CFDictionaryGetKeysAndValues(_dbStmtCache, NULL, (const void **)valuesRef);
        const sqlite3_stmt **stmts = (const sqlite3_stmt **)valuesRef;
        for (CFIndex i = 0; i < size; i ++) {
            sqlite3_stmt *stmt = stmts[i];
            sqlite3_finalize(stmt);
        }
        free(valuesRef);
        CFRelease(_dbStmtCache);
    }
    _dbStmtCache = NULL;
    
    do {
        retry = NO;
        result = sqlite3_close(_db);
        if (result == SQLITE_BUSY || result == SQLITE_LOCKED) {
            if (!stmtFinalized) {
                stmtFinalized = YES;
                sqlite3_stmt *stmt;
                while ((stmt = sqlite3_next_stmt(_db, nil)) != 0) {
                    sqlite3_finalize(stmt);
                    retry = YES;
                }
            }
        } else if (result != SQLITE_OK) {
        }
    } while (retry);
    _db = NULL;
    return YES;
}
@end
