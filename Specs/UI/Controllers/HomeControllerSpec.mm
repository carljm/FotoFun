#import "SpecHelper+App.h"
#import "HomeController.h"
#import "ImagePickerProvider.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(HomeControllerSpec)

describe(@"HomeController", ^{
    __block HomeController *subject;
    __block ImagePickerProvider *provider;

    beforeEach(^{
        provider = nice_fake_for([ImagePickerProvider class]);
        subject = [[[HomeController alloc] initWithImagePickerProvider:provider] autorelease];
    });

    it(@"should have a take picture button", ^{
        subject.view.subviews should contain(subject.pictureButton);
    });

    describe(@"picking an image", ^{
        __block UIViewController *picker;

        beforeEach(^{
            picker = nice_fake_for([UIImagePickerController class]);
            provider stub_method(@selector(buttonTitle)).and_return(@"My Special Title");
            provider stub_method(@selector(picker)).and_return(picker);
            subject.view should_not be_nil;
        });

        it(@"should have the correct button title", ^{
            [subject.pictureButton titleForState:UIControlStateNormal] should equal(@"My Special Title");
        });

        context(@"when the take picture button is tapped", ^{
            beforeEach(^{
                [subject.pictureButton tap];
            });

            it(@"should show a picker controller for selecting a picture", ^{
                subject.presentedViewController should be_same_instance_as(picker);
            });
        });
    });

    describe(@"as an image picker controller delegate", ^{
        context(@"after an image has been picked", ^{
            __block UIImagePickerController *picker;
            __block UIImage *image;
            __block NSDictionary *imageInfo;

            beforeEach(^{
                CGSize size = CGSizeMake(100.0f, 200.0f);
                image = [SpecHelper imageWithSize:size];

                imageInfo = @{UIImagePickerControllerOriginalImage: image};
                picker = (UIImagePickerController *)[[UIViewController new] autorelease];
                [subject imagePickerController:picker didFinishPickingMediaWithInfo:imageInfo];
            });

            describe(@"the new image view", ^{
                __block UIImageView *imageView;
                beforeEach(^{
                    imageView = [subject.view.subviews lastObject];
                });

                it(@"should have been added to the main view", ^{
                    imageView should be_instance_of([UIImageView class]);
                });

                it(@"should display the picked image", ^{
                    imageView.image should be_same_instance_as(image);
                });

            });
        });
    });
});

SPEC_END
