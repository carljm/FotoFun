#import <UIKit/UIKit.h>


@class ImagePickerProvider;


@interface HomeController : UIViewController <UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIButton *pictureButton;
@property (strong, nonatomic, readonly) ImagePickerProvider *imagePickerProvider;

- (id)initWithImagePickerProvider:(ImagePickerProvider *)imagePickerProvider;

@end
