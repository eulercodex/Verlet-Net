//
//  VNet.m
//  VerletNet
//
//  Created by Jesse on 3/2/15.
//

#import "VNet.h"
#import "CCTexture_Private.h"

@implementation VNet

-(id)initWithPoints:(CGPoint)pointA pointB:(CGPoint)pointB spriteFrame:(CCSpriteFrame*)spriteFrameArgument node: (CCNode *)nodeArgument width: (float) width andHeight: (float) height {
    if((self = [super init])) {
        spriteFrame = spriteFrameArgument;
        node = nodeArgument;
        [self createRopeWithPointA:pointA pointB:pointB width:width andHeight: height];
    }
    return self;
}

-(void)createRopeWithPointA:(CGPoint)pointA pointB:(CGPoint)pointB width:(float)width andHeight: (float) height {
    vPoints = [[NSMutableArray alloc] init];
    vSticksX = [[NSMutableArray alloc] init];
    vSticksY = [[NSMutableArray alloc] init];
    ropeSpritesX = [[NSMutableArray alloc] init];
    ropeSpritesY = [[NSMutableArray alloc] init];
    int segmentFactorX = 10; //increase value to have less segments per rope, decrease to have more segments
    int segmentFactorY = 10; //increase value to have less segments per rope, decrease to have more segments
    numPointsX = width/segmentFactorX;
    numPointsY = height/segmentFactorY;
    
    CGPoint diffVectorX = ccpSub(pointB,pointA); // point/vector AB
    CGPoint diffVectorY = ccpSub(ccp(pointA.x, pointA.y-height),pointA);
    
    float multiplierX = width / (numPointsX-1); // initial distance between segments/points
    float multiplierY = height / (numPointsY-1); // initial distance between segments/points
    for (int i = 0; i < numPointsX; i++) {
        [vPoints addObject:[[NSMutableArray alloc] init]];
        for (int j = 0; j < numPointsY; j++) {
            CGPoint vector = ccpAdd(ccpMult(ccpNormalize(diffVectorX),multiplierX*i), ccpMult(ccpNormalize(diffVectorY),multiplierY*j));
            CGPoint tmpVector = ccpAdd(pointA,vector);
            VPoint *tmpPoint = [[VPoint alloc] init];
            [tmpPoint setPos:tmpVector.x y:tmpVector.y];
            [[vPoints objectAtIndex:i] addObject:tmpPoint];
        }
    }
    //add vertical VSticks | | |
    for (int i = 0; i < numPointsX; i++) {
        [vSticksY addObject:[[NSMutableArray alloc] init]];
        [ropeSpritesY addObject:[[NSMutableArray alloc] init]];
        for (int j = 0; j < numPointsY-1; j++) {
            VPoint *point1 = vPoints[i][j];
            VPoint *point2 = vPoints[i][j+1];
            //create and store vstick
            VStick *tmpStick = [[VStick alloc] initWith:point1 pointb:point2];
            [vSticksY[i] addObject: tmpStick];
            //configure and add spriteframe
            CGPoint stickVector = ccpSub(ccp(point1.x,point1.y),ccp(point2.x,point2.y));
            float stickAngle = ccpToAngle(stickVector);
            CCSprite *tmpSprite = [CCSprite spriteWithTexture:spriteFrame.texture rect:CGRectMake(0,0,multiplierY,spriteFrame.texture.pixelHeight/4)];
            ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
            [tmpSprite.texture setTexParameters:&params];
            [tmpSprite setPosition:ccpMidpoint(ccp(point1.x,point1.y),ccp(point2.x,point2.y))];
            [tmpSprite setRotation:-1 * CC_RADIANS_TO_DEGREES(stickAngle)];
            
            [node addChild:tmpSprite];
            [ropeSpritesY[i] addObject: tmpSprite];
            
        }
    }
    //add horizontal VSticks - - -
    for (int j = 0; j < numPointsY; j++) {
        [vSticksX addObject: [[NSMutableArray alloc] init]];
        [ropeSpritesX addObject: [[NSMutableArray alloc] init]];
        for (int i = 0; i < numPointsX-1; i++) {
            VPoint *point1 = vPoints[i][j];
            VPoint *point2 = vPoints[i+1][j];
            //create and store vstick
            VStick *tmpStick = [[VStick alloc] initWith:point1 pointb:point2];
            [vSticksX[j] addObject: tmpStick];
            //configure and add spriteframe
            CGPoint stickVector = ccpSub(ccp(point1.x,point1.y),ccp(point2.x,point2.y));
            float stickAngle = ccpToAngle(stickVector);
            CCSprite *tmpSprite = [CCSprite spriteWithTexture:spriteFrame.texture rect:CGRectMake(0,0,multiplierX,spriteFrame.texture.pixelHeight/4)];
            ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
            [tmpSprite.texture setTexParameters:&params];
            [tmpSprite setPosition:ccpMidpoint(ccp(point1.x,point1.y),ccp(point2.x,point2.y))];
            [tmpSprite setRotation:-1 * CC_RADIANS_TO_DEGREES(stickAngle)];
            
            [node addChild:tmpSprite];
            [ropeSpritesX[j] addObject: tmpSprite];
        }
    }
    
}

-(void)updateWithPoints:(CGPoint)pointA pointB:(CGPoint)pointB dt:(float)dt {
    //manually set position for first and last point of rope
    [vPoints[0][0] setPos:pointA.x y:pointA.y];
    [vPoints[numPointsX-1][0] setPos:pointB.x y:pointB.y];
    
    //update points, apply gravity. point A and point B are anchor points
    for (int i = 0; i < numPointsX; i++) {
        for (int j = 0; j < numPointsY; j++) {
            BOOL aBool = (i != 0) && (j != 0);
            BOOL anotherBool = (i != numPointsX-1) && (j != 0);
            if (aBool || anotherBool) {
                [(VPoint *)vPoints[i][j] applyGravity:dt];
                [(VPoint *)vPoints[i][j] update:dt];
            }
        }
    }
    
    
    //contract sticks
    int iterations = 5;
    for(int k=0;k<iterations;k++) {
        //up to down
        for (int j = 0; j < numPointsY; j++) {
            for (int i = 0; i < numPointsX-1; i++) {
                [vSticksX[j][i] contract];
            }
        }
        //down to up
        for (int j = numPointsY-1; j > -1; j--) {
            for (int i = 0; i < numPointsX-1; i++) {
                [vSticksX[j][i] contract];
            }
        }
        //left to right
        for (int i = 0; i < numPointsX; i++) {
            for (int j = 0; j < numPointsY-1; j++) {
                [vSticksY[i][j] contract];
            }
        }
        //right to left
        for (int i = numPointsX-1; i > -1; i--) {
            for (int j = 0; j < numPointsY-1; j++) {
                [vSticksY[i][j] contract];
            }
        }
    }
    
}

-(void)updateSprites {
    //vertical stripes | | |
    for (int i = 0; i < numPointsX; i++) {
        for (int j = 0; j < numPointsY-1; j++) {
            VStick *vStick = vSticksY[i][j];
            VPoint *point1 = [vStick getPointA];
            VPoint *point2 = [vStick getPointB];
            CGPoint point1_ = ccp(point1.x,point1.y);
            CGPoint point2_ = ccp(point2.x,point2.y);
            float stickAngle = ccpToAngle(ccpSub(point1_,point2_));
            CCSprite *tmpSprite = ropeSpritesY[i][j];
            [tmpSprite setPosition:ccpMidpoint(point1_,point2_)];
            [tmpSprite setRotation: -CC_RADIANS_TO_DEGREES(stickAngle)];
            
        }
    }
    //horizontal stripes - - -
    for (int j = 0; j < numPointsY; j++) {
        for (int i = 0; i < numPointsX-1; i++) {
            VStick *vStick = vSticksX[j][i];
            VPoint *point1 = [vStick getPointA];
            VPoint *point2 = [vStick getPointB];
            CGPoint point1_ = ccp(point1.x,point1.y);
            CGPoint point2_ = ccp(point2.x,point2.y);
            float stickAngle = ccpToAngle(ccpSub(point1_,point2_));
            CCSprite *tmpSprite = ropeSpritesX[j][i];
            [tmpSprite setPosition:ccpMidpoint(point1_,point2_)];
            [tmpSprite setRotation: -CC_RADIANS_TO_DEGREES(stickAngle)];
        }
    }}
@end
