//
//  BestScoreViewController.h
//  ShuffleCups
//
//  Created by KawanishiKota on 2016/04/06.
//  Copyright © 2016年 KawanishiKota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


@interface BestScoreViewController : UIViewController<AVAudioPlayerDelegate>{
    CFURLRef soundURL;
    SystemSoundID soundID;
    AVAudioPlayer *audioPlayer;
}

@property (strong, nonatomic) UIButton* bestScoreView;
@property (strong, nonatomic) NSArray* bestScores;
@property(readwrite) CFURLRef soundURL;
@property(readonly) SystemSoundID soundID;
@property(nonatomic) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL soundOn;
- (IBAction)goBackTitle:(id)sender;

@end
