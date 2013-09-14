#import "SpecHelper+App.h"
#import "AppDelegate.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(AppDelegateSpec)

describe(@"AppDelegate", ^{
    __block AppDelegate *appDelegate;
    beforeEach(^{
        appDelegate = [[[AppDelegate alloc] init] autorelease];
    });

    describe(@"starting up", ^{
        __block BOOL launchedSuccessfully;
        beforeEach(^{
            launchedSuccessfully = [appDelegate application:nil didFinishLaunchingWithOptions:nil];
        });

        it(@"should launch successfully", ^{
            launchedSuccessfully should be_truthy;
        });

        describe(@"the window", ^{
            __block UIWindow *window;
            beforeEach(^{
                window = appDelegate.window;
            });

            it(@"should have an appropriately colored background", ^{
                window.backgroundColor should equal([UIColor whiteColor]);
            });

            it(@"should be key", ^{
                window.isKeyWindow should be_truthy;
            });

            it(@"should be visible", ^{
                window.hidden should_not be_truthy;
            });
        });
    });
});

SPEC_END
