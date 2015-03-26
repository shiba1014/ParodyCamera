//
//  ViewController.h
//  parodyCamera
//
//  Created by Paul McCartney on 2015/02/10.
//  Copyright (c) 2015年 shiba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLSimpleCamera.h"

@interface CameraViewController : UIViewController<UIGestureRecognizerDelegate>

@property (weak,nonatomic) UIImage *parodyImage;
@property (strong,nonatomic) IBOutlet UIImageView *parodyImageView;

@end

