#import "AppDelegate.h"
#import "HomeController.h"
#import "ImagePickerProvider.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIScreen *screen = [UIScreen mainScreen];
    CGRect bounds = [screen bounds];
    self.window = [[UIWindow alloc] initWithFrame:bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[HomeController alloc] initWithImagePickerProvider:[[ImagePickerProvider alloc] init]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
