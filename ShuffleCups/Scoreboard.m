//
//  Scoreboard.m
//  ShuffleCups
//
//  Created by KawanishiKota on 2016/04/05.
//  Copyright © 2016年 KawanishiKota. All rights reserved.
//

#import "Scoreboard.h"

@implementation Scoreboard

- (id)init
{
    self = [super init];
    if(self){
        
        self.score = 0;
        self.placeOfScore = 1;
    }
    
    return self;
}

- (void)scoreUp{
    self.score += 10;
    
    [self checkPlaceOfScore];
}

- (void)reset{
    self.score = 0;
    [self checkPlaceOfScore];
}
- (void)checkPlaceOfScore
{
    if(self.score >= 10000)
        self.placeOfScore = 5;
    else if(self.score >= 1000)
        self.placeOfScore = 4;
    else if(self.score >= 100)
        self.placeOfScore = 3;
    else if(self.score >= 10)
        self.placeOfScore = 2;
    else
        self.placeOfScore = 1;
    
   
}


@end
