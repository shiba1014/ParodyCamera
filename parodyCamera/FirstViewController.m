//
//  FirstViewController.m
//  parodyCamera
//
//  Created by Paul McCartney on 2015/03/15.
//  Copyright (c) 2015年 shiba. All rights reserved.
//

#import "FirstViewController.h"
#import "PhotoTweaksViewController.h"
#import "FeHourGlass.h"
#import "UIColor+FlatUI.h"
#import "FUIButton.h"

@interface FirstViewController ()

@property (weak, nonatomic) IBOutlet FUIButton *openLibraryButton;

@end

@implementation FirstViewController{
    
    FeHourGlass *loadingView;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    loadingView = [[FeHourGlass alloc] initWithView:[[UIView alloc] initWithFrame:self.view.frame]];
    
    self.openLibraryButton.buttonColor = [UIColor turquoiseColor];
    self.openLibraryButton.shadowColor = [UIColor greenSeaColor];
    self.openLibraryButton.shadowHeight = 3.0f;
    self.openLibraryButton.cornerRadius = 6.0f;
    self.openLibraryButton.font = [UIFont boldSystemFontOfSize:16];
    [self.openLibraryButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.openLibraryButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [self.openLibraryButton addTarget:self action:@selector(openLibrary:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)openLibrary{
    
    [UIView animateWithDuration:0 animations:^{
        [self showLoadingView];
    } completion:^(BOOL finished) {
        //画像の取得先をフォトライブラリに設定
        UIImagePickerControllerSourceType soureceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        //フォトライブラリが使用可能かどうか判定する
        if([UIImagePickerController isSourceTypeAvailable:soureceType]){
            //UIImagePickerを初期化・生成
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            //画像の取得先をフォトライブラリに設定
            picker.sourceType = soureceType;
            //デリゲードを設定
            picker.delegate = self;
            //フォトライブラリをモーダルビューとして表示する
            [self presentViewController:picker animated:YES completion:^{
                [loadingView removeFromSuperview];
            }];
        }
    }];
    
}

-(void)showLoadingView{
    [loadingView setAlpha:0.0];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.75];
    [loadingView setAlpha:1];
    [self.view addSubview:loadingView];
    [loadingView show];
}

//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
//    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
//    ImageEditViewController *IEVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageEdit"];
//    IEVC.selectImg = image;
//    [self.view addSubview:IEVC.self.view];
//    //[self presentViewController:IEVC animated:YES completion:nil];
//}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
//    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
//    ImageEditViewController *IEVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageEdit"];
//    IEVC.selectImg = image;
//    [self.view addSubview:IEVC.self.view];
    PhotoTweaksViewController *photoTweaksViewController = [[PhotoTweaksViewController alloc] initWithImage:image];
    photoTweaksViewController.delegate = self;
    [picker pushViewController:photoTweaksViewController animated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(void)openLibrary:(UIButton*)button{
    [UIView animateWithDuration:0.0 animations:^{
        [self showLoadingView];
    } completion:^(BOOL finished) {
        //画像の取得先をフォトライブラリに設定
        UIImagePickerControllerSourceType soureceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        //フォトライブラリが使用可能かどうか判定する
        if([UIImagePickerController isSourceTypeAvailable:soureceType]){
            //UIImagePickerを初期化・生成
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            //画像の取得先をフォトライブラリに設定
            picker.sourceType = soureceType;
            //デリゲードを設定
            picker.delegate = self;
            //フォトライブラリをモーダルビューとして表示する
            [self presentViewController:picker animated:YES completion:^{
                [loadingView removeFromSuperview];
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
