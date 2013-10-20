#import "HomeController.h"
#import "ImagePickerProvider.h"
#import <QuartzCore/QuartzCore.h>


@interface HomeController () <UINavigationControllerDelegate>

@property (strong, nonatomic) ImagePickerProvider *imagePickerProvider;
@property (strong, nonatomic) NSMutableDictionary *panningStartCenters;
@property (assign, nonatomic) NSUInteger imageViewCount;

@end


@implementation HomeController

- (id)initWithImagePickerProvider:(ImagePickerProvider *)imagePickerProvider
{
    self = [super init];
    if (self) {
        self.imagePickerProvider = imagePickerProvider;
        self.imageViewCount = 0;
        self.panningStartCenters = [NSMutableDictionary new];
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *buttonTitle = [self.imagePickerProvider buttonTitle];

    self.pictureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.pictureButton.tintColor = [UIColor whiteColor];
    self.pictureButton.backgroundColor = [UIColor orangeColor];
    self.pictureButton.layer.cornerRadius = 6.0f;
    [self.pictureButton addTarget:self
                           action:@selector(didTapPictureButton:)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.pictureButton setTitle:buttonTitle forState:UIControlStateNormal];

    [self.view addSubview:self.pictureButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.pictureButton.frame = CGRectMake(0, 0, 120, 44);
    self.pictureButton.center = [self.view convertPoint:self.view.center fromView:self.view.superview];
}

#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImageView *imageView = [[UIImageView alloc] initWithImage:info[UIImagePickerControllerOriginalImage]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(0, 0, 300, 400);

        UIGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)];
        [imageView addGestureRecognizer:recognizer];
        imageView.userInteractionEnabled = YES;
        [self.view addSubview:imageView];

        self.imageViewCount++;
        imageView.tag = self.imageViewCount;
        self.panningStartCenters[@(imageView.tag)] = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    }];
}

#pragma mark - Private

- (void)didTapPictureButton:(id) sender
{
    UIImagePickerController *picker = [self.imagePickerProvider picker];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)viewDidPan:(UIPanGestureRecognizer *) recognizer
{
    UIView *translatedView = recognizer.view;
    NSValue *translatedStartCenterPointValue = self.panningStartCenters[@(translatedView.tag)];
    CGPoint panStartCenter = [translatedStartCenterPointValue CGPointValue];

    if(recognizer.state == UIGestureRecognizerStateBegan) {
        panStartCenter.x = translatedView.center.x;
        panStartCenter.y = translatedView.center.y;
        self.panningStartCenters[@(translatedView.tag)] = [NSValue valueWithCGPoint:panStartCenter];
    }

    CGPoint translatedPoint = [recognizer translationInView:recognizer.view.superview];
    translatedPoint = CGPointMake(panStartCenter.x + translatedPoint.x, panStartCenter.y + translatedPoint.y);
    [recognizer.view setCenter:translatedPoint];
}

@end
