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


    context(@"when a camera is available", ^{
        beforeEach(^{
            __sourceType = UIImagePickerControllerSourceTypeCamera;
            subject = [[[ImagePickerProvider alloc] init] autorelease];
        });

        it(@"has the correct buttonTitle", ^{
            subject.buttonTitle should equal(@"Take a Photo");
        });

        it(@"should have the correct imagePickerSourceType", ^{
            subject.picker.sourceType should equal(UIImagePickerControllerSourceTypeCamera);
        });

    });

    context(@"when a camera is not available", ^{
        beforeEach(^{
            __sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            subject = [[[ImagePickerProvider alloc] init] autorelease];
        });

        it(@"has the correct buttonTitle", ^{
            subject.buttonTitle should equal(@"Select a Photo");
        });

        it(@"should have the correct imagePickerSourceType", ^{
            subject.picker.sourceType should equal(UIImagePickerControllerSourceTypePhotoLibrary);
        });

    });
});

SPEC_END
