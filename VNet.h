//
//  VNet.h
//  VerletNet
//
//  Created by Jesse Mihigo on 3/3/15.
//

#import <Foundation/Foundation.h>
#import "VPoint.h"
#import "VStick.h"
#import "cocos2d.h"

@interface VNet : NSObject {
    int numPointsX;
    int numPointsY;
    NSMutableArray *vPoints;
    NSMutableArray *vSticksX;
    NSMutableArray *vSticksY;
    NSMutableArray *ropeSpritesX;
    NSMutableArray *ropeSpritesY;
    CCSpriteFrame* spriteFrame;
    CCNode * node;
}
-(id)initWithPoints:(CGPoint)pointA pointB:(CGPoint)pointB spriteFrame:(CCSpriteFrame*)spriteFrameArgument node: (CCNode *)nodeArgument width: (float) width andHeight: (float) height;
-(void)createRopeWithPointA:(CGPoint)pointA pointB:(CGPoint)pointB width:(float)width andHeight: (float) height;
-(void)updateWithPoints:(CGPoint)pointA pointB:(CGPoint)pointB dt:(float)dt;
-(void)updateSprites;


@end

