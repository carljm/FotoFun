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
        if (![fileManager createDirectoryAtPath:cachesDirectory
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
