//
//  MovieShowView.h
//  VideoLearnDemo
//
//  Created by LIAN on 16/4/6.
//  Copyright © 2016年 com.Alice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "PlayerView.h"


@protocol MovieShowViewDelegate <NSObject>

@optional

-(void)clickBtnFullScreen:(BOOL)isFull;

@end

typedef enum {
    Button_topBack = 0,
    Button_topShare,
    Button_footPlay,
    Button_footScale,
    
}ButtonClickType;

@interface MovieShowView : UIView <UIGestureRecognizerDelegate>

{
    BOOL _isPlay;
    BOOL _isShowDetail;
    BOOL _isFullScreen;
    CGRect  _oriFrame;
    
}

@property (strong,nonatomic) UIView *bgView;
@property (strong,nonatomic) UIView *topView;
@property (strong,nonatomic) UIView *bottomView;
@property (strong,nonatomic) UIView *topBGView;
@property (strong,nonatomic) UIView *bottomBGView;


@property (strong,nonatomic) UIButton *topBackBtn;
@property (strong,nonatomic) UIButton *topShareBtn;
@property (strong,nonatomic) UILabel  *topTitleLabel;
@property (strong,nonatomic) NSString *topTitleText;

@property (strong,nonatomic) UIButton *footPlayBtn;
@property (strong,nonatomic) UILabel  *footShowTimeLabel;
@property (strong,nonatomic) UIButton *footScaleBtn;

@property (strong,nonatomic) UISlider *timeSlider;

-(id)initWithFrame:(CGRect)frame andTitle:(NSString *)movieName;

//player
@property (strong,nonatomic) AVPlayer     *player;
@property (strong,nonatomic) AVPlayerItem *playerItem;
@property (strong,nonatomic) PlayerView   *playView;
@property (strong,nonatomic) NSString *totalTime;

@property (weak,nonatomic) id<MovieShowViewDelegate> delegate;

@end
