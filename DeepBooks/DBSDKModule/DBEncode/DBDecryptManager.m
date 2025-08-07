//
//  DBDecryptManager.m
//  DeepBooks
//
//  Created by 王祥伟 on 2025/2/27.
//

#import "DBDecryptManager.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

#define FBENCRYPT_ALGORITHM     kCCAlgorithmAES128
#define FBENCRYPT_BLOCK_SIZE    kCCBlockSizeAES128
#define FBENCRYPT_KEY_SIZE      kCCKeySizeAES256
@implementation DBDecryptManager

+ (NSString *)decryptText:(NSString *)text ver:(NSInteger)ver{
    NSString *result = @"";
    switch (ver) {
        case 0:
            result = [[NSString alloc] initWithData:[GTMBase64 decodeString:text] encoding:NSUTF8StringEncoding];
            break;
        case 1:
            result = [self aesDecryptSerivceContent:text];
            break;
        default:
            break;
    }
    return result;
}

+ (NSString *)aesDecryptSerivceContent:(NSString *)text{
    NSMutableData *decryptData = [NSMutableData dataWithData:[GTMBase64 decodeString:text]];
    NSString *baseStr = [[NSString alloc] initWithData:decryptData encoding:NSASCIIStringEncoding];
    if (baseStr.length <= 16) return @"";
    
    [decryptData replaceBytesInRange:NSMakeRange(0, 16) withBytes:NULL length:0];
    [decryptData replaceBytesInRange:NSMakeRange(decryptData.length - 16, 16) withBytes:NULL length:0];
    
    NSString *key = [baseStr substringToIndex:16];
    NSData *data256 = [self sha256byStr:key];
    
    NSString * th = [baseStr substringWithRange:NSMakeRange(baseStr.length-16, 16)];
    NSString *md5th = [th md532BitLower];
    Byte bt[16] = {0};
    
    for (int a = 0; a < 16; a ++) {
        NSString * str = [md5th substringWithRange:NSMakeRange(a, 1)];
        NSInteger value = [str characterAtIndex:0];
        NSString * str1 = [th substringWithRange:NSMakeRange(a, 1)];
        NSInteger value1 = [str1 characterAtIndex:0];
        NSInteger c = ~(value ^ value1);
        
        if (c < 0) {
            c += 256;
        }
        bt[a] = c;
    }
    
    NSData *data1 = [NSData dataWithBytes:bt length:16];
    NSData *decryptedData1 = [self decryptData:decryptData key:data256 iv:data1];
    NSString *aesDecryptString = [[NSString alloc] initWithData:decryptedData1 encoding:NSUTF8StringEncoding];
    return aesDecryptString;
}

+ (NSData *)sha256byStr:(NSString *)shaStr {
    NSData *data = [shaStr dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    NSData *adata = [[NSData alloc] initWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    return adata;
}

+ (NSData*)decryptData:(NSData*)data key:(NSData*)key iv:(NSData*)iv{
    NSData* result = nil;

    // setup key
    unsigned char cKey[FBENCRYPT_KEY_SIZE];
    bzero(cKey, sizeof(cKey));
    [key getBytes:cKey length:FBENCRYPT_KEY_SIZE];

    // setup iv
    char cIv[FBENCRYPT_BLOCK_SIZE];
    bzero(cIv, FBENCRYPT_BLOCK_SIZE);
    if (iv) {
        [iv getBytes:cIv length:FBENCRYPT_BLOCK_SIZE];
    }

    // setup output buffer
    size_t bufferSize = [data length] + FBENCRYPT_BLOCK_SIZE;
    void *buffer = malloc(bufferSize);

    // do decrypt
    size_t decryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          FBENCRYPT_ALGORITHM,
                                          kCCOptionPKCS7Padding,
                                          cKey,
                                          FBENCRYPT_KEY_SIZE,
                                          cIv,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &decryptedSize);

    if (cryptStatus == kCCSuccess) {
        result = [NSData dataWithBytesNoCopy:buffer length:decryptedSize];
    } else {
        free(buffer);
        NSLog(@"[ERROR] failed to decrypt| CCCryptoStatus: %d", cryptStatus);
    }

    return result;
}
@end
