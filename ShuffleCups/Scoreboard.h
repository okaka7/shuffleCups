//
//  Scoreboard.h
//  ShuffleCups
//
//  Created by KawanishiKota on 2016/04/05.
//  Copyright © 2016年 KawanishiKota. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Scoreboard : NSObject

@property int score;
@property int placeOfScore;


- (void)scoreUp;
- (void)reset;

@end
