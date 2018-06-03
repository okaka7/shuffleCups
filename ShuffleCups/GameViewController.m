//
//  GameViewController.m
//  ShuffleCups
//
//  Created by KawanishiKota on 2016/04/05.
//  Copyright © 2016年 KawanishiKota. All rights reserved.
//

#import "GameViewController.h"
#import "BestScoreViewController.h"
#import "Cup.h"
#import "Ball.h"
#import "Scoreboard.h"
#import "ScoreboardView.h"
#import <QuartzCore/QuartzCore.h>



typedef struct{ float x; float y; float width; float height;} scale;

@interface GameViewController (){
    
    CupView* touchBeganCup;
    CupView* touchEndedCup;
    
    NSArray* picImages;
    NSString* picImage;
    
    NSArray* lightImages;
    NSString* lightImage;
    
    NSArray* funitureImages1;
    NSArray* funitureImages2;
    NSString* funitureImage1;
    NSString* funitureImage2;
    
    int makeBallCount;
    int makeBallPoint;
    NSMutableArray *currentBalls;
    NSMutableArray *bounceBalls;
    
    
    CGPoint bouncePoint[3];
    CGPoint bounceCurvePoint1[3];
    CGPoint bounceCurvePoint2[3];
    CGPoint bounceEndPoint[3];
    CGPoint failedBounceEndPoint[4];
    CGPoint failedBounceCurvePoint1[4];
    CGPoint failedBounceCurvePoint2[4];
    
    
    float ballSize;
    float ballSpeed;
    float maxBallSpeed;
    float currentBallSpeed;
    
    float checkPointOfBall;
    
    UIImageView* gameOverView;
    UIImageView* gameOverLabel;
    UIImageView* ballOfGameOverView;
    UIImageView* shadowOfBall;
    UIImageView* scoreLabel;
    NSArray* scoreViews;
    UIImageView* scoreOfGameOverView1;
    UIImageView* scoreOfGameOverView2;
    UIImageView* scoreOfGameOverView3;
    UIImageView* scoreOfGameOverView4;
    NSArray* scoreNumberImages;
    
    UIButton* retryBtn;
    UIButton* bestBtn;
    UIButton* rankBtn;
    UIButton* titleBtn;
    
    
    CGPoint fallBallEndPoint;
    CGPoint fallBallEndPoint2;
    CGPoint fallBallEndPoint3;
    float bounceHeight;
    float bounceHeight2;

    NSTimer *timer;
    
    BOOL prepareForGameDone;
    BOOL prepareForGameOverDone;
    BOOL gameOver;
    BOOL gameOverAnimation;
    
    NSUserDefaults *ud;
    
}

@end

@implementation GameViewController

@synthesize soundID = soundID;
@synthesize soundURL = soundURL;
@synthesize audioPlayer = audioPlayer;
@synthesize soundOn = soundOn;


static CGSize referenceSize;
static CGSize referenceSizeOfGameOver;
static CGRect referenceFrameOfCup[3];
static scale leftCupScale = {0.04, 0.722, 0.24, 0.24};
static scale centerCupScale = {0.366, 0.722, 0.24, 0.24};
static scale rightCupScale = {0.71, 0.722, 0.24, 0.24};

static float ballSizeScaleToCupWidth = 0.7;

static float bounceHeightScale = 0.1;
static float bounceEndScaleX = 0.125;
static float bounceEndScaleY = 0.284;
static float failedBounceHeightScale = 0.05;
static float failedBounceEndScaleX = 0.225;
static float failedBounceEndScaleY = 0.284;

static scale scoreboardScale = {0.73, 0.086, 0.2, 0.14};
static scale pictureScale = {0.07, 0.096, 0.46, 0.38};
static scale standLightScale = {0.53, 0.51, 0.49, 0.42};
static scale lampScale = {0.60, 0.51, 0.4, 0.42};
static scale teacupScale = {0.15, 0.8, 0.3, 0.13};
static scale baseballScale = {0.19, 0.82, 0.17, 0}; //横と縦のサイズを等しくするため、heightのスケールの値は0.0。
static scale bookScale = {0.57, 0.954, 0.29, 0.045};
static scale pencilScale = {0.5, 0.954, 0.46, 0.038};

static scale scoreScale4[4] = {{0.652, 0.253, 0.138, 0.145}, {0.504, 0.253, 0.138, 0.145}, {0.356, 0.253, 0.138, 0.145},{0.208, 0.253, 0.138, 0.145}};
static scale scoreScale3[3] = {{0.5787, 0.253, 0.138, 0.145}, {0.43, 0.253, 0.138, 0.145}, {0.282, 0.253, 0.138, 0.145}};
static scale scoreScale2[2] = { {0.504, 0.253, 0.138, 0.145}, {0.356, 0.253, 0.138, 0.145}};
static scale scoreScale = {0.43, 0.253, 0.138, 0.145};

static scale gameOverLabelScale = {0.032, 0.055, 0.936, 0.092};
static scale scoreLabelScale = {0.31, 0.173, 0.38, 0.053};

static scale ballOfGameOverScale = {0.36, 0.0, 0.21, 0.135}; //初期の状態ではyは画面外なので0と記述。

static scale retryScale = {0.0, 0.7431, 0.4166, 0.0807};
static scale bestScale = {0.0, 0.8288, 0.4166, 0.0807};
static scale rankScale = {0.0, 0.8288, 0.4166, 0.0807};
static scale titleScale = {0.0, 0.9137, 0.4166, 0.0807};

static float bounceScale =  0.05;
static float bounceScale2 = 0.01;

static float firstDegreeOfBallSpeed = 160;
static float maxDegreeOfBallSpeed = 93.5;


static NSString* cupAndMomPicImage = @"CupAndMomPic";
static NSString* cupsMakeMeHappyPicImage = @"CupsMakeMeHappyPic";
static NSString* someLikeShufflePicImage = @"SomeLikeItShufflePic";
static NSString* drinkAndShufflePicImage = @"DrinkAndShufflePic";
static NSString* cupOnTheHandPicImage = @"CupOnTheHandPic";

static NSString* lampImage = @"Lamp";
static NSString* standLightImage = @"StandLight";

static NSString* teacupImage = @"Teacup";
static NSString* pencilImage = @"Pencil";
static NSString* bookImage = @"Book";
static NSString* baseballImage = @"Baseball";

static NSString* gameOverViewImage = @"GameOverView";
static NSString* ballGameOverImage = @"BallOfGameOver";
static NSString* shadowOfBallImage = @"ShadowOfBall";
static NSString* gameOverLabelImage = @"GameOverLabel";
static NSString* scoreLable = @"ScoreLabel";

static NSString* score0Image = @"ScoreNumber0_GameOverView.png";
static NSString* score1Image = @"ScoreNumber1_GameOverView.png";
static NSString* score2Image = @"ScoreNumber2_GameOverView.png";
static NSString* score3Image = @"ScoreNumber3_GameOverView.png";
static NSString* score4Image = @"ScoreNumber4_GameOverView.png";
static NSString* score5Image = @"ScoreNumber5_GameOverView.png";
static NSString* score6Image = @"ScoreNumber6_GameOverView.png";
static NSString* score7Image = @"ScoreNumber7_GameOverView.png";
static NSString* score8Image = @"ScoreNumber8_GameOverView.png";
static NSString* score9Image = @"ScoreNumber9_GameOverView.png";

static NSString* retryBtnImage = @"RetryBtn.png";
static NSString* bestBtnImage = @"BestBtn.png";
static NSString* rankBtnImage = @"RankBtn.png";
static NSString* titleBtnImage = @"TitleBtn.png";

static NSString* kLeaderBoardId = @"ShuffleCupsRank";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    referenceSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    //広告削除
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        referenceSizeOfGameOver = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    else
        referenceSizeOfGameOver = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    prepareForGameDone = NO;
    prepareForGameOverDone = NO;
    gameOver = NO;
    gameOverAnimation = NO;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(animationFailed) name:@"fallBallAnimationFailed" object:nil];
    [nc addObserver:self selector:@selector(didEnterBackgroundDuringGame) name:@"quitDuringGame" object:nil];
    [nc addObserver:self selector:@selector(dismissViewFromBestScoreView) name:@"dismissViewFromBestScoreView" object:nil];
    

    [self prepareForGame];
    [self playStart];
    if(self.soundOn)
        [self playBGM];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
}



- (void)playBGM{
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tw034" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if ( error != nil )
    {
        NSLog(@"Error %@", [error localizedDescription]);
    }
    // 自分自身をデリゲートに設定
    [self.audioPlayer setDelegate:self];
    self.audioPlayer.numberOfLoops = -1;
    self.audioPlayer.volume = 0.2;
    [self.audioPlayer play];
}


- (void)prepareForGame{
    self.view.clipsToBounds = YES;
    self.deskView.layer.zPosition = 0.5;
    
    [self configureScoreboard];
    [self configurePicture];
    [self configureLight];
    [self configureFuniture];
    [self configureCup];
    [self configureReferencePoints];
    [self prepareForBall];
    
    prepareForGameDone = YES;
}


- (void)configureScoreboard{
    if(!self.scoreboardView){
        Scoreboard* scoreboard = [[Scoreboard alloc] init];
        CGRect scoreboardFrame = CGRectMake(referenceSize.width * scoreboardScale.x, referenceSize.height * scoreboardScale.y, referenceSize.width * scoreboardScale.width, referenceSize.height * scoreboardScale.height);
        
        self.scoreboardView = [[ScoreboardView alloc] initWithFrame:scoreboardFrame scoreboard:scoreboard];
    }
    
    [self.view addSubview:self.scoreboardView];
}

- (void)configurePicture{
    
    if(!picImages)
        picImages = [NSArray arrayWithObjects: cupAndMomPicImage, cupsMakeMeHappyPicImage, someLikeShufflePicImage, drinkAndShufflePicImage, cupOnTheHandPicImage, nil];
    
    if(!self.pictureView){
        CGRect picFrame = CGRectMake(referenceSize.width * pictureScale.x, referenceSize.height * pictureScale.y, referenceSize.width * pictureScale.width, referenceSize.height * pictureScale.height);
        
        self.pictureView = [[UIImageView alloc] initWithFrame:picFrame];
    }
    
    picImage = picImages[arc4random_uniform(5)];
    self.pictureView.image = [UIImage imageNamed:picImage];
    
    [self.view addSubview:self.pictureView];
    
}

-(void)configureLight{
    
    if(!lightImages)
        lightImages = [NSArray arrayWithObjects: lampImage, standLightImage, nil];
    
    lightImage = lightImages[arc4random_uniform(2)];
    
    CGRect lightFrame;
    if([lightImage isEqualToString:lampImage]){
        lightFrame = CGRectMake(referenceSize.width * lampScale.x, referenceSize.height * lampScale.y, referenceSize.width * lampScale.width, referenceSize.height * lampScale.height);
    }
    else {
        lightFrame = CGRectMake(referenceSize.width * standLightScale.x, referenceSize.height * standLightScale.y,  referenceSize.width * standLightScale.width, referenceSize.height * standLightScale.height);
    }
    
    self.lightView = [[UIImageView alloc] initWithFrame:lightFrame];
    
    self.lightView.image = [UIImage imageNamed:lightImage];
    self.lightView.layer.zPosition = 1.0;
    [self.view addSubview:self.lightView];
}

- (void)configureFuniture{
    
    if(!funitureImages1)
        funitureImages1 = [NSArray arrayWithObjects: bookImage, pencilImage, nil];
    if(!funitureImages2)
        funitureImages2 = [NSArray arrayWithObjects:teacupImage, baseballImage, nil];
    
    funitureImage1 = funitureImages1[arc4random_uniform(2)];
    funitureImage2 = funitureImages2[arc4random_uniform(2)];
    
    CGRect funitureFrame1;
    CGRect funitureFrame2;
    
    if([funitureImage1 isEqualToString:bookImage]){
        funitureFrame1 = CGRectMake(referenceSize.width * bookScale.x, referenceSize.height * bookScale.y, referenceSize.width * bookScale.width, referenceSize.height * bookScale.height);
    }
    else {
        funitureFrame1 = CGRectMake(referenceSize.width * pencilScale.x, referenceSize.height * pencilScale.y, referenceSize.width * pencilScale.width, referenceSize.height * pencilScale.height);
    }
    
    if([funitureImage2 isEqualToString:teacupImage]){
        funitureFrame2 = CGRectMake(referenceSize.width * teacupScale.x, referenceSize.height * teacupScale.y, referenceSize.width * teacupScale.width, referenceSize.height * teacupScale.height);
    }
    else {
        //ボールの縦横のサイズを揃えるため縦サイズもsizeReference.width * baseballScale.widthで記述。
        funitureFrame2 = CGRectMake(referenceSize.width * baseballScale.x, referenceSize.height * baseballScale.y, referenceSize.width * baseballScale.width, referenceSize.width * baseballScale.width);
    }
    
    self.funitureView1 = [[UIImageView alloc] initWithFrame:funitureFrame1];
    self.funitureView2 = [[UIImageView alloc] initWithFrame:funitureFrame2];
    
    self.funitureView1.image = [UIImage imageNamed:funitureImage1];
    self.funitureView2.image = [UIImage imageNamed:funitureImage2];
    
    self.funitureView1.layer.zPosition = 3.0;
    self.funitureView2.layer.zPosition = 1.0;
    
    [self.view addSubview:self.funitureView1];
    [self.view addSubview:self.funitureView2];
    
}

- (void)prepareForBall{
    makeBallCount = 0;
    makeBallPoint = 85;
    ballSpeed = checkPointOfBall / firstDegreeOfBallSpeed;
    currentBallSpeed = firstDegreeOfBallSpeed;
    maxBallSpeed = checkPointOfBall / maxDegreeOfBallSpeed;
    if(!currentBalls)
        currentBalls = [NSMutableArray array];
    if(!bounceBalls)
        bounceBalls = [NSMutableArray array];
}

- (void)configureCup{
    if(!prepareForGameDone){
        referenceFrameOfCup[Center] = CGRectMake(referenceSize.width * centerCupScale.x, referenceSize.height * centerCupScale.y, referenceSize.width * centerCupScale.width, referenceSize.height * centerCupScale.height);
        referenceFrameOfCup[Left] = CGRectMake(referenceSize.width * leftCupScale.x, referenceSize.height * leftCupScale.y, referenceSize.width * leftCupScale.width, referenceSize.height * leftCupScale.height);
        referenceFrameOfCup[Right] = CGRectMake(referenceSize.width * rightCupScale.x, referenceSize.height * rightCupScale.y, referenceSize.width * rightCupScale.width, referenceSize.height * rightCupScale.height);
    }
    
    Cup* redCup = [[Cup alloc] initWithColor:Red position:Center];
    Cup* greenCup = [[Cup alloc] initWithColor:Green position:Left];
    Cup* blueCup = [[Cup alloc] initWithColor:Blue position:Right];
    
    self.redCupView = [[CupView alloc] initWithFrame:referenceFrameOfCup[Center] cup:redCup delegate:self];
    self.greenCupView = [[CupView alloc] initWithFrame:referenceFrameOfCup[Left] cup:greenCup delegate:self];
    self.blueCupView = [[CupView alloc] initWithFrame:referenceFrameOfCup[Right] cup:blueCup delegate:self];
    
    
    self.redCupView.layer.zPosition = 1.5;
    self.greenCupView.layer.zPosition = 1.5;
    self.blueCupView.layer.zPosition = 1.5;
    self.redCupView.upperCupView.layer.zPosition = 2.5;
    self.greenCupView.upperCupView.layer.zPosition = 2.5;
    self.blueCupView.upperCupView.layer.zPosition = 2.5;
    
    self.redCupView.userInteractionEnabled = YES;
    self.greenCupView.userInteractionEnabled = YES;
    self.blueCupView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.redCupView];
    [self.view addSubview:self.greenCupView];
    [self.view addSubview:self.blueCupView];
    [self.view addSubview:self.redCupView.upperCupView];
    [self.view addSubview:self.greenCupView.upperCupView];
    [self.view addSubview:self.blueCupView.upperCupView];
}

- (void)configureReferencePoints{
    
    if(!prepareForGameDone){
        ballSize = referenceFrameOfCup[Center].size.width * ballSizeScaleToCupWidth;
    
        checkPointOfBall = referenceFrameOfCup[Left].origin.y + referenceFrameOfCup[Left].size.height / 2.0;
    
        //跳ねるポイント
        bouncePoint[0].x = self.greenCupView.center.x;
        bouncePoint[1].x = self.redCupView.center.x;
        bouncePoint[2].x = self.blueCupView.center.x;
        bouncePoint[0].y = referenceFrameOfCup[Left].origin.y - referenceFrameOfCup[Left].size.height / 3.0;
        bouncePoint[1].y = referenceFrameOfCup[Center].origin.y - referenceFrameOfCup[Center].size.height / 3.0;
        bouncePoint[2].y = referenceFrameOfCup[Right].origin.y - referenceFrameOfCup[Right].size.height / 3.0;
    
        //落ちるポイント
        bounceEndPoint[0].x = bouncePoint[0].x + referenceSize.width * bounceEndScaleX;
        bounceEndPoint[0].y = bouncePoint[0].y + referenceSize.height * bounceEndScaleY;
        bounceEndPoint[1].x = bouncePoint[1].x + referenceSize.width * bounceEndScaleX;
        bounceEndPoint[1].y = bouncePoint[1].y + referenceSize.height * bounceEndScaleY;
        bounceEndPoint[2].x = bouncePoint[2].x + referenceSize.width * bounceEndScaleX;
        bounceEndPoint[2].y = bouncePoint[2].y + referenceSize.height * bounceEndScaleY;
    
        //カーブポイント1
        bounceCurvePoint1[0].x = bouncePoint[0].x + (bounceEndPoint[0].x - bouncePoint[0].x) / 4.0;
        bounceCurvePoint1[0].y = bouncePoint[0].y - referenceSize.height * bounceHeightScale;
        bounceCurvePoint1[1].x = bouncePoint[1].x + (bounceEndPoint[1].x - bouncePoint[1].x) / 4.0;
        bounceCurvePoint1[1].y = bouncePoint[1].y - referenceSize.height * bounceHeightScale;
        bounceCurvePoint1[2].x = bouncePoint[2].x + (bounceEndPoint[2].x - bouncePoint[2].x) / 4.0;
        bounceCurvePoint1[2].y = bouncePoint[2].y - referenceSize.height * bounceHeightScale;
    
        //カーブポイント2
        bounceCurvePoint2[0].x = bounceEndPoint[0].x - (bounceEndPoint[0].x - bouncePoint[0].x) / 4.0;
        bounceCurvePoint2[0].y = bouncePoint[0].y - referenceSize.height * bounceHeightScale;
        bounceCurvePoint2[1].x = bounceEndPoint[1].x - (bounceEndPoint[1].x - bouncePoint[1].x) / 4.0;
        bounceCurvePoint2[1].y = bouncePoint[1].y - referenceSize.height * bounceHeightScale;
        bounceCurvePoint2[2].x = bounceEndPoint[2].x - (bounceEndPoint[2].x - bouncePoint[2].x) / 4.0;
        bounceCurvePoint2[2].y = bouncePoint[2].y - referenceSize.height * bounceHeightScale;
        
        //失敗時の跳ねるポイント
        failedBounceEndPoint[0].x = bouncePoint[0].x - referenceSize.width * failedBounceEndScaleX;
        failedBounceEndPoint[0].y = bouncePoint[0].y + referenceSize.height * failedBounceEndScaleY;
        failedBounceEndPoint[1].x = bouncePoint[1].x - referenceSize.width * failedBounceEndScaleX;
        failedBounceEndPoint[1].y = bouncePoint[1].y + referenceSize.height * failedBounceEndScaleY;
        failedBounceEndPoint[2].x = bouncePoint[1].x + referenceSize.width * failedBounceEndScaleX;
        failedBounceEndPoint[2].y = bouncePoint[1].y + referenceSize.height * failedBounceEndScaleY;
        failedBounceEndPoint[3].x = bouncePoint[2].x + referenceSize.width * failedBounceEndScaleX;
        failedBounceEndPoint[3].y = bouncePoint[2].y + referenceSize.height * failedBounceEndScaleY;
        
        //失敗時のカーブポイント1
        failedBounceCurvePoint1[0].x = bouncePoint[0].x - (bouncePoint[0].x - failedBounceEndPoint[0].x) / 4.0;
        failedBounceCurvePoint1[0].y = bouncePoint[0].y - referenceSize.height * failedBounceHeightScale;
        failedBounceCurvePoint1[1].x = bouncePoint[1].x - (bouncePoint[1].x - failedBounceEndPoint[1].x) / 4.0;
        failedBounceCurvePoint1[1].y = bouncePoint[1].y - referenceSize.height * failedBounceHeightScale;
        failedBounceCurvePoint1[2].x = bouncePoint[1].x + (failedBounceEndPoint[2].x - bouncePoint[1].x) / 4.0;
        failedBounceCurvePoint1[2].y = bouncePoint[1].y - referenceSize.height * failedBounceHeightScale;
        failedBounceCurvePoint1[3].x = bouncePoint[2].x + (failedBounceEndPoint[3].x - bouncePoint[2].x) / 4.0;
        failedBounceCurvePoint1[3].y = bouncePoint[2].y - referenceSize.height * failedBounceHeightScale;
        
        //失敗時のカーブポイント
        failedBounceCurvePoint2[0].x = failedBounceEndPoint[0].x + (bouncePoint[0].x -failedBounceEndPoint[0].x) / 4.0;
        failedBounceCurvePoint2[0].y = bouncePoint[0].y - referenceSize.height * failedBounceHeightScale;
        failedBounceCurvePoint2[1].x = failedBounceEndPoint[1].x + (bouncePoint[1].x -failedBounceEndPoint[1].x) / 4.0;
        failedBounceCurvePoint2[1].y = bouncePoint[1].y - referenceSize.height * failedBounceHeightScale;
        failedBounceCurvePoint2[2].x = failedBounceEndPoint[2].x - (failedBounceEndPoint[2].x - bouncePoint[1].x) / 4.0;
        failedBounceCurvePoint2[2].y = bouncePoint[2].y - referenceSize.height * failedBounceHeightScale;
        failedBounceCurvePoint2[3].x = failedBounceEndPoint[3].x - (failedBounceEndPoint[3].x - bouncePoint[2].x) / 4.0;
        failedBounceCurvePoint2[3].y = bouncePoint[3].y - referenceSize.height * failedBounceHeightScale;
    }
}

- (id)seachCupWithPoint:(CGPoint)pt{
    if (CGRectContainsPoint(self.redCupView.frame,pt)) {
        return self.redCupView;
        
    }
    else if(CGRectContainsPoint(self.greenCupView.frame,pt)) {
        
        return self.greenCupView;
    }
    else if(CGRectContainsPoint(self.blueCupView.frame,pt)) {
        
        return self.blueCupView;
    }
    else {
        return nil;
    }
    
}

- (void)configureTouchBeganCupWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    
    touchBeganCup = nil;
    touchEndedCup = nil;
    
    CGPoint pt = [touch locationInView:self.view];
    
    
    touchBeganCup = [self seachCupWithPoint:pt];
}

- (void)configureTouchEndedCupWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint pt = [touch locationInView:self.view];
    
    touchEndedCup = [self seachCupWithPoint:pt];
    
    if(touchBeganCup && touchEndedCup && (touchBeganCup != touchEndedCup))
        [touchBeganCup.delegate shuffleCups];
    
}

- (void)shuffleCups{
    [touchBeganCup.upperCupView removeFromSuperview];
    [touchEndedCup.upperCupView removeFromSuperview];
    touchBeganCup.moving = YES;
    touchEndedCup.moving = YES;
    position tempPosition = touchBeganCup.cup.position;
    touchBeganCup.cup.position = touchEndedCup.cup.position;
    touchEndedCup.cup.position = tempPosition;
    
    [UIView beginAnimations:@"shuffleCups" context:nil];
    [UIView setAnimationDuration:0.08];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    CGRect tempFrame = touchBeganCup.frame;
    touchBeganCup.frame = touchEndedCup.frame;
    touchEndedCup.frame = tempFrame;
    
    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context{
    if([animationID isEqualToString:@"shuffleCups"]){
        touchBeganCup.moving = NO;
        touchEndedCup.moving = NO;
        touchBeganCup.upperCupView.frame = touchBeganCup.frame;
        touchEndedCup.upperCupView.frame = touchEndedCup.frame;
        [self.view addSubview:touchBeganCup.upperCupView];
        [self.view addSubview:touchEndedCup.upperCupView];
    }
    
}


- (int)cupColorWithPosition:(position)position{
    if(position == self.redCupView.cup.position)
        return Red;
    else if(position == self.greenCupView.cup.position)
        return Green;
    else if(position == self.blueCupView.cup.position)
        return Blue;
    else
        return -1;
}

- (id)cupWithPosition:(position)position{
    if(position == self.redCupView.cup.position)
        return self.redCupView;
    else if(position == self.greenCupView.cup.position)
        return self.greenCupView;
    else if(position == self.blueCupView.cup.position)
        return self.blueCupView;
    else
        return nil;
}

- (int)cupOverturnWithPosition:(position)position{
    if(position == self.redCupView.cup.position)
        return self.redCupView.cup.overturn;
    else if(position == self.greenCupView.cup.position)
        return self.greenCupView.cup.overturn;
    else if(position == self.blueCupView.cup.position)
        return self.blueCupView.cup.overturn;
    else
        return -1;
}

- (void)bounce:(BallView*)ballView position:(int)position{
    
    CALayer* theLayer = ballView.layer;
    
    CAKeyframeAnimation *animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    
    animation.duration = 0.43;
    
    // UIBezierPathで放物線のパスを生成
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    
    [path moveToPoint:bouncePoint[position]];
    [path addCurveToPoint:bounceEndPoint[position] controlPoint1:bounceCurvePoint1[position] controlPoint2:bounceCurvePoint2[position]];
    // パスをCAKeyframeAnimationオブジェクトにセット
    animation.path = path.CGPath;
    animation.delegate = self;
    // レイヤーにアニメーションを追加
    [theLayer addAnimation:animation forKey:@"bounce"];
    
    [self performSelector:@selector(ballBackwards:) withObject:ballView afterDelay:0.25f];
}

- (void)failedBounce:(BallView*)ballView position:(int)position{
    CALayer* theLayer = ballView.layer;
    
    CAKeyframeAnimation *animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 0.43;
    
    // UIBezierPathで放物線のパスを生成
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    
    [path moveToPoint:bouncePoint[position]];
    if(position == 2)
        position = 3;
    else if(position == 1){
        if(touchEndedCup.cup.position == 0)
            position = 2;
    }
    [path addCurveToPoint:failedBounceEndPoint[position] controlPoint1:failedBounceCurvePoint1[position] controlPoint2:failedBounceCurvePoint2[position]];
    // パスをCAKeyframeAnimationオブジェクトにセット
    animation.path = path.CGPath;
    animation.delegate = self;
    // レイヤーにアニメーションを追加
    [theLayer addAnimation:animation forKey:@"failedBounce"];
    [self performSelector:@selector(ballBackwards:) withObject:ballView afterDelay:0.25f];
    
    
}

- (void)ballBackwards:(BallView*)ballView{
    ballView.layer.zPosition = 0.0;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    
    if(theAnimation == [ballOfGameOverView.layer animationForKey:@"fallBall"]){
        
        scoreLabel.layer.zPosition = 0.0;
        gameOverView.layer.zPosition = 0.0;
        gameOverLabel.layer.zPosition = 0.0;
        ballOfGameOverView.layer.zPosition = 1.0;
        shadowOfBall.layer.zPosition = 0.5;
        [gameOverView addSubview:shadowOfBall];
         CGRect gameOverLabelFrame = CGRectMake(referenceSizeOfGameOver.width * gameOverLabelScale.x, referenceSizeOfGameOver.height * gameOverLabelScale.y, referenceSizeOfGameOver.width * gameOverLabelScale.width, referenceSizeOfGameOver.height * gameOverLabelScale.height);
        
        CGRect gameOverLabelStartFrame = CGRectMake(gameOverLabelFrame.origin.x, 0.0 - gameOverLabelFrame.size.height, gameOverLabelFrame.size.width, gameOverLabelFrame.size.height);
        
        gameOverLabel.frame = gameOverLabelStartFrame;
        [self.view addSubview:gameOverLabel];
        
        [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^ {
            gameOverLabel.frame = gameOverLabelFrame;
        } completion:^(BOOL finished){
            if(finished){
                gameOverAnimation = NO;
                [self showScore];
                [self showBtns];
                [self resetCup];
            }
        }];
    }
    else {
        BallView* ballView =  [bounceBalls objectAtIndex:0];
        [ballView removeFromSuperview];
        [bounceBalls removeObjectAtIndex:0];

        if(gameOver)
            [self performSelector:@selector(gameOver) withObject:nil afterDelay:0.5f];
    }
    
}

-(void)checkBall{
    for (int i = 0; i < currentBalls.count; i++) {
        BallView* ballView  = [currentBalls objectAtIndex:i];
        
        position ballPosition;
        color ballColor;
        BOOL cupOverturn;
        float ballPoint = ballView.frame.origin.y + ballView.frame.size.height - referenceSize.width * 0.03;
        
        if(self.redCupView.frame.origin.y > ballPoint){
            continue;
        } else if(self.redCupView.frame.origin.y < ballPoint && ballPoint < checkPointOfBall){
            ballColor = ballView.ball.color;
            ballPosition =  ballView.ball.position;
            
            cupOverturn = [self cupOverturnWithPosition:ballPosition];
            
            if(cupOverturn == YES){
                if(ballColor == Yellow){
                    [self.scoreboardView.scoreboard scoreUp];
                    [self.scoreboardView updateScore];
                    [self checkScore];
                    [bounceBalls addObject:ballView];
                    [self scoreSound];
                }else {
                    [timer invalidate];
                    [bounceBalls addObject:ballView];
                    [self removeBalls];
                    [self.view addSubview:ballView];
                    [self failedSound];
                    gameOver = YES;

                }
                
                [ballView.delegate bounce:ballView position:ballPosition];
                [currentBalls removeObject:ballView];
            }else{
                CupView * cupView = [self cupWithPosition:ballPosition];
                if(cupView.moving){
                    [timer invalidate];
                    [bounceBalls addObject:ballView];
                    [self removeBalls];
                    [self.view addSubview:ballView];
                    gameOver = YES;
                    [ballView.delegate failedBounce:ballView position:ballPosition];
                    [self failedSound];

                }else{
                    continue;
                }
            }
        }else if(checkPointOfBall < ballPoint){
            ballColor = ballView.ball.color;
            ballPosition =  ballView.ball.position;
            
            color cupColor = [self cupColorWithPosition:ballPosition];
            cupOverturn = [self cupOverturnWithPosition:ballPosition];
            
            if(ballColor == cupColor && cupOverturn == NO){
                [self scoreSound];
                [self.scoreboardView.scoreboard scoreUp];
                [self.scoreboardView updateScore];
                [self checkScore];
                
            }else{
                [timer invalidate];
                [self removeBalls];
                [self failedSound];
                [self performSelector:@selector(gameOver) withObject:nil afterDelay:1.0f];
                return;
            }
            
            [ballView removeFromSuperview];
            ballView.ball = nil;
            [currentBalls removeObject:ballView];
        }
    }
}



- (void)prepareForGameOver{
    if(!scoreOfGameOverView1)
        scoreOfGameOverView1 = [[UIImageView alloc]init];
    if(!scoreOfGameOverView2)
        scoreOfGameOverView2 = [[UIImageView alloc]init];
    if(!scoreOfGameOverView3)
        scoreOfGameOverView3 = [[UIImageView alloc]init];
    if(!scoreOfGameOverView4)
        scoreOfGameOverView4 = [[UIImageView alloc]init];
    
    
    float retryX = (referenceSizeOfGameOver.width / 2.0) - (referenceSizeOfGameOver.width * retryScale.width / 2.0);
    if(!retryBtn){
        CGRect retryFrame = CGRectMake(retryX, referenceSizeOfGameOver.height * retryScale.y, referenceSizeOfGameOver.width * retryScale.width,referenceSizeOfGameOver.height * retryScale.height);
        retryBtn = [[UIButton alloc] initWithFrame:retryFrame];
        [retryBtn setImage:[UIImage imageNamed:retryBtnImage] forState:UIControlStateNormal];
        [retryBtn addTarget:self action:@selector(retry:) forControlEvents:UIControlEventTouchUpInside];
        retryBtn.userInteractionEnabled = YES;
    }
    
    if(!titleBtn){
        CGRect titleFrame = CGRectMake(retryX, referenceSizeOfGameOver.height * titleScale.y, referenceSizeOfGameOver.width * titleScale.width, referenceSizeOfGameOver.height * titleScale.height);
        titleBtn = [[UIButton alloc] initWithFrame:titleFrame];
        [titleBtn setImage:[UIImage imageNamed:titleBtnImage] forState:UIControlStateNormal];
        [titleBtn addTarget:self action:@selector(backTitle:) forControlEvents:UIControlEventTouchUpInside];
        titleBtn.userInteractionEnabled = YES;
    }
    
    if(!bestBtn){
        CGRect bestFrame = CGRectMake((referenceSizeOfGameOver.width / 2.0) - (referenceSizeOfGameOver.width * 0.005) - (referenceSizeOfGameOver.width * bestScale.width), referenceSizeOfGameOver.height * bestScale.y, referenceSizeOfGameOver.width * bestScale.width, referenceSizeOfGameOver.height * bestScale.height);
        
        bestBtn = [[UIButton alloc] initWithFrame:bestFrame];
        [bestBtn setImage:[UIImage imageNamed:bestBtnImage] forState:UIControlStateNormal];
        [bestBtn addTarget:self action:@selector(showBest:) forControlEvents:UIControlEventTouchUpInside];
        bestBtn.userInteractionEnabled = YES;
    }
    if(!rankBtn){
   
        CGRect rankFrame = CGRectMake((referenceSizeOfGameOver.width / 2.0) + (referenceSizeOfGameOver.width * 0.005), referenceSizeOfGameOver.height * rankScale.y, referenceSizeOfGameOver.width * rankScale.width, referenceSizeOfGameOver.height * rankScale.height);
        
        rankBtn = [[UIButton alloc] initWithFrame:rankFrame];
        [rankBtn setImage:[UIImage imageNamed:rankBtnImage] forState:UIControlStateNormal];
        [rankBtn addTarget:self action:@selector(showRank:) forControlEvents:UIControlEventTouchUpInside];
        rankBtn.userInteractionEnabled = YES;
    }
    
    if(!scoreViews)
        scoreViews = [NSArray arrayWithObjects:scoreOfGameOverView1, scoreOfGameOverView2, scoreOfGameOverView3, scoreOfGameOverView4, nil];
    if(!scoreNumberImages)
        scoreNumberImages = [NSArray arrayWithObjects:score0Image, score1Image, score2Image, score3Image, score4Image, score5Image, score6Image, score7Image, score8Image, score9Image, nil];
    
    if(!gameOverLabel){
        gameOverLabel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:gameOverLabelImage]];
        gameOverLabel.layer.zPosition = 3.5;
    }
    
    if(!scoreLabel){
        
        CGRect scoreLabelFrame = CGRectMake(referenceSizeOfGameOver.width * scoreLabelScale.x, referenceSizeOfGameOver.height * scoreLabelScale.y, referenceSizeOfGameOver.width * scoreLabelScale.width, referenceSizeOfGameOver.height * scoreLabelScale.height);
        scoreLabel = [[UIImageView alloc] initWithFrame:scoreLabelFrame];
        scoreLabel.image = [UIImage imageNamed:scoreLable];
        scoreLabel.layer.zPosition = 3.5;
    }
    if(!gameOverView) {
        
        CGRect gameOverFrame = CGRectMake ( 0.0f, 0.0f, referenceSizeOfGameOver.width, referenceSizeOfGameOver.height);
        gameOverView = [[UIImageView alloc] initWithFrame:gameOverFrame];
        gameOverView.image = [UIImage imageNamed:gameOverViewImage];
        gameOverView.clipsToBounds = YES;
        gameOverView.userInteractionEnabled = YES;
    }
    gameOverView.layer.zPosition = 3.0;
    
    if(!ballOfGameOverView){
        
        CGRect ballFrmae = CGRectMake(referenceSizeOfGameOver.width * ballOfGameOverScale.x, 0.0 - referenceSizeOfGameOver.height * ballOfGameOverScale.height, referenceSizeOfGameOver.width * ballOfGameOverScale.width, referenceSizeOfGameOver.height * ballOfGameOverScale.height);
        ballOfGameOverView = [[UIImageView alloc] initWithFrame:ballFrmae];
        ballOfGameOverView.image = [UIImage imageNamed:ballGameOverImage];
        
    }
    
    
    if(!fallBallEndPoint.x)
        fallBallEndPoint = CGPointMake(referenceSizeOfGameOver.width * 0.67 - ballOfGameOverView.frame.size.width / 2.0, referenceSizeOfGameOver.height * 0.47 - ballOfGameOverView.frame.size.height / 2.0);
    if(!fallBallEndPoint2.x)
        fallBallEndPoint2 = CGPointMake(referenceSizeOfGameOver.width * 0.64, referenceSizeOfGameOver.height * 0.64);
    if(!fallBallEndPoint3.x)
        fallBallEndPoint3 = CGPointMake(referenceSizeOfGameOver.width * 0.65, referenceSizeOfGameOver.height * 0.65);
    
    if(!shadowOfBall){
        CGRect shadowFrame = CGRectMake(0.0, 0.0, referenceSizeOfGameOver.width * 0.14, referenceSizeOfGameOver.height * 0.01);
        shadowOfBall = [[UIImageView alloc] initWithFrame:shadowFrame];
        shadowOfBall.image = [UIImage imageNamed:shadowOfBallImage];
        shadowOfBall.center = CGPointMake(referenceSizeOfGameOver.width * 0.65, referenceSizeOfGameOver.height * 0.65 + ballOfGameOverView.frame.size.height / 2.0);
        shadowOfBall.alpha = 0.1;
        
    }
    
    if(!bounceHeight)
        bounceHeight = referenceSizeOfGameOver.height * bounceScale;
    if(!bounceHeight2)
        bounceHeight2 = referenceSizeOfGameOver.height * bounceScale2;
    
    prepareForGameOverDone = YES;
}



- (void)playStart{
 
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                             target:self
                                           selector:@selector(mainloop)
                                           userInfo:nil
                                            repeats:YES];
    
}

- (void)mainloop{
    [self makeBall];
    [self dropBall];
    [self checkBall];
}

-(void)makeBall{
    if(makeBallCount < makeBallPoint) {
        makeBallCount +=1;
        
        return;
    }
    else {
        color color = arc4random_uniform(4);
        position position = arc4random_uniform(3);
        
        CGRect frame = CGRectMake(referenceFrameOfCup[position].origin.x + ((referenceFrameOfCup[Center].size.width - ballSize) / 2), 0 - ballSize, ballSize, ballSize);
        
        Ball* ball = [[Ball alloc] initWithColor:color position:position speed:ballSpeed];
        
        BallView *ballView = [[BallView alloc] initWithFrame:frame ball:ball];
        ballView.layer.zPosition = 2.0;
        ballView.delegate = self;
        
        [currentBalls addObject:ballView];
        [self.view addSubview:ballView];
        
        makeBallCount = 0;
    }
}

-(void)dropBall{
    for (int i = 0; i < currentBalls.count; i++) {
        BallView *ballView = [currentBalls objectAtIndex:i];
        [ballView drop];
    }
}

- (void)checkScore{
    if(self.scoreboardView.scoreboard.score % 100 == 50 || self.scoreboardView.scoreboard.score % 100 == 0)
    {
        if(makeBallPoint > 70)
            makeBallPoint -= 1;
        
        if(ballSpeed < maxBallSpeed && self.scoreboardView.scoreboard.score % 100 == 0){
            currentBallSpeed -= 3.0;
            ballSpeed = checkPointOfBall / currentBallSpeed;
        }
    
    }
}

//GameOver時のボールが落ちるアニメーション
- (void)fallBall{
    
    
    CALayer* theLayer = ballOfGameOverView.layer;
    
    
    CAKeyframeAnimation *animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    
    animation.duration = 0.9;
    
    
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, ballOfGameOverView.center.x, ballOfGameOverView.center.y);
    CGPathAddCurveToPoint(curvedPath, NULL,
                          ballOfGameOverView.center.x, ballOfGameOverView.center.y,
                          ballOfGameOverView.center.x + (fallBallEndPoint.x - ballOfGameOverView.center.x) / 2.0, ballOfGameOverView.center.y + (fallBallEndPoint.y - ballOfGameOverView.center.y) / 2.0,
                          fallBallEndPoint.x, fallBallEndPoint.y);
    CGPathAddCurveToPoint(curvedPath, NULL, fallBallEndPoint.x + bounceHeight / 2.0, fallBallEndPoint.y - bounceHeight, fallBallEndPoint2.x - bounceHeight / 2.0, fallBallEndPoint.y - bounceHeight, fallBallEndPoint2.x, fallBallEndPoint2.y);
    CGPathAddCurveToPoint(curvedPath, NULL, fallBallEndPoint2.x + bounceHeight2 / 2.0, fallBallEndPoint2.y - bounceHeight2, fallBallEndPoint3.x - bounceHeight2 / 2.0, fallBallEndPoint3.y - bounceHeight2, fallBallEndPoint3.x, fallBallEndPoint3.y);
    animation.delegate = self;
    animation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    gameOverAnimation = YES;
    [theLayer addAnimation:animation forKey:@"fallBall"];
    
}

- (void)animationFailed{
    if(gameOverAnimation){
        gameOverAnimation = NO;
        [self showScore];
        [self showBtns];
        [self resetCup];
    }
}

- (void)configureScore4{
    int temp;
    
    temp = self.scoreboardView.scoreboard.score;
    for(int i = 0; i < 4; i++){
        int number;
        number = temp % 10;
        [scoreViews[i] setImage:[UIImage imageNamed:scoreNumberImages[number]]];
        CGRect rect = CGRectMake(referenceSizeOfGameOver.width * scoreScale4[i].x, referenceSizeOfGameOver.height *scoreScale4[i].y,referenceSizeOfGameOver.width * scoreScale4[i].width,referenceSizeOfGameOver.height * scoreScale4[i].height);
        [scoreViews[i] setFrame:rect];
        [self.view addSubview:scoreViews[i]];
        temp /= 10;
    }
    
    
    
}

- (void)configureScore3{
    int temp;
    
    temp = self.scoreboardView.scoreboard.score;
    for(int i = 0; i < 3; i++){
        int number;
        number = temp % 10;
        [scoreViews[i] setImage:[UIImage imageNamed:scoreNumberImages[number]]];
        CGRect rect = CGRectMake(referenceSizeOfGameOver.width * scoreScale3[i].x, referenceSizeOfGameOver.height  *scoreScale3[i].y,referenceSizeOfGameOver.width * scoreScale3[i].width,referenceSizeOfGameOver.height * scoreScale3[i].height);
        [scoreViews[i] setFrame:rect];
        [self.view addSubview:scoreViews[i]];
        temp /= 10;
    }
    
    
    
}



- (void)configureScore2{
    int temp;
    
    temp = self.scoreboardView.scoreboard.score;
    for(int i = 0; i < 2; i++){
        int number;
        number = temp % 10;
        [scoreViews[i] setImage:[UIImage imageNamed:scoreNumberImages[number]]];
        CGRect rect = CGRectMake(referenceSizeOfGameOver.width * scoreScale2[i].x, referenceSizeOfGameOver.height * scoreScale2[i].y,referenceSizeOfGameOver.width * scoreScale2[i].width,referenceSizeOfGameOver.height * scoreScale2[i].height);
        [scoreViews[i] setFrame:rect];
        [self.view addSubview:scoreViews[i]];
        temp /= 10;
    }
    
}


- (void)configureScore{
    
    int number;
    number = self.scoreboardView.scoreboard.score;
    [scoreViews[0] setImage:[UIImage imageNamed:scoreNumberImages[number]]];
    CGRect rect = CGRectMake(referenceSizeOfGameOver.width * scoreScale.x, referenceSizeOfGameOver.height *scoreScale.y,referenceSizeOfGameOver.width * scoreScale.width,referenceSizeOfGameOver.height * scoreScale.height);
    [scoreViews[0] setFrame:rect];
    [self.view addSubview:scoreViews[0]];
}



- (void)showScore{
    [self.view addSubview:scoreLabel];
    
    switch (self.scoreboardView.scoreboard.placeOfScore) {
        case 1:
            [self configureScore];
            break;
        case 2:
            [self configureScore2];
            break;
        case 3:
            [self configureScore3];
            break;
        case 4:
            [self configureScore4];
            break;
        default:
            break;
    }
}

- (void)gameOver{
    if ( self.audioPlayer.playing )
        [self.audioPlayer stop];
    if(soundOn)
        [self playGameOverSound];
    [self prepareForGameOver];
    [self sendScore];
    [self saveBestScore:self.scoreboardView.scoreboard.score];
    [self.view  addSubview:gameOverView];
    [gameOverView addSubview:ballOfGameOverView];
    [self removeViews];
    [self fallBall];
}




- (void)showBtns{
    [gameOverView addSubview:retryBtn];
    [gameOverView addSubview:bestBtn];
    [gameOverView addSubview:rankBtn];
    [gameOverView addSubview:titleBtn];
}

- (void)playGameOverSound{
    
    NSError *error = nil;
    // 再生する audio ファイルのパスを取得
    NSString *path = [[NSBundle mainBundle] pathForResource:@"st006" ofType:@"mp3"];
    // パスから、再生するURLを作成する
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    // auido を再生するプレイヤーを作成する
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    // エラーが起きたとき
    if ( error != nil )
    {
        NSLog(@"Error %@", [error localizedDescription]);
    }
    // 自分自身をデリゲートに設定
    [self.audioPlayer setDelegate:self];
    self.audioPlayer.numberOfLoops = 0;
    self.audioPlayer.volume = 0.2;
    [self.audioPlayer play];
}

- (void)sendScore{
    GKScore* score = [[GKScore alloc] initWithLeaderboardIdentifier:kLeaderBoardId];
    score.value = self.scoreboardView.scoreboard.score;
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"書き込めませんでした。");
        }
    }];
}

- (void)removeBalls{
    do{
       for (int i = 0; i < currentBalls.count; i++){
           BallView* ballView  = [currentBalls objectAtIndex:i];
           [ballView removeFromSuperview];
           [currentBalls removeObject:ballView];
        
       }
    }while(currentBalls.count);
}

- (void)didEnterBackgroundDuringGame{
    if(!gameOver)
        gameOver = YES;
}

- (void)removeViews{
    self.deskView.hidden = YES;
    self.wallView.hidden = YES;
    self.scoreboardView.hidden = YES;
    [self.pictureView removeFromSuperview];
    [self.funitureView1 removeFromSuperview];
    [self.funitureView2 removeFromSuperview];
    [self.lightView removeFromSuperview];
    [self.redCupView.upperCupView removeFromSuperview];
    [self.redCupView removeFromSuperview];
    [self.greenCupView.upperCupView removeFromSuperview];
    [self.greenCupView removeFromSuperview];
    [self.blueCupView.upperCupView removeFromSuperview];
    [self.blueCupView removeFromSuperview];
}

- (void)removeGameOverViews{
    [gameOverView removeFromSuperview];
    [gameOverLabel removeFromSuperview];
    [ballOfGameOverView removeFromSuperview];
    [scoreLabel removeFromSuperview];
    for (UIImageView* view in scoreViews) {
        [view removeFromSuperview];
    }
    [retryBtn removeFromSuperview];
    [bestBtn removeFromSuperview];
    [rankBtn removeFromSuperview];
    [titleBtn removeFromSuperview];
    [shadowOfBall removeFromSuperview];
}


- (void)saveBestScore:(int)score{
    
    ud = [NSUserDefaults standardUserDefaults];
    NSArray *recordArray;
    
    if(self.bestScores)
    {
        NSMutableArray *mutableRecordArray = [[NSMutableArray alloc]init];

        mutableRecordArray = [self.bestScores mutableCopy];
        
        [mutableRecordArray addObject:[NSNumber numberWithInt:score]];
        
        NSSortDescriptor *sortDescripter = [[NSSortDescriptor alloc]initWithKey:nil ascending:NO];
        
        [mutableRecordArray sortUsingDescriptors:@[sortDescripter]];
        
        if (mutableRecordArray.count > 10) {
            [mutableRecordArray removeLastObject];
        }
        recordArray = [[NSArray alloc]initWithArray:[mutableRecordArray copy]];
        [mutableRecordArray removeAllObjects];
    }else {
        recordArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:score], nil];
    }
    
    [ud removeObjectForKey:@"BESTRECORDS"];
    [ud setObject:recordArray forKey:@"BESTRECORDS"];
  
    [ud synchronize];
    self.bestScores = recordArray;
}


- (void)retry:(UIButton *)button{
    if ( self.audioPlayer.playing )
        [self.audioPlayer stop];
    [self touchBtnSound];
    gameOver = NO;
    [self appearWallAndDesk];
    [self removeGameOverViews];
    [self resetScoreboard];
    [self prepareForGame];
    [self playStart];
    if(soundOn)
       [self playBGM];
}



- (void)resetCup{
    self.redCupView = nil;
    self.greenCupView = nil;
    self.blueCupView = nil;
}

- (void)resetScoreboard{
    [self.scoreboardView.scoreboard reset];
    [self.scoreboardView updateScore];
}
- (void)appearWallAndDesk{
    self.wallView.hidden = NO;
    self.deskView.hidden = NO;
    self.scoreboardView.hidden = NO;
}

- (void)backTitle:(UIButton *)button {
    if ( self.audioPlayer.playing )
        [self.audioPlayer stop];
    [self touchBtnSound];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)showBest:(UIButton *)button{
    if ( self.audioPlayer.playing )
        [self.audioPlayer stop];
   
    [self touchBtnSound];
    BestScoreViewController* bestScoreViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BestScoreViewController"];
    if(self.bestScores)
        bestScoreViewController.bestScores = self.bestScores;
    bestScoreViewController.soundOn = self.soundOn;
    [self removeGameOverViews];
    [self presentViewController:bestScoreViewController animated:NO completion:nil];
    
}

- (void)showRank:(UIButton *)button{
    [self touchBtnSound];
    
    GKGameCenterViewController *gcView = [GKGameCenterViewController new];
    if (gcView != nil)
    {
        gcView.gameCenterDelegate = self;
        gcView.viewState = GKGameCenterViewControllerStateLeaderboards;
        [self presentViewController:gcView animated:NO completion:nil];
    }

}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController{
    [self dismissViewControllerAnimated:NO completion:nil];
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

- (void)scoreSound{
    if(soundOn){
        CFBundleRef mainBundle;
        mainBundle = CFBundleGetMainBundle ();
        soundURL  = CFBundleCopyResourceURL (mainBundle,CFSTR ("powerup03"),CFSTR ("wav"),NULL);
        AudioServicesCreateSystemSoundID (soundURL, &soundID);
        CFRelease (soundURL);
        AudioServicesPlaySystemSound (soundID);
    }
    
}

- (void)failedSound{
    if(soundOn){
        CFBundleRef mainBundle;
        mainBundle = CFBundleGetMainBundle ();
        soundURL  = CFBundleCopyResourceURL (mainBundle,CFSTR ("powerdown07"),CFSTR ("wav"),NULL);
        AudioServicesCreateSystemSoundID (soundURL, &soundID);
        CFRelease (soundURL);
        AudioServicesPlaySystemSound (soundID);
    }
}

-(void)dismissViewFromBestScoreView{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
