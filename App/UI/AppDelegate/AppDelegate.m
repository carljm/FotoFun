#import "AppDelegate.h"
#import "HomeController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIScreen *screen = [UIScreen mainScreen];
    CGRect bounds = [screen bounds];
    self.window = [[UIWindow alloc] initWithFrame:bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[HomeController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
