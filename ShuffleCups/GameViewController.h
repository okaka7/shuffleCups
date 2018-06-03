//
//  GameViewController.h
//  ShuffleCups
//
//  Created by KawanishiKota on 2016/04/05.
//  Copyright © 2016年 KawanishiKota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "CupView.h"
#import "BallView.h"
#import <GameKit/GameKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>



@class Scoreboard;
@class ScoreboardView;




@interface GameViewController : UIViewController<CupViewDelegate, BallViewDelegate,GKGameCenterControllerDelegate, AVAudioPlayerDelegate,CAAnimationDelegate>{
    CFURLRef soundURL;
    SystemSoundID soundID;
    AVAudioPlayer *audioPlayer;
    
}


@property (weak, nonatomic) IBOutlet UIImageView *wallView;
@property (weak, nonatomic) IBOutlet UIImageView *deskView;
@property (strong, nonatomic) ScoreboardView* scoreboardView;
@property (strong, nonatomic) CupView* redCupView;
@property (strong, nonatomic) CupView* greenCupView;
@property (strong, nonatomic) CupView* blueCupView;
@property (strong, nonatomic) UIImageView* pictureView;
@property (strong, nonatomic) UIImageView* funitureView1;
@property (strong, nonatomic) UIImageView* funitureView2;
@property (strong, nonatomic) UIImageView* lightView;
@property (strong, nonatomic) NSArray* bestScores;
@property(readwrite) CFURLRef soundURL;
@property(readonly) SystemSoundID soundID;
@property(nonatomic) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL soundOn;


- (IBAction)backTitle:(id)sender;

@end
