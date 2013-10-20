#import "SpecHelper+App.h"
#import "ImagePickerProvider.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

static UIImagePickerControllerSourceType __sourceType;

@interface UIImagePickerController (Spec)

+ (BOOL)specIsSourceTypeAvailable:(UIImagePickerControllerSourceType)sourceType;

@end

@implementation UIImagePickerController (Spec)

+ (BOOL)specIsSourceTypeAvailable:(UIImagePickerControllerSourceType)sourceType
{
    return sourceType == __sourceType;
}

@end

SPEC_BEGIN(ImagePickerProviderSpec)

describe(@"ImagePickerProvider", ^{
    __block ImagePickerProvider *subject;

    beforeEach(^{
        [UIImagePickerController redirectClassSelector:@selector(isSourceTypeAvailable:)
                                                    to:@selector(specIsSourceTypeAvailable:)
                                         andRenameItTo:@selector(originalIsSourceTypeAvailable:)];
    });

    afterEach(^{
        [UIImagePickerController redirectClassSelector:@selector(isSourceTypeAvailable:)
                                                    to:@selector(originalIsSourceTypeAvailable:)
                                         andRenameItTo:@selector(specIsSourceTypeAvailable:)];
    });

    void (^imagePickerProviderDetectsCameraAvailability)(UIImagePickerControllerSourceType, NSString *) = ^(UIImagePickerControllerSourceType sourceType, NSString *buttonTitle){
        beforeEach(^{
            __sourceType = sourceType;
            subject = [[[ImagePickerProvider alloc] init] autorelease];
        });

        it(@"has the correct buttonTitle", ^{
            subject.buttonTitle should equal(buttonTitle);
        });

        it(@"should have the correct imagePickerSourceType", ^{
            subject.picker.sourceType should equal(sourceType);
        });
    };

    context(@"when there is a camera", ^{
        imagePickerProviderDetectsCameraAvailability(UIImagePickerControllerSourceTypeCamera, @"Take a Photo");
    });

    context(@"when there is not a camera", ^{
        imagePickerProviderDetectsCameraAvailability(UIImagePickerControllerSourceTypePhotoLibrary, @"Select a Photo");
    });
});

SPEC_END
