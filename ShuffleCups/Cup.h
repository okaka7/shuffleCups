//
//  Cup.h
//  ShuffleCups
//
//  Created by KawanishiKota on 2016/04/05.
//  Copyright © 2016年 KawanishiKota. All rights reserved.
//

#import "CupBall.h"

@interface Cup : CupBall

@property (assign) color color;
@property (assign) position position;
@property (assign) BOOL overturn;

- (id)initWithColor:(int)color position:(int)position;

@end
