//
//  BestScoreViewController.m
//  ShuffleCups
//
//  Created by KawanishiKota on 2016/04/06.
//  Copyright © 2016年 KawanishiKota. All rights reserved.
//

#import "BestScoreViewController.h"
#import "ViewController.h"

typedef struct{float width; float height;} sizeScale;

@interface BestScoreViewController (){
    NSArray* bestScoreViews[10];
    NSArray* scoreNumberImages;
    CGSize referenceSize;
}

@end

@implementation BestScoreViewController

@synthesize bestScoreView = bestScoreView;
@synthesize soundID = soundID;
@synthesize soundURL = soundURL;
@synthesize audioPlayer = audioPlayer;
@synthesize soundOn = soundOn;

static sizeScale scoreSizeScale = {0.06, 0.057};
static sizeScale pointsSizeScale = {0.203, 0.041};
static float scoreViewsX4[4] = {0.5065, 0.44117, 0.3769, 0.3121};
static float scoreViewsX3[3] = {0.4741, 0.4093, 0.3451};
static float scoreViewsX2[2] = {0.4417, 0.37691};
static float scoreViewX = 0.4094;
static float pointsViewX = 0.62763;
static float scoreViewsY[10] = {0.2222, 0.2958, 0.3692, 0.4425, 0.5173, 0.5918, 0.6646, 0.7379, 0.8117, 0.8853};
static float pointsViewY[10] = {0.2471, 0.32, 0.3939, 0.46613, 0.5431, 0.6157, 0.689, 0.7634, 0.8354, 0.91};

static NSString* kBestScoreView = @"BestScoreView";
static NSString* kScoreNumber0Image = @"ScoreNumber0_BestScoreView.png";
static NSString* kScoreNumber1Image = @"ScoreNumber1_BestScoreView.png";
static NSString* kScoreNumber2Image = @"ScoreNumber2_BestScoreView.png";
static NSString* kScoreNumber3Image = @"ScoreNumber3_BestScoreView.png";
static NSString* kScoreNumber4Image = @"ScoreNumber4_BestScoreView.png";
static NSString* kScoreNumber5Image = @"ScoreNumber5_BestScoreView.png";
static NSString* kScoreNumber6Image = @"ScoreNumber6_BestScoreView.png";
static NSString* kScoreNumber7Image = @"ScoreNumber7_BestScoreView.png";
static NSString* kScoreNumber8Image = @"ScoreNumber8_BestScoreView.png";
static NSString* kScoreNumber9Image = @"ScoreNumber9_BestScoreView.png";
static NSString* kPointsImage = @"points.gif";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBestScoreViews];
    //広告削除済み
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        referenceSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    else
        referenceSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    scoreNumberImages = [NSArray arrayWithObjects:kScoreNumber0Image, kScoreNumber1Image, kScoreNumber2Image, kScoreNumber3Image, kScoreNumber4Image, kScoreNumber5Image, kScoreNumber6Image, kScoreNumber7Image, kScoreNumber8Image, kScoreNumber9Image, nil];

    if(self.audioPlayer)
        self.audioPlayer.delegate = self;
    else{
        if(self.soundOn)
        [self playBGM];
    }
    [self loadBestScoreViews];
    [self showBestScores];
}



- (void)showBestScoreViews{
    CGRect bestScoreViewFrame;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        bestScoreViewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    else
        bestScoreViewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.bestScoreView = [[UIButton alloc] initWithFrame:bestScoreViewFrame];
    [self.bestScoreView setImage:[UIImage imageNamed:kBestScoreView] forState:UIControlStateNormal];
    [self.bestScoreView addTarget:self action:@selector(goBackTitle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bestScoreView];
    
}

- (void)playBGM{
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tw029" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if ( error != nil )
    {
        NSLog(@"Error %@", [error localizedDescription]);
    }
    [self.audioPlayer setDelegate:self];
    self.audioPlayer.numberOfLoops = -1;
    self.audioPlayer.volume = 0.2;
    [self.audioPlayer play];
}


- (void)loadBestScoreViews{
    for(int i = 0; i < 10; i++){
        UIImageView* scoreView1 = [[UIImageView alloc] init];
        UIImageView* scoreView2 = [[UIImageView alloc] init];
        UIImageView* scoreView3 = [[UIImageView alloc] init];
        UIImageView* scoreView4 = [[UIImageView alloc] init];
        
        bestScoreViews[i] = [[NSArray alloc] initWithObjects:scoreView1, scoreView2, scoreView3, scoreView4, nil];
    }
}

- (void)showBestScores{
    
    for(int i = 0; i < self.bestScores.count; i++){
        int temp;
        temp = (int)[self.bestScores[i] integerValue];
        
        int placeOfScore =  [self checkplaceOfScore:temp];
        if(placeOfScore == 4){
            for (int j = 0; j < 4; j++) {
            
                int number;
                number = temp % 10;
                if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                [bestScoreViews[i][j] setImage:[UIImage imageNamed:scoreNumberImages[number]]];
                CGRect rect;
                
                rect = CGRectMake(referenceSize.width * scoreViewsX4[j], referenceSize.height * scoreViewsY[i],referenceSize.width * scoreSizeScale.width, referenceSize.height * scoreSizeScale.height);
                [bestScoreViews[i][j] setFrame:rect];
                [self.view addSubview:bestScoreViews[i][j]];
                temp /= 10;
                
            }
        }else if(placeOfScore == 3){
            for (int j = 0; j < 3; j++) {
                
                int number;
                number = temp % 10;
                [bestScoreViews[i][j] setImage:[UIImage imageNamed:scoreNumberImages[number]]];
                CGRect rect;
                rect = CGRectMake(referenceSize.width * scoreViewsX3[j], referenceSize.height * scoreViewsY[i],referenceSize.width * scoreSizeScale.width, referenceSize.height * scoreSizeScale.height);
                
                
                [bestScoreViews[i][j] setFrame:rect];
                [self.view addSubview:bestScoreViews[i][j]];
                temp /= 10;
                
            }
        }else if(placeOfScore == 2){
            for (int j = 0; j < 2; j++) {
                
                int number;
                number = temp % 10;
                [bestScoreViews[i][j] setImage:[UIImage imageNamed:scoreNumberImages[number]]];
                CGRect rect;
                rect = CGRectMake(referenceSize.width * scoreViewsX2[j], referenceSize.height * scoreViewsY[i],referenceSize.width * scoreSizeScale.width, referenceSize.height * scoreSizeScale.height);
                
                [bestScoreViews[i][j] setFrame:rect];
                [self.view addSubview:bestScoreViews[i][j]];
                temp /= 10;
                
            }

        }else if(placeOfScore == 1){
            
            int number;
            number = temp % 10;
            [bestScoreViews[i][1] setImage:[UIImage imageNamed:scoreNumberImages[number]]];
            CGRect rect;
            rect = CGRectMake(referenceSize.width * scoreViewX, referenceSize.height * scoreViewsY[i],referenceSize.width * scoreSizeScale.width, referenceSize.height * scoreSizeScale.height);
            
            [bestScoreViews[i][1] setFrame:rect];
            [self.view addSubview:bestScoreViews[i][1]];
        }
        
        UIImageView* pointsView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kPointsImage]];
       
        pointsView.frame = CGRectMake(referenceSize.width * pointsViewX, referenceSize.height * pointsViewY[i], referenceSize.width * pointsSizeScale.width, referenceSize.height * pointsSizeScale.height);
        
        [self.view addSubview:pointsView];
        
    }
    
}

- (int)checkplaceOfScore:(int)score{
    if(score >= 10000)
        return 5;
    else if(score >= 1000)
        return  4;
    else if(score >= 100)
        return  3;
    else if(score >= 10)
        return  2;
    else
        return  1;
}


- (void)goBackTitle:(id)sender {
    ViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Title"];

    if(self.audioPlayer){
        viewController.audioPlayer = self.audioPlayer;
        self.audioPlayer = nil;
    }
    viewController.soundOn = self.soundOn;
    [self dismissViewControllerAnimated:NO completion:^(void){
        NSNotification* n = [NSNotification notificationWithName:@"dismissViewFromBestScoreView" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:n];
    }];

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
