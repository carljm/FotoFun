#import "HomeController.h"

@implementation HomeController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pictureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.pictureButton.backgroundColor = [UIColor orangeColor];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.pictureButton setTitle:@"Take a Photo" forState:UIControlStateNormal];
    } else {
        [self.pictureButton setTitle:@"Select a Photo" forState:UIControlStateNormal];
    }
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
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
}

@end
