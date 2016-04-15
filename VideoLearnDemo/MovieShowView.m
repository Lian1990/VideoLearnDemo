//
//  MovieShowView.m
//  VideoLearnDemo
//
//  Created by LIAN on 16/4/6.
//  Copyright © 2016年 com.Alice. All rights reserved.
//

#import "MovieShowView.h"

@implementation MovieShowView

@synthesize bgView =_bgView;
@synthesize topView = _topView;
@synthesize bottomView = _bottomView;
@synthesize topBGView = _topBGView;
@synthesize bottomBGView = _bottomBGView;
@synthesize topBackBtn = _topBackBtn;
@synthesize topShareBtn = _topShareBtn;
@synthesize topTitleLabel = _topTitleLabel;
@synthesize topTitleText = _topTitleText;
@synthesize footPlayBtn = _footPlayBtn;
@synthesize footScaleBtn = _footScaleBtn;
@synthesize footShowTimeLabel = _footShowTimeLabel;
@synthesize timeSlider = _timeSlider;
@synthesize player = _player;
@synthesize playerItem = _playerItem;
@synthesize playView = _playView;
@synthesize gestureView = _gestureView;

-(id)initWithFrame:(CGRect)frame andTitle:(NSString *)movieName
{
    self = [super initWithFrame:frame];
    if (self) {
        _topTitleText = movieName;
        [self buildControlStage];
        _isPlay = YES;
        _isShowDetail = YES;
        _oriFrame = frame;
    }
    return self;
}

-(void)buildControlStage
{
    CGFloat HEIGHT;
    CGFloat WIDTH = self.frame.size.width;
    if (self.bounds.size.height/6 > 60) {
        HEIGHT = 60;
    }
    else if (self.bounds.size.height/6 < 40)
    {
         HEIGHT = 40;
    }
    else
        HEIGHT = self.bounds.size.height/6;
    
    
    _bgView = [[UIView alloc]initWithFrame:self.bounds];
    _bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgView];
    
    //topV
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _topView.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_topView];
    
    _topBGView = [[UIView alloc]initWithFrame:_topView.frame];
    _topBGView.backgroundColor = [UIColor whiteColor];
    _topBGView.alpha = 0.5;
    [_topView addSubview:_topBGView];
    
    //bottom
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _bgView.bounds.size.height-HEIGHT, WIDTH, HEIGHT)];
    _bottomView.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_bottomView];
    
    _bottomBGView = [[UIView alloc]initWithFrame:_topView.frame];
    _bottomBGView.backgroundColor = [UIColor whiteColor];
    _bottomBGView.alpha = 0.5;
    [_bottomView addSubview:_bottomBGView];
    
    //player
    
    _playView = [[PlayerView alloc]initWithFrame:self.bounds];
    [self insertSubview:_playView belowSubview:_bgView];
    //http://v.jxvdy.com/sendfile/w5bgP3A8JgiQQo5l0hvoNGE2H16WbN09X-ONHPq3P3C1BISgf7C-qVs6_c8oaw3zKScO78I--b0BGFBRxlpw13sf2e54QA
    //http://video.leying365.com/trailer/201603/04/1457089593.53.mp4
     NSURL *videoUrl = [NSURL URLWithString:@"http://video.leying365.com/trailer/201603/04/1457089593.53.mp4"];
    _playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];//status 准备播放 失败 未知
    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];//ranges 缓存了多少
    
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    _playView.player = _player;
    [_playView.player play];
    
    
    // 添加视频播放结束通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    //设备前台后台通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appEnterBackground:) name:@"DidEnterBackground" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DidBecomeActive:) name:@"DidBecomeActive" object:nil];
    
    //手势控制
    _gestureView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT, WIDTH, self.bounds.size.height - 2*HEIGHT)];
    _gestureView.backgroundColor = [UIColor clearColor];
    [self addSubview:_gestureView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTapsRequired = 1;
    [_gestureView addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandler:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandler:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandler:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandler:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    
    [_gestureView addGestureRecognizer:swipeDown];
    [_gestureView addGestureRecognizer:swipeLeft];
    [_gestureView addGestureRecognizer:swipeRight];
    [_gestureView addGestureRecognizer:swipeUp];
    
    self.autoresizesSubviews = YES;
    
    [self biuldSubStage];
    
}
-(void)biuldSubStage
{
    //top
    _topBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _topBackBtn.frame = CGRectMake(10, _topView.bounds.size.height/2 -10, 25, 26);
    [_topBackBtn setTitle:@"B" forState:UIControlStateNormal];
    
    
    _topShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _topShareBtn.frame = CGRectMake(_topView.bounds.size.width-35, _topBackBtn.frame.origin.y, 25, 26);
    [_topShareBtn setImage:[UIImage imageNamed:@"share-button"] forState:UIControlStateNormal];
    
    
    _topTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, _topBackBtn.frame.origin.y, _topView.bounds.size.width-80, 26)];
    _topTitleLabel.backgroundColor = [UIColor clearColor];
    _topTitleLabel.textColor = [UIColor whiteColor];
    _topTitleLabel.textAlignment = NSTextAlignmentCenter;
    _topTitleLabel.text = _topTitleText;
    
    [_topView addSubview:_topBackBtn];
    [_topView addSubview:_topShareBtn];
    [_topView addSubview:_topTitleLabel];
    
    //bottom
    _footPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _footPlayBtn.frame = CGRectMake(10, _bottomView.bounds.size.height/2 -13, 40, 40);
    [_footPlayBtn setImage:[UIImage imageNamed:@"pause-button"] forState:UIControlStateNormal];
    
    _footScaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _footScaleBtn.frame = CGRectMake(_bottomView.bounds.size.width-35, _footPlayBtn.frame.origin.y, 40, 40);
    [_footScaleBtn setImage:[UIImage imageNamed:@"fullscreen-button"] forState:UIControlStateNormal];
    
    
    _timeSlider = [[UISlider alloc]initWithFrame:CGRectMake(40, _bottomView.bounds.size.height/2 -4, _bottomView.bounds.size.width-80, 8)];
    _timeSlider.backgroundColor = [UIColor clearColor];
    _timeSlider.value = 0.0;
    _timeSlider.maximumValue = 1.0;
    _timeSlider.minimumValue = 0.0;
    [_timeSlider setThumbImage:[UIImage imageNamed:@"point.png"] forState:UIControlStateNormal];
    [_timeSlider setThumbImage:[UIImage imageNamed:@"point.png"] forState:UIControlStateHighlighted];
    
    
    [_bottomView addSubview:_footPlayBtn];
    [_bottomView addSubview:_footScaleBtn];
    [_bottomView addSubview:_timeSlider];
    
    //timelabel
    _footShowTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, _timeSlider.frame.origin.y +11,  _bottomView.bounds.size.width-140, 10)];
    _footShowTimeLabel.textAlignment = NSTextAlignmentRight;
    _footShowTimeLabel.textColor = [UIColor whiteColor];
    _footShowTimeLabel.font = [UIFont systemFontOfSize:10];
    [_bottomView addSubview:_footShowTimeLabel];
    
    //button的背景图
    
    _topBackBtn.imageView.contentMode = UIViewContentModeCenter;
    _topShareBtn.imageView.contentMode = UIViewContentModeCenter;
    _footPlayBtn.imageView.contentMode = UIViewContentModeCenter;
    _footScaleBtn.imageView.contentMode = UIViewContentModeCenter;
    
    [_topBackBtn setTag:Button_topBack];
    [_topShareBtn setTag:Button_topShare];
    [_footPlayBtn setTag:Button_footPlay];
    [_footScaleBtn setTag:Button_footScale];
    
    [_topBackBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topShareBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_footPlayBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_footScaleBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_timeSlider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];//滑动
    [_timeSlider addTarget:self action:@selector(sliderDragUp:) forControlEvents:UIControlEventTouchUpInside];//点击
    

}
// KVO方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            CMTime duration = _playerItem.duration;// 获取视频总长度
            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
            
            _totalTime = [self convertTime:totalSecond];
         
            NSLog(@"movie total duration:%f",CMTimeGetSeconds(duration));
            [self monitoringPlayback:self.playerItem];// 监听播放状态
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        // 计算缓冲进度
    }
}
- (void)monitoringPlayback:(AVPlayerItem *)playerItem {
    
    __weak typeof(self) weakSelf = self;
    [_playView.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒
        CGFloat totalSecond = playerItem.duration.value/playerItem.duration.timescale;
        CGFloat scaleCurrent = currentSecond/totalSecond;
        [weakSelf.timeSlider setValue:scaleCurrent animated:YES];
        NSString *timeString = [weakSelf convertTime:currentSecond];
        weakSelf.footShowTimeLabel.text = [NSString stringWithFormat:@"%@/%@",timeString,weakSelf.totalTime];
    }];
}
- (void)moviePlayDidEnd:(NSNotification *)notification {
    NSLog(@"Play end");
    
    __weak typeof(self) weakSelf = self;
    [_playView.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [weakSelf.timeSlider setValue:0.0 animated:YES];
        [weakSelf.footPlayBtn setImage:[UIImage imageNamed:@"play-button"] forState:UIControlStateNormal];
    }];
}
/**
 * 对于使用home键的监控
 */
- (void)appEnterBackground:(NSNotification *)notification
{
    [_playView.player pause];
}
- (void)DidBecomeActive:(NSNotification *)notification
{
    [_playView.player play];
}
/**
 *  时间转换
 */
- (NSString *)convertTime:(CGFloat)second{
    int seconds = (int) second % 60;
    int minutes = (int)(second / 60) % 60;
    int hours = second / 3600;
    
    NSString *showtimeNew;
    if (hours > 0 ) {
        showtimeNew = [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    }
    else if (minutes > 0 && hours <= 0)
    {
        showtimeNew = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
    else
    {
        showtimeNew = [NSString stringWithFormat:@"00:%02d",  seconds];
    }
    
    return showtimeNew;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat HEIGHT;
    CGFloat WIDTH = self.bounds.size.width;
    if (self.bounds.size.height/6 > 60) {
        HEIGHT = 60;
    }
    else if (self.bounds.size.height/6 < 40)
    {
        HEIGHT = 40;
    }
    else
        HEIGHT = self.bounds.size.height/6;
    
    CGRect tempFrame;
    tempFrame = _bgView.frame;
    tempFrame = self.bounds;
    _bgView.frame = tempFrame;
    
    _topView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
   
    _topBGView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    
    _bottomView.frame = CGRectMake(0, _bgView.bounds.size.height-HEIGHT, WIDTH, HEIGHT);
  
    _bottomBGView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    _gestureView.frame = CGRectMake(0, HEIGHT, WIDTH, self.bounds.size.height-HEIGHT*2);

    _playView.frame = tempFrame;
    
     _topBackBtn.frame = CGRectMake(5, _topView.bounds.size.height/2 -20, 40, 40);
    _topShareBtn.frame = CGRectMake(_topView.bounds.size.width-45, _topBackBtn.frame.origin.y, 40, 40);
    _topTitleLabel.frame = CGRectMake(50, _topBackBtn.frame.origin.y+6, _topView.bounds.size.width-90, 26);
    _footPlayBtn.frame = CGRectMake(5, _bottomView.bounds.size.height/2 -20, 40, 40);
     _footScaleBtn.frame = CGRectMake(_bottomView.bounds.size.width-45, _footPlayBtn.frame.origin.y, 40, 40);
    _timeSlider.frame = CGRectMake(40, _bottomView.bounds.size.height/2 -4, _bottomView.bounds.size.width-90, 8);
    _footShowTimeLabel.frame = CGRectMake(100, _timeSlider.frame.origin.y +11,  _bottomView.bounds.size.width-150, 10);
    
    //竖屏没有展示topView
//    if (_isFullScreen) {
//        _topView.hidden = NO;
//
//    }
//    else
//    {
//        _topView.hidden = YES;
//
//    }
    
}
#pragma mark === 页面上按钮事件处理
//按钮点击事件
-(void)buttonClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case Button_topBack:
        {
            NSLog(@"Button_topBack  返回按钮");
            
            if (_isFullScreen) {
                if (self.delegate) {
                    [self.delegate clickBtnFullScreen:NO];
                }
                
                [_footScaleBtn setImage:[UIImage imageNamed:@"fullscreen-button"] forState:UIControlStateNormal];
                _isFullScreen = NO;
                CGRect frame = self.frame;
                frame = _oriFrame;
                self.frame = frame;
                [self layoutSubviews];
            }
            else
            {
                __weak typeof(self) weakSelf = self;
                [_playView.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
                    [weakSelf.timeSlider setValue:0.0 animated:YES];
                    [_footPlayBtn setImage:[UIImage imageNamed:@"pause-button"] forState:UIControlStateNormal];
                }];
                [_playView.player pause];
                
                _isPlay = NO;
                
                if (self.delegate) {
                    [self.delegate clickBtnBack];
                }
            }
            
        }
            break;
        case Button_topShare:
        {
            NSLog(@"Button_topShare  分享按钮");
            if (self.delegate) {
                [self.delegate clickBtnShare];
            }
        }
            break;
        case Button_footPlay:
        {
            NSLog(@"Button_footPlay  播放按钮");
            [self playMoview];
        }
            break;
        case Button_footScale:
        {
            if (_isFullScreen) {
                
                if (self.delegate) {
                    [self.delegate clickBtnFullScreen:NO];
                }
                
                [_footScaleBtn setImage:[UIImage imageNamed:@"fullscreen-button"] forState:UIControlStateNormal];
                CGRect frame = self.frame;
                frame = _oriFrame;
                self.frame = frame;
                [self layoutSubviews];
                
            }
            else{
                if (self.delegate) {
                    [self.delegate clickBtnFullScreen:YES];
                }
                [_footScaleBtn setImage:[UIImage imageNamed:@"minimize-button"] forState:UIControlStateNormal];
                
                CGRect frame = self.frame;
                frame.size.height = [UIScreen mainScreen].bounds.size.width;
                frame.size.width = [UIScreen mainScreen].bounds.size.height;
                self.frame = frame;
                [self layoutSubviews];
                
            }
            _isFullScreen = !_isFullScreen;
            
        }
            break;
            
        default:
        {
            NSLog(@"????");
        }
            break;
    }
}
/**
 *  滑动条控制视频进度
 *
 */
-(void)sliderChange:(id)sender
{
    UISlider *slide = (UISlider *)sender;
    CGFloat nowSecond = slide.value;
    CMTime curTime = _playerItem.duration;
    curTime.value = nowSecond * _playerItem.duration.value;
    
     __weak typeof(self) weakSelf = self;
    [self.playView.player seekToTime:curTime completionHandler:^(BOOL finished) {
        [weakSelf.playView.player play];
    }];
    
}
-(void)sliderDragUp:(id)sender
{
     [_playView.player play];
}
//播放暂停按钮
-(void)playMoview
{
    if (_isPlay) {
        [_playView.player pause];
        [_footPlayBtn setImage:[UIImage imageNamed:@"play-button"] forState:UIControlStateNormal];
    }
    else
    {
        [_playView.player play];
        [_footPlayBtn setImage:[UIImage imageNamed:@"pause-button"] forState:UIControlStateNormal];
    }
    _isPlay = !_isPlay;
}

#pragma mark === 手势控制事件
-(void)tapAction:(UIGestureRecognizer *)sender
{
    //实现动画控制控制台
     _isShowDetail = !_isShowDetail;
    if (_isShowDetail) {
        CGRect frame = _topView.frame;
        frame.origin.y = 0;
        _topView.frame = frame;
        _topView.alpha = 1.0;
        [self detailViewMoveAnimation:_topView];
        
        CGRect footFrame = _bottomView.frame;
        footFrame.origin.y = self.bounds.size.height - _bottomView.frame.size.height;
        _bottomView.frame = footFrame;
        _bottomView.alpha = 1.0;
        [self detailViewMoveAnimation:_bottomView];
        
    }
    else
    {
        CGRect frame = _topView.frame;
        frame.origin.y = -frame.size.height;
        _topView.frame = frame;
        
        [self detailViewMoveAnimation:_topView];
        _topView.alpha = 0.0;
        
        CGRect footFrame = _bottomView.frame;
        footFrame.origin.y = self.bounds.size.height;
        _bottomView.frame = footFrame;
        [self detailViewMoveAnimation:_bottomView];
        _bottomView.alpha = 0.0;
        
    }
   
}
-(void)swipeHandler:(UISwipeGestureRecognizer *)sender
{
    UISwipeGestureRecognizer *gesture = (UISwipeGestureRecognizer *)sender;
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"left");
        CGFloat nowSecond = _timeSlider.value;
        CMTime curTime = _playerItem.duration;
        curTime.value = (nowSecond-0.05) * _playerItem.duration.value;
        [_player seekToTime:curTime];
        [_playView.player play];
        return;
    }
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"right");
        
        CGFloat nowSecond = _timeSlider.value;
        CMTime curTime = _playerItem.duration;
        curTime.value = (nowSecond+0.05) * _playerItem.duration.value;
        [_player seekToTime:curTime];
        [_playView.player play];
        return;
    }
    //音量控制 不建议这样写 设备系统的声音大小就决定了这样调节声音大小的范围
//    if (gesture.direction == UISwipeGestureRecognizerDirectionUp) {
//        NSLog(@"up");
//        CGFloat volume = _playView.player.volume;
//        if (volume <= 0.9) {
//             volume += 0.1;
//        }
//        else
//            volume = 1.0;
//        _playView.player.volume = volume;
//
//        return;
//    }
    if (gesture.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"down");
        CGFloat volume = _playView.player.volume;
        if (volume > 0.1) {
            volume -= 0.1;
        }
        else
            volume = 0.0;
        _playView.player.volume = volume;
        
        return;
    }
}

/**
 *  控制页面的动画
 */
-(void)detailViewMoveAnimation:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;//持续时间
    [animation setFillMode:kCAFillModeRemoved];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setType:kCATransitionFade];
    [animation setSubtype:kCATransitionFromTop];
    animation.delegate = self;
    [view.layer addAnimation:animation forKey:@"position"];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
