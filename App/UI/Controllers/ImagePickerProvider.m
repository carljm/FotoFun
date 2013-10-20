#import "ImagePickerProvider.h"


@interface ImagePickerProvider ()

@property (assign, nonatomic) UIImagePickerControllerSourceType pickerControllerSourceType;

@end


@implementation ImagePickerProvider

- (id)init
{
    self = [super init];
    if (self) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.pickerControllerSourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            self.pickerControllerSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    return self;
}

- (NSString *)buttonTitle
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return @"Take a Photo";
    } else {
        return @"Select a Photo";
    }
}

- (UIImagePickerController *)picker
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = self.pickerControllerSourceType;
    return picker;
}

@end
