//
//  ViewController.m
//  parodyCamera
//
//  Created by Paul McCartney on 2015/02/10.
//  Copyright (c) 2015年 shiba. All rights reserved.
//

#import "CameraViewController.h"
#import "ViewUtils.h"
#import "ImageViewController.h"
#import "CLImageEditor.h"

@interface CameraViewController ()<CLImageEditorDelegate>
@property (strong, nonatomic) LLSimpleCamera *camera;
@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *flashButton;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UISlider *alphaSlider;

@end

@implementation CameraViewController
@synthesize parodyImage,parodyImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    // ----- initialize camera -------- //
    
    // create camera vc
    self.camera = [[LLSimpleCamera alloc] initWithQuality:CameraQualityPhoto andPosition:CameraPositionBack];
    
    // attach to a view controller
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    
    // read: http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
    // you probably will want to set this to YES, if you are going view the image outside iOS.
    self.camera.fixOrientationAfterCapture = NO;
    
    // take the required actions on a device change
    __weak typeof(self) weakSelf = self;
    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice * device) {
        
        NSLog(@"Device changed.");
        
        // device changed, check if flash is available
        if([camera isFlashAvailable]) {
            weakSelf.flashButton.hidden = NO;
        }
        else {
            weakSelf.flashButton.hidden = YES;
        }
        
        weakSelf.flashButton.selected = NO;
    }];
    
    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
        NSLog(@"Camera error: %@", error);
    }];
    
    // ----- camera buttons -------- //
    
    // snap button to capture image
    self.snapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.snapButton.frame = CGRectMake(0, 0, 60.0f, 60.0f);
    self.snapButton.clipsToBounds = YES;
    self.snapButton.layer.cornerRadius = self.snapButton.width / 2.0f;
    self.snapButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.snapButton.layer.borderWidth = 2.0f;
    self.snapButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    self.snapButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.snapButton.layer.shouldRasterize = YES;
    [self.snapButton addTarget:self action:@selector(snapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.snapButton];
    
    // button to toggle flash
    self.flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flashButton.frame = CGRectMake(0, 0, 16.0f + 20.0f, 24.0f + 20.0f);
    //MARK: shiba
    [self.flashButton setImage:[UIImage imageNamed:@"camera-flash-off.png"] forState:UIControlStateNormal];
    [self.flashButton setImage:[UIImage imageNamed:@"camera-flash-on.png"] forState:UIControlStateSelected];
//    [self.flashButton setTitle:@"フラッシュオン" forState:UIControlStateNormal];
//    [self.flashButton setTitle:@"フラッシュオフ" forState:UIControlStateSelected];
    self.flashButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashButton];
    
    // button to toggle camera positions
    self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchButton.frame = CGRectMake(0, 0, 29.0f + 20.0f, 22.0f + 20.0f);
    [self.switchButton setImage:[UIImage imageNamed:@"camera-switch.png"] forState:UIControlStateNormal];
//    [self.switchButton setTitle:@"カメラ切替" forState:UIControlStateNormal];
    self.switchButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.switchButton addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.switchButton];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(5, 3, 50, 50);
    //[self.backButton setImage:[UIImage imageNamed:@"camera-switch.png"] forState:UIControlStateNormal];
    [self.backButton setTitle:@"戻る" forState:UIControlStateNormal];
    self.backButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
//*    parodyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, self.view.bounds.size.width, self.view.bounds.size.height - 88)];
    
    NSLog(@"height:%f", self.view.bounds.size.height);
    //parodyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    //*[parodyImageView setContentMode:UIViewContentModeScaleAspectFill];
    parodyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height - 138)];
    [parodyImageView setContentMode:UIViewContentModeScaleAspectFit];
    parodyImageView.backgroundColor = [UIColor yellowColor];
    NSLog(@"parodyImageView.h:%f", parodyImageView.bounds.size.height);
    NSLog(@"parodyImage.h:%f", parodyImage.size.height);
    //MARK:parody Image
    parodyImageView.image = parodyImage;
    parodyImageView.alpha = 0.5;
    parodyImageView.userInteractionEnabled = YES;
    [self.view addSubview:parodyImageView];
    
    /* 上スワイプ */
    UISwipeGestureRecognizer* swipeUpGesture =
    [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(view_SwipeUp:)];
    
    // 左スワイプを認識するように設定
    swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
    
    // ビューにジェスチャーを追加
    [self.view addGestureRecognizer:swipeUpGesture];
    
    UISwipeGestureRecognizer* swipeDownGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(view_SwipeDown:)];
    
    swipeDownGesture.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:swipeDownGesture];
    
    //self.parodyImage = [[UIImageView alloc] initWithImage:_parodyIcon];
    //[self.view bringSubviewToFront:self.parodyImage];
    //_parodyImage.userInteractionEnabled = YES;
    
//    self.alphaSlider = [[UISlider alloc] initWithFrame:CGRectMake(10,530,300,10)];
//    [self.alphaSlider addTarget:self action:@selector(hoge:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:self.alphaSlider];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // start the camera
    [self.camera start];
}

- (void)viewDidAppear:(BOOL)animated {
    
    CGRect innerFrame = AVMakeRectWithAspectRatioInsideRect(self.parodyImageView.image.size, self.parodyImageView.bounds);
    
    NSLog(@"parodyImageView.image === %@", NSStringFromCGRect(innerFrame));
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // stop the camera
    [self.camera stop];
}

/* camera buttons */
- (void)switchButtonPressed:(UIButton *)button {
    [self.camera togglePosition];
}

- (void)flashButtonPressed:(UIButton *)button {
    
    if(self.camera.cameraFlash == CameraFlashOff) {
        self.camera.cameraFlash = CameraFlashOn;
        self.flashButton.selected = YES;
    }
    else {
        self.camera.cameraFlash = CameraFlashOff;
        self.flashButton.selected = NO;
    }
}

- (void)snapButtonPressed:(UIButton *)button {
    
    // capture
    [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        if(!error) {
            
            // we should stop the camera, since we don't need it anymore. We will open a new vc.
            // this very important, otherwise you may experience memory crashes
            [camera stop];
            
            // show the image
//            ImageViewController *imageVC = [[ImageViewController alloc] initWithImage:image];
//            [self presentViewController:imageVC animated:NO completion:nil];
            CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image];
            editor.delegate = self;
            
            
            CLImageToolInfo *tool1 = [editor.toolInfo subToolInfoWithToolName:@"CLToneCurveTool" recursive:NO];
            //tool.title = @"TestTitle";
            tool1.available = NO;     // if available is set to NO, it is removed from the menu view.
            //tool.dockedNumber = -1;  // Bring to top
            //tool.iconImagePath = @"test.png"
            
            CLImageToolInfo *tool2 = [editor.toolInfo subToolInfoWithToolName:@"CLAdjustmentTool" recursive:NO];
            tool2.available = NO;
            
            CLImageToolInfo *tool3 = [editor.toolInfo subToolInfoWithToolName:@"CLEffectTool" recursive:NO];
            tool3.available = NO;
            
            CLImageToolInfo *tool4 = [editor.toolInfo subToolInfoWithToolName:@"CLBlurTool" recursive:NO];
            tool4.available = NO;
            
            CLImageToolInfo *tool5 = [editor.toolInfo subToolInfoWithToolName:@"CLRotateTool" recursive:NO];
            tool5.available = NO;
            
            CLImageToolInfo *tool6 = [editor.toolInfo subToolInfoWithToolName:@"CLClippingTool" recursive:NO];
            tool6.available = NO;
            
            CLImageToolInfo *tool7 = [editor.toolInfo subToolInfoWithToolName:@"CLResizeTool" recursive:NO];
            tool7.available = NO;
            
            CLImageToolInfo *tool8 = [editor.toolInfo subToolInfoWithToolName:@"CLToneCurveTool" recursive:NO];
            tool8.available = NO;
            
            CLImageToolInfo *tool9 = [editor.toolInfo subToolInfoWithToolName:@"CLTextTool" recursive:NO];
            tool9.available = NO;
            
            CLImageToolInfo *tool10 = [editor.toolInfo subToolInfoWithToolName:@"CLDrawTool" recursive:NO];
            tool10.available = NO;
            
            CLImageToolInfo *tool11 = [editor.toolInfo subToolInfoWithToolName:@"CLEmoticonTool" recursive:NO];
            tool11.available = NO;
            
            CLImageToolInfo *tool12 = [editor.toolInfo subToolInfoWithToolName:@"CLSplashTool" recursive:NO];
            tool12.available = NO;
            
//            CLImageToolInfo *tool13 = [editor.toolInfo subToolInfoWithToolName:@"CLStickerTool" recursive:NO];
//            tool13.dockedNumber = -1;
            
            NSLog(@"%@", editor.toolInfo);
            NSLog(@"%@", editor.toolInfo.toolTreeDescription);
            
            [self presentViewController:editor animated:YES completion:nil];
        }
    } exactSeenImage:YES];
}

- (void)hoge:(UISlider *)slider{
    NSLog(@"slider:%@",slider);
}

-(void)backButtonPressed:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/* other lifecycle methods */
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.camera.view.frame = self.view.contentBounds;
    
    self.snapButton.center = self.view.contentCenter;
    self.snapButton.bottom = self.view.height - 15;
    
    self.flashButton.center = self.view.contentCenter;
    self.flashButton.top = 5.0f;
    
    self.switchButton.top = 5.0f;
    self.switchButton.right = self.view.width - 5.0f;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

//- (void)setGestureRecognizer{
//    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDetected:);
//                                                 [self.view addGestureRecognizer:pinchRecognizer];
//                                                 }

- (void)view_SwipeUp:(UISwipeGestureRecognizer *)sender
{
    if(parodyImageView.alpha < 1){
        parodyImageView.alpha = parodyImageView.alpha + 0.1;
    }
}

-(void)view_SwipeDown:(UISwipeGestureRecognizer *)sender
{
    if(parodyImageView.alpha > 0){
        parodyImageView.alpha = parodyImageView.alpha - 0.1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
