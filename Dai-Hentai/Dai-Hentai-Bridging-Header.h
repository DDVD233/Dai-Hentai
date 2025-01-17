//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "DBUserPreference.h"
#import "SettingViewController.h"
#import "HentaiInfo.h"
#import "HentaiDownloadCenter.h"
#import "DBGallery.h"
#import "UIAlertController+Block.h"
#import "GalleryViewController.h"
#import "HentaiImagesManager.h"

@interface NSObject (OwO)

- (BOOL)respondsOwO:(NSString *)selector;
- (void)performVoidOwO:(NSString *)aSelector withObject:(id)object;

@end

@implementation NSObject (OwO)

- (BOOL)respondsOwO:(NSString *)selector {
    return [self respondsToSelector:NSSelectorFromString(selector)];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void)performVoidOwO:(NSString *)aSelector withObject:(id)object {
    [self performSelector:NSSelectorFromString(aSelector) withObject:object];
}
#pragma clang diagnostic pop

@end
