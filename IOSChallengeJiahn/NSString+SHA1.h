

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (SHA1)
/*!
 * @discussion Method that encrypts a NSString using SHA1
 */
- (NSString *)sha1;

@end
