//
//  ScoreboardView.m
//  ShuffleCups
//
//  Created by KawanishiKota on 2016/04/05.
//  Copyright © 2016年 KawanishiKota. All rights reserved.
//

#import "ScoreboardView.h"
#import "Scoreboard.h"


typedef struct{ float x; float y; float width; float height;} scale;

@interface ScoreboardView()
{
    NSArray* numberImages;
    NSArray* scoreViews;
   
}

@end

@implementation ScoreboardView

static NSString* scoreboardImage = @"Scoreboard";

static NSString* number0Image = @"ScoreNumber0.png";
static NSString* number1Image = @"ScoreNumber1.png";
static NSString* number2Image = @"ScoreNumber2.png";
static NSString* number3Image = @"ScoreNumber3.png";
static NSString* number4Image = @"ScoreNumber4.png";
static NSString* number5Image = @"ScoreNumber5.png";
static NSString* number6Image = @"ScoreNumber6.png";
static NSString* number7Image = @"ScoreNumber7.png";
static NSString* number8Image = @"ScoreNumber8.png";
static NSString* number9Image = @"ScoreNumber9.png";

static scale scoreScale1 = {0.392, 0.448, 0.215, 0.31};
static scale scoreScale2[2] = {{0.51, 0.448, 0.215, 0.31}, {0.274, 0.448, 0.215, 0.31}};
static scale scoreScale3[3] = {{ 0.64, 0.448, 0.215, 0.31}, {0.4, 0.448, 0.215, 0.31}, {0.15, 0.448, 0.215, 0.31},  };
static scale scoreScale4[4] = {{0.72, 0.448, 0.215, 0.31}, {0.5, 0.448, 0.215, 0.31}, {0.3, 0.448, 0.215, 0.31}, {0.1, 0.448, 0.215, 0.31},  };



- (id)initWithFrame:(CGRect)frame scoreboard:(Scoreboard *)scoreboard{
    self = [super initWithFrame:frame];
    if(self){
        self.scoreboard = scoreboard;
        self.image = [UIImage imageNamed:scoreboardImage];
        
        double x = self.frame.size.width * scoreScale1.x;
        double y = self.frame.size.height * scoreScale1.y;
        double w = self.frame.size.width * scoreScale1.width;
        double h = self.frame.size.height * scoreScale1.height;
        
        CGRect score0Rect = CGRectMake(x, y, w, h);
        self.score0 = [[UIImageView alloc] initWithFrame:score0Rect];
        self.score0.image = [UIImage imageNamed:number0Image];
        [self addSubview:self.score0];
        
        self.score1 = [[UIImageView alloc] init];
        self.score2 = [[UIImageView alloc] init];
        self.score3 = [[UIImageView alloc] init];
        
        numberImages = [NSArray arrayWithObjects:number0Image, number1Image, number2Image, number3Image, number4Image, number5Image, number6Image, number7Image, number8Image, number9Image, nil];
        scoreViews = [NSArray arrayWithObjects:self.score0,self.score1, self.score2, self.score3, nil];
        
    }
    
    return self;
}

- (void)resetScoreViews{
    
    [self.score0 removeFromSuperview];
    [self.score1 removeFromSuperview];
    [self.score2 removeFromSuperview];
    [self.score3 removeFromSuperview];
}

- (void)updateScoreboard4{
    int temp;
    
    temp = self.scoreboard.score;
    for(int i = 0; i < 4; i++){
        int number;
        number = temp % 10;
        [scoreViews[i] setImage:[UIImage imageNamed:numberImages[number]]];
        CGRect frame = CGRectMake(self.frame.size.width * scoreScale4[i].x, self.frame.size.height * scoreScale4[i].y,self.frame.size.width * scoreScale4[i].width,self.frame.size.height * scoreScale4[i].height);
        [scoreViews[i] setFrame:frame];
        [self addSubview:scoreViews[i]];
        temp /= 10;
    }
}

- (void)updateScoreboard3{
    int temp;
    
    temp = self.scoreboard.score;
    for(int i = 0; i < 3; i++){
        int number;
        number = temp % 10;
        [scoreViews[i] setImage:[UIImage imageNamed:numberImages[number]]];
        CGRect frame = CGRectMake(self.frame.size.width * scoreScale3[i].x, self.frame.size.height *scoreScale3[i].y,self.frame.size.width * scoreScale3[i].width,self.frame.size.height * scoreScale3[i].height);
        [scoreViews[i] setFrame:frame];
        [self addSubview:scoreViews[i]];
        temp /= 10;
    }
}

- (void)updateScoreboard2{
    int temp;
    
    temp = self.scoreboard.score;
    for(int i = 0; i < 2; i++){
        int number;
        number = temp % 10;
        [scoreViews[i] setImage:[UIImage imageNamed:numberImages[number]]];
        CGRect rect = CGRectMake(self.frame.size.width * scoreScale2[i].x, self.frame.size.height *scoreScale2[i].y,self.frame.size.width * scoreScale2[i].width,self.frame.size.height * scoreScale2[i].height);
        [scoreViews[i] setFrame:rect];
        [self addSubview:scoreViews[i]];
        temp /= 10;
        
    }
    
}

- (void)updateScoreboard{
    UIImageView* numberImage = scoreViews[0];
    CGRect rect = CGRectMake(self.frame.size.width * scoreScale1.x, self.frame.size.height *scoreScale1.y,self.frame.size.width * scoreScale1.width,self.frame.size.height * scoreScale1.height);
    numberImage.frame = rect;
    [numberImage setImage:[UIImage imageNamed:numberImages[self.scoreboard.score]]];
    [self addSubview:numberImage];
}


- (void)updateScore{
    [self resetScoreViews];
    
    switch (self.scoreboard.placeOfScore) {
        case 1:
            [self updateScoreboard];
            break;
        case 2:
            [self updateScoreboard2];
            break;
        case 3:
            [self updateScoreboard3];
            break;
        case 4:
            [self updateScoreboard4];
            break;
        default:
            break;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
