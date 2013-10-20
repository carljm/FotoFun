#import "HomeController.h"
#import "ImagePickerProvider.h"


@interface HomeController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) ImagePickerProvider *imagePickerProvider;
@property (assign, nonatomic) CGFloat firstX;
@property (assign, nonatomic) CGFloat firstY;

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

#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(0, 0, 300, 400);
        [imageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidPan:)]];
        imageView.userInteractionEnabled = YES;
        [self.view addSubview:imageView];
    }];
}

#pragma mark - Private

- (void)didTapPictureButton:(id) sender
{
    UIImagePickerController *picker = [self.imagePickerProvider picker];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imageViewDidPan:(UIPanGestureRecognizer *) sender
{
    CGPoint translatedPoint = [sender translationInView:sender.view.superview];

    if([sender state] == UIGestureRecognizerStateBegan) {
        self.firstX = sender.view.center.x;
        self.firstY = sender.view.center.y;
    }

    translatedPoint = CGPointMake(self.firstX+translatedPoint.x, self.firstY+translatedPoint.y);
    [sender.view setCenter:translatedPoint];

}
@end
