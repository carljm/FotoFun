#import "HomeController.h"
#import "ImagePickerProvider.h"


@interface HomeController ()

@property (strong, nonatomic) ImagePickerProvider *imagePickerProvider;

@end


@implementation HomeController

- (id)initWithImagePickerProvider:(ImagePickerProvider *)imagePickerProvider
{
    self = [super init];
    if (self) {
        self.imagePickerProvider = imagePickerProvider;
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pictureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.pictureButton.backgroundColor = [UIColor orangeColor];
    NSString *buttonTitle = [self.imagePickerProvider buttonTitle];
    [self.pictureButton setTitle:buttonTitle forState:UIControlStateNormal];
    [self.pictureButton sizeToFit];

    [self.pictureButton addTarget:self
                           action:@selector(didTapPictureButton:)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pictureButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.pictureButton.frame = CGRectMake(0, 0, 100, 44);
    self.pictureButton.center = [self.view convertPoint:self.view.center fromView:self.view.superview];
}

#pragma mark - Private

- (void)didTapPictureButton:(id) sender
{
    UIImagePickerController *picker = [self.imagePickerProvider picker];
    [self presentViewController:picker animated:YES completion:nil];
}

@end
