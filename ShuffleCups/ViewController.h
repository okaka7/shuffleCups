//
//  ViewController.h
//  ShuffleCups
//
//  Created by KawanishiKota on 2016/04/05.
//  Copyright © 2016年 KawanishiKota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


@interface ViewController : UIViewController<GKGameCenterControllerDelegate,AVAudioPlayerDelegate>{
    CFURLRef soundURL;
    SystemSoundID soundID;
    AVAudioPlayer *audioPlayer;
}

@property (strong, nonatomic) UIImageView* titleView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *bestBtn;
@property (weak, nonatomic) IBOutlet UIButton *rankBtn;
@property (weak, nonatomic) IBOutlet UIButton *howToPlayBtn;
@property (weak, nonatomic) IBOutlet UIImageView *titleBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *titleLabelView;
@property (strong, nonatomic) NSArray* bestScores;
@property (readwrite) CFURLRef soundURL;
@property (readonly) SystemSoundID soundID;
@property (nonatomic) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL soundOn;
@property (weak, nonatomic) IBOutlet UIButton *soundBtn;



- (IBAction)play:(id)sender;
- (IBAction)explainHowToPlay:(id)sender;
- (IBAction)showBest:(id)sender;
- (IBAction)showRank:(id)sender;
- (IBAction)switchSound:(id)sender;


@end

