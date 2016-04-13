//
//  PlayerView.h
//  VideoLearnDemo
//
//  Created by LIAN on 16/4/6.
//  Copyright © 2016年 com.Alice. All rights reserved.
//


/**
 *  单纯使用AVPlayer类是无法显示视频，要将视频层添加至AVPlayerLayer中
 */
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerView : UIView

@property (strong,nonatomic) AVPlayer *player;

@end
