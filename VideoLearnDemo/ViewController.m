//
//  ViewController.m
//  VideoLearnDemo
//
//  Created by LIAN on 16/4/5.
//  Copyright © 2016年 com.Alice. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize player = _player;
@synthesize showView = _showView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    CGRect frame = [UIScreen mainScreen].bounds;
    
    NSLog(@"开始 %@",NSStringFromCGRect (frame));
    // Do any additional setup after loading the view, typically from a nib.
    
    _showView = [[MovieShowView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 340) andTitle:@"火锅英雄"];
    _showView.backgroundColor = [UIColor blackColor];
    _showView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _showView.delegate = self;
    [self.view addSubview:_showView];

    _oriframe = self.view.frame;
    

    
}

-(void)clickBtnFullScreen:(BOOL)isFull
{
    
    if (isFull) {
        _isFullScreen = YES;
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        [UIView animateWithDuration:duration animations:^{
                        
            CGRect frame = [UIScreen mainScreen].bounds;
                        
             NSLog(@"aaaaaaaaa %@",NSStringFromCGRect (frame));
            //方法一
//             _showView.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
//            CGAffineTransform theTransform = CGAffineTransformMakeTranslation(0,0);
//            theTransform = CGAffineTransformRotate(theTransform,M_PI_2);
////            theTransform = CGAffineTransformTranslate(theTransform, frame.size.height*0.436, 0);//6s 163.5f
////            theTransform = CGAffineTransformTranslate(theTransform, 198.0f, 0);//6sp 198.0f
//            theTransform = CGAffineTransformTranslate(theTransform, 114.0f, 0);//5c
////            theTransform = CGAffineTransformTranslate(theTransform, 70.0f, 0);//4s
//
//            [_showView setTransform:theTransform];
//            _showView.center = CGPointMake(frame.size.width/2, frame.size.height/2);

            //方法二 优化
           
            _showView.transform = CGAffineTransformMakeRotation(M_PI_2);
             _showView.bounds = CGRectMake(0, 0, frame.size.height, frame.size.width);
            _showView.center = CGPointMake(frame.size.width/2, frame.size.height/2);

            
            NSLog(@" 旋转之后的 _showView nnnnnnnnnn %@",NSStringFromCGRect (_showView.bounds));
            
        } completion:^(BOOL finished) {
            _showView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [_showView layoutIfNeeded];
        }];
    }
    else
    {
        _isFullScreen = NO;
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        [UIView animateWithDuration:duration animations:^{
            CGRect frame = [UIScreen mainScreen].bounds;
             _showView.transform = CGAffineTransformIdentity;
            _showView.bounds = CGRectMake(0, 0, frame.size.width, 340);
           
        } completion:^(BOOL finished) {
            _showView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [_showView layoutIfNeeded];
        }];
    }
}

//导航条的动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
}
-(BOOL)shouldAutorotate
{
       return  NO;//不允许随着设备旋转
    
//    if (_isFullScreen) {
//        return YES;
//    }
//    else return NO;
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0

- (NSUInteger)supportedInterfaceOrientations

#else

- (UIInterfaceOrientationMask)supportedInterfaceOrientations

#endif
{
    return UIInterfaceOrientationMaskAll;
    // 直接返回支持的旋转方向，该方法在iPad上的默认返回值是UIInterfaceOrientationMaskAll，
    //iPhone上的默认返回值是UIInterfaceOrientationMaskAllButUpsideDown
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
