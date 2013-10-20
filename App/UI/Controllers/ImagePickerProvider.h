#import <Foundation/Foundation.h>


@interface ImagePickerProvider : NSObject

- (NSString *)buttonTitle;

- (UIImagePickerController *)picker;

@end
