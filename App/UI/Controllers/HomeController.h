#import <UIKit/UIKit.h>


@class ImagePickerProvider;


@interface HomeController : UIViewController

@property (strong, nonatomic) UIButton *pictureButton;
@property (strong, nonatomic, readonly) ImagePickerProvider *imagePickerProvider;

- (id)initWithImagePickerProvider:(ImagePickerProvider *)imagePickerProvider;

@end
