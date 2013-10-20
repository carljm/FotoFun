#import "SpecHelper+App.h"
#import "HomeController.h"
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


SPEC_BEGIN(HomeControllerSpec)

describe(@"HomeController", ^{
    __block HomeController *subject;
    __block ImagePickerProvider *provider;

    beforeEach(^{
        provider = [[ImagePickerProvider new] autorelease];
        subject = [[[HomeController alloc] initWithImagePickerProvider:provider] autorelease];
    });

    it(@"should have a take picture button", ^{
        subject.view.subviews should contain(subject.pictureButton);
    });

    describe(@"selecting an image", ^{
        beforeEach(^{
            // make isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera return NO
            [UIImagePickerController redirectClassSelector:@selector(isSourceTypeAvailable:)
                                                        to:@selector(specIsSourceTypeAvailable:)
                                             andRenameItTo:@selector(originalIsSourceTypeAvailable:)];
        });

        afterEach(^{
            [UIImagePickerController redirectClassSelector:@selector(isSourceTypeAvailable:)
                                                        to:@selector(originalIsSourceTypeAvailable:)
                                             andRenameItTo:@selector(specIsSourceTypeAvailable:)];
        });

        context(@"when no camera is available", ^{

            beforeEach(^{
                __sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                subject.view should_not be_nil;
            });

            it(@"should have the correct button title", ^{
                [subject.pictureButton titleForState:UIControlStateNormal] should equal(@"Select a Photo");
            });

            context(@"when the take picture button is tapped", ^{
                beforeEach(^{
                    [subject.pictureButton tap];
                });

                it(@"should show a picker controller for selecting a picture", ^{
                    UIImagePickerController *picker = (UIImagePickerController *)subject.presentedViewController;
                    picker.sourceType should equal(UIImagePickerControllerSourceTypePhotoLibrary);
                });
            });
        });

        context(@"when a camera is available", ^{

            beforeEach(^{
                __sourceType = UIImagePickerControllerSourceTypeCamera;
                subject.view should_not be_nil;
            });

            it(@"should have the correct button title", ^{
                [subject.pictureButton titleForState:UIControlStateNormal] should equal(@"Take a Photo");
            });

            context(@"when the take picture button is tapped", ^{
                beforeEach(^{
                    [subject.pictureButton tap];
                });

                it(@"should show a picker controller for taking a picture", ^{
                    UIImagePickerController *picker = (UIImagePickerController *)subject.presentedViewController;
                    picker.sourceType should equal(UIImagePickerControllerSourceTypeCamera);
                });
            });

        });

    });
});

SPEC_END
