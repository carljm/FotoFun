#import "SpecHelper+App.h"


@implementation SpecHelper (App)

+ (void)beforeEach
{
    NSString *cachesDirectory = [self userDirectory:NSCachesDirectory];
    NSString *libraryDirectory = [self userDirectory:NSLibraryDirectory];
    NSString *documentDirectory = [self userDirectory:NSDocumentDirectory];

    NSArray *directoryPaths = @[cachesDirectory, libraryDirectory, documentDirectory];

    NSFileManager *fileManager = [self fileManager];

    for (NSString *directoryPath in directoryPaths) {
        NSError *errorCreatingDirectory = nil;
        if (![fileManager createDirectoryAtPath:directoryPath
                    withIntermediateDirectories:YES
                                     attributes:nil
                                          error:&errorCreatingDirectory])
        {
            NSLog(@"Error creating directory at '%@': %@, %@", directoryPath, [errorCreatingDirectory localizedDescription], [errorCreatingDirectory userInfo]);
        }
    }
}

+ (void)afterEach
{
    sleep(0.2f);
}

+ (UIImage *)imageWithSize:(CGSize)size
{
    UIImage *image = [UIImage new];

    UIGraphicsBeginImageContextWithOptions(size, YES, image.scale);

    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
    [image drawInRect:rect];
    image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Private

+ (NSString *)userDirectory:(NSSearchPathDirectory)directory
{
    return [[[[self fileManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path];
}

+ (NSFileManager *)fileManager
{
    return [NSFileManager defaultManager];
}

@end
