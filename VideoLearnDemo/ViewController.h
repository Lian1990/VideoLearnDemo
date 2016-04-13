//
//  ViewController.h
//  VideoLearnDemo
//
//  Created by LIAN on 16/4/5.
//  Copyright © 2016年 com.Alice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

#import <MediaPlayer/MPMoviePlayerController.h>

#import "MovieShowView.h"

@interface ViewController : UIViewController<MovieShowViewDelegate>

{
    CGRect _oriframe;
    BOOL _isFullScreen;
}

@property (strong,nonatomic) MovieShowView *showView;

@property (strong,nonatomic) MPMoviePlayerController *player;

@end

