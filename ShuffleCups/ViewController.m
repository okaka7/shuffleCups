//
//  ViewController.m
//  ShuffleCups
//
//  Created by KawanishiKota on 2016/04/05.
//  Copyright © 2016年 KawanishiKota. All rights reserved.
//

#import "ViewController.h"
#import "GameViewController.h"
#import "BestScoreViewController.h"
#import <QuartzCore/QuartzCore.h>



typedef struct{ float x; float y; float width; float height;} scale;

@interface ViewController (){
    
    UIImageView *currentExplanationView;
    UIImageView *howToPlayView1;
    UIImageView *howToPlayView2;
    UIImageView *explanationBackgroundView;
    UIButton *backTitleBtn;
    
    UIImageView* currentPageNumberView;
    UIImageView* pageNumberView1;
    UIImageView* pageNumberView2;
    
    UIButton* currentNavigationBtn;
    UIButton* arrowNextBtn;
    UIButton* arrowBackBtn;
    
    NSUserDefaults* userDefaults;
}



@end

@implementation ViewController

@synthesize titleView = titleView;
@synthesize soundID = soundID;
@synthesize soundURL = soundURL;
@synthesize audioPlayer = audioPlayer;
@synthesize soundOn = soundOn;

static NSString* kTitleView = @"TitleView";
static NSString* kExplanationBackgroundImage = @"ExplanationBackground.gif";
static NSString* kExplanationImage1 = @"ExplanationImage1";
static NSString* kExplanationImage2 = @"ExplanationImage2";
static NSString* kBackBtnImage = @"BackBtn.png";
static NSString* kArrowToNextImage = @"ArrowNextImage.png";
static NSString* kArrowBackImage = @"ArrowBackImage.png";
static NSString* kPageNumberImage1 = @"PageNumberImage1.png";
static NSString* kPageNumberImage2 = @"PageNumberImage2.png";
static NSString* kSoundOn = @"ShuffleCupsSoundOn.png";
static NSString* kSoundOff = @"ShuffleCupsSoundOff.png";

static scale explanationImageScale = {0.0, 0.0, 0.83, 0.73};
static scale backBtnScale = {0.66, 0.88, 0.29, 0.071};
static scale nextArrowScale = {0.684, 0.0, 0.315, 0.857};
static scale backArrowScale = {0.0, 0.0, 0.315, 0.857};
static scale pageNumberScale = {0.0, 0.9, 0.11, 0.05};

static CGSize referenceSize;
static CGSize referenceSizeOfExplanationView;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if(!self.view.clipsToBounds)
        self.view.clipsToBounds = YES;
    
    //広告削除
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        referenceSize = CGSizeMake( self.view.frame.size.width, self.view.frame.size.height);
    else
        referenceSize = CGSizeMake( self.view.frame.size.width, self.view.frame.size.height);
    
    [self configureTitleView];
    [self configureSoundOn];
    [self prepareForExplanation];  //How To Playのための準備
    
    
    [self authenticateLocalPlayer];
   
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(titleAnimationStart) name:@"animationStart" object:nil];
}





- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    
    [self titleAnimationStart];
    [self configureSoundImage];
    if(!self.audioPlayer){
        if(soundOn)
           [self playBGM];
    } else{
        self.audioPlayer.delegate = self;
    }
    [self setBestArray];
}




- (void)configureSoundOn{
    soundOn = YES;
}

- (void)configureSoundImage{
    if(self.soundOn)
        [self.soundBtn setImage:[UIImage imageNamed:kSoundOn] forState:UIControlStateNormal];
    else
        [self.soundBtn setImage:[UIImage imageNamed:kSoundOff] forState:UIControlStateNormal];
}




- (void)configureTitleView{
    titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kTitleView]];
    
    /* 広告サイズによる画面サイズ調整
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        titleView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }else{
        titleView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
     */
    titleView.layer.zPosition = -0.1;
    [self.view addSubview:titleView];
    
}

- (void)playBGM{
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tw029" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (error)
        NSLog(@"Error %@", [error localizedDescription]);
    [self.audioPlayer setDelegate:self];  // 自分自身をデリゲートに設定
    self.audioPlayer.numberOfLoops = -1;  //audioを繰り返し再生
    self.audioPlayer.volume = 0.2;
    [self.audioPlayer play];
}


- (void)prepareForExplanationImage{
    if(!referenceSizeOfExplanationView.width)
        referenceSizeOfExplanationView = CGSizeMake(referenceSize.width * explanationImageScale.width, referenceSize.height * explanationImageScale.height);
    
    double explanationImageX = (referenceSize.width - referenceSizeOfExplanationView.width) / 2.0;
    double explanationImageY = (referenceSize.height- referenceSizeOfExplanationView.height) / 2.0;
    CGRect explanationImageFrame = CGRectMake(explanationImageX, explanationImageY, referenceSizeOfExplanationView.width, referenceSizeOfExplanationView.height);
    
    NSString* exlanationImage1 = NSLocalizedString(kExplanationImage1, @"");
    NSString* exlanationImage2 = NSLocalizedString(kExplanationImage2, @"");
    howToPlayView1 = [[UIImageView alloc] initWithFrame:explanationImageFrame];
    howToPlayView1.image = [UIImage imageNamed:exlanationImage1];
    howToPlayView1.userInteractionEnabled = YES;
    
    howToPlayView2 = [[UIImageView alloc] initWithFrame:explanationImageFrame];
    howToPlayView2.image = [UIImage imageNamed:exlanationImage2];
    howToPlayView2.userInteractionEnabled = YES;
    
    if(currentExplanationView.clipsToBounds == NO)
        currentExplanationView.clipsToBounds = YES;
    
}


- (void)prepareForBackground{
    CGRect backgroundFrame = CGRectMake(0, 0, referenceSize.width, referenceSize.height);
    explanationBackgroundView = [[UIImageView alloc] initWithFrame:backgroundFrame];
    explanationBackgroundView.image = [UIImage imageNamed:kExplanationBackgroundImage];
    explanationBackgroundView.alpha = 0.75;
}



- (void)prepareForBackBtn{
    CGRect backBtnFrame = CGRectMake(referenceSizeOfExplanationView.width * backBtnScale.x, referenceSizeOfExplanationView.height * backBtnScale.y, referenceSizeOfExplanationView.width * backBtnScale.width, referenceSizeOfExplanationView.height * backBtnScale.height);
    
    backTitleBtn = [[UIButton alloc] initWithFrame:backBtnFrame];
    [backTitleBtn setImage:[UIImage imageNamed:kBackBtnImage] forState:UIControlStateNormal];
    [backTitleBtn addTarget:self action:@selector(backHome:) forControlEvents:UIControlEventTouchUpInside];
    backTitleBtn.userInteractionEnabled = YES;
}

- (void)prepareForArrow{
    CGRect nextArrowFrame = CGRectMake(referenceSizeOfExplanationView.width * nextArrowScale.x, 0.0, referenceSizeOfExplanationView.width * nextArrowScale.width, referenceSizeOfExplanationView.height * nextArrowScale.height);
    arrowNextBtn = [[UIButton alloc] initWithFrame:nextArrowFrame];
    [arrowNextBtn setImage:[UIImage imageNamed:kArrowToNextImage]forState:UIControlStateNormal];
    CGRect backArrowFrame = CGRectMake(0, 0, referenceSizeOfExplanationView.width * backArrowScale.width, referenceSizeOfExplanationView.height * backArrowScale.height);
    arrowBackBtn = [[UIButton alloc] initWithFrame:backArrowFrame];
    [arrowBackBtn setImage:[UIImage imageNamed:kArrowBackImage] forState:UIControlStateNormal];
    
    
    [arrowNextBtn addTarget:self action:@selector(nextPage:) forControlEvents:UIControlEventTouchUpInside];
    arrowNextBtn.userInteractionEnabled = YES;
    [arrowBackBtn addTarget:self action:@selector(backPage:) forControlEvents:UIControlEventTouchUpInside];
    arrowBackBtn.userInteractionEnabled = YES;
}

- (void)prepareForPageNumber{
    CGSize pageNumberSize = CGSizeMake(referenceSizeOfExplanationView.width * pageNumberScale.width, referenceSizeOfExplanationView.height * pageNumberScale.height);
    CGRect pageNumberFrame = CGRectMake((referenceSizeOfExplanationView.width / 2) - (pageNumberSize.width / 2), referenceSizeOfExplanationView.height * pageNumberScale.y, pageNumberSize.width, pageNumberSize.height);
    pageNumberView1 = [[UIImageView alloc] initWithFrame:pageNumberFrame];
    pageNumberView2 = [[UIImageView alloc] initWithFrame:pageNumberFrame];
    pageNumberView1.image = [UIImage imageNamed:kPageNumberImage1];
    pageNumberView2.image = [UIImage imageNamed:kPageNumberImage2];
    
}

- (void)prepareForExplanation{
    [self prepareForExplanationImage];
    [self prepareForBackground];
    [self prepareForBackBtn];
    [self prepareForArrow];
    [self prepareForPageNumber];
}

- (void)nextPage:(UIButton *)sender{
    [self touchArrowSound];
    [currentNavigationBtn.layer removeAllAnimations];
    [backTitleBtn removeFromSuperview];
    [currentPageNumberView removeFromSuperview];
    [currentNavigationBtn removeFromSuperview];
    [currentExplanationView removeFromSuperview];
    currentExplanationView = howToPlayView2;
    
    [self.view addSubview:currentExplanationView];
    [currentExplanationView addSubview:backTitleBtn];
    currentPageNumberView = pageNumberView2;
    [currentExplanationView addSubview:currentPageNumberView];
    currentNavigationBtn = arrowBackBtn;
    [currentExplanationView addSubview:currentNavigationBtn];
    [self navigationAnimationGo];
}

- (void)backPage:(UIButton *)sender{
    [self touchArrowSound];
    [currentNavigationBtn.layer removeAllAnimations];
    [backTitleBtn removeFromSuperview];
    [currentPageNumberView removeFromSuperview];
    [currentNavigationBtn removeFromSuperview];
    [currentExplanationView removeFromSuperview];
    
    currentExplanationView = howToPlayView1;
    [self.view addSubview:currentExplanationView];
    [currentExplanationView addSubview:backTitleBtn];
    currentPageNumberView = pageNumberView1;
    [currentExplanationView addSubview:currentPageNumberView];
    currentNavigationBtn = arrowNextBtn;
    [currentExplanationView addSubview:currentNavigationBtn];
    [self navigationAnimationGo];
    
}


- (void)navigationAnimationGo{
    [UIView animateWithDuration:0.7f delay:0.1f options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
        currentNavigationBtn.alpha = 0.5;
        currentNavigationBtn.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished){if(finished) [self navigationAnimationBack];}];
}

- (void)navigationAnimationBack{
    [UIView animateWithDuration:0.7f delay:0.1f options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
        currentNavigationBtn.alpha = 1.0;
        currentNavigationBtn.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished){ if(finished)[self navigationAnimationGo];}];
}


- (void)backHome:(UIButton *)button{
    [self touchBtnSound];
    [currentExplanationView.layer removeAllAnimations];
    [explanationBackgroundView removeFromSuperview];
    [backTitleBtn removeFromSuperview];
    [currentPageNumberView removeFromSuperview];
    currentPageNumberView = nil;
    [currentExplanationView removeFromSuperview];
    currentExplanationView = nil;
    
    self.playBtn.userInteractionEnabled = YES;
    self.bestBtn.userInteractionEnabled = YES;
    self.rankBtn.userInteractionEnabled = YES;
    self.howToPlayBtn.userInteractionEnabled = YES;
    [self titleAnimationStart];
   
}



- (void)titleAnimationStart{
    [UIView animateWithDuration:0.7f delay:0.1f options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
        self.titleLabelView.transform = CGAffineTransformMakeScale(1.03, 1.03);
        self.titleBackgroundView.transform = CGAffineTransformMakeScale(1.0, 1.03);
    }completion:^(BOOL finished){if(finished) [self titleAnimationBack];}];
}

- (void)titleAnimationBack{
    [UIView animateWithDuration:0.7f delay:0.1f options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
        self.titleLabelView.transform = CGAffineTransformIdentity;
        self.titleBackgroundView.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished){if(finished) [self titleAnimationStart];}];
}

- (void)titleAnimationStop{
    [self.titleLabelView.layer removeAllAnimations];
    [self.titleBackgroundView.layer removeAllAnimations];
}

- (void)setBestArray{
    userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"BESTRECORDS"])
        self.bestScores = [userDefaults objectForKey:@"BESTRECORDS"];

}


- (IBAction)play:(id)sender{
    
    [self titleAnimationStop];
    [self touchBtnSound];
    if ( self.audioPlayer.playing ){
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
    GameViewController* gameViewCtr = [self.storyboard instantiateViewControllerWithIdentifier:@"GameViewController"];
    if(self.bestScores)
        gameViewCtr.bestScores = self.bestScores;
    gameViewCtr.soundOn = self.soundOn;
    [self presentViewController:gameViewCtr animated:NO completion:nil];
}

- (IBAction)explainHowToPlay:(id)sender{
    [self touchBtnSound];
    
    self.playBtn.userInteractionEnabled = NO;
    self.bestBtn.userInteractionEnabled = NO;
    self.rankBtn.userInteractionEnabled = NO;
    self.howToPlayBtn.userInteractionEnabled = NO;
    
    [self titleAnimationStop];

    currentExplanationView = howToPlayView1;
    currentPageNumberView = pageNumberView1;
    currentNavigationBtn = arrowNextBtn;
    [self.view addSubview:explanationBackgroundView];
    [self.view addSubview:currentExplanationView];
    [currentExplanationView addSubview:backTitleBtn];
    [currentExplanationView addSubview:currentPageNumberView];
    [currentExplanationView addSubview:currentNavigationBtn];
    [self navigationAnimationGo];
}

- (IBAction)showBest:(id)sender{
    [self touchBtnSound];
    
    [self titleAnimationStop];
    BestScoreViewController* bestScoreViewCtr = [self.storyboard instantiateViewControllerWithIdentifier:@"BestScoreViewController"];
    if(self.bestScores)
        bestScoreViewCtr.bestScores = self.bestScores;
    if(self.audioPlayer.playing )
        bestScoreViewCtr.audioPlayer = self.audioPlayer;
    bestScoreViewCtr.soundOn = self.soundOn;
    [self presentViewController:bestScoreViewCtr animated:NO completion:nil];
}

- (void)touchBtnSound{
    if(soundOn){
        CFBundleRef mainBundle;
        mainBundle = CFBundleGetMainBundle ();
        soundURL  = CFBundleCopyResourceURL (mainBundle,CFSTR ("decision7"),CFSTR ("wav"),NULL);
        AudioServicesCreateSystemSoundID (soundURL, &soundID);
        CFRelease (soundURL);
        AudioServicesPlaySystemSound (soundID);
    }
}

- (void)touchArrowSound{
    if(soundOn){
        CFBundleRef mainBundle;
        mainBundle = CFBundleGetMainBundle ();
        soundURL  = CFBundleCopyResourceURL (mainBundle,CFSTR ("button05"),CFSTR ("mp3"),NULL);
        AudioServicesCreateSystemSoundID (soundURL, &soundID);
        CFRelease (soundURL);
        AudioServicesPlaySystemSound (soundID);
    }
}


- (IBAction)showRank:(id)sender{
    
    [self touchBtnSound];
    GKGameCenterViewController *gcViewCtr = [GKGameCenterViewController new];
    if (gcViewCtr != nil){
        gcViewCtr.gameCenterDelegate = self;
        gcViewCtr.viewState = GKGameCenterViewControllerStateLeaderboards;
        [self presentViewController:gcViewCtr animated:NO completion:nil];
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (IBAction)switchSound:(id)sender{
    
    if (self.audioPlayer.playing ){
        [self.audioPlayer stop];
        [self.soundBtn setImage:[UIImage imageNamed:kSoundOff] forState:UIControlStateNormal];
        soundOn = NO;
    } else{
        
        [self playBGM];
        [self.soundBtn setImage:[UIImage imageNamed:kSoundOn] forState:UIControlStateNormal];
        soundOn = YES;
    }
}


- (void)authenticateLocalPlayer{
    GKLocalPlayer* player = [GKLocalPlayer localPlayer];
    player.authenticateHandler = ^(UIViewController* ui, NSError* error )
    {
        if( nil != ui )
        {
            [self presentViewController:ui animated:YES completion:nil];
        }
        
    };
}








- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
