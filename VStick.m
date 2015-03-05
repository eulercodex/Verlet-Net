//
//  VStick.m
//
//  Created by patrick on 14/10/2010.
//  Modified by Jesse on 03/02/2015.

#import "VStick.h"
#import	 "cocos2d.h"

@implementation VStick
-(id)initWith:(VPoint*)argA pointb:(VPoint*)argB {
	if((self = [super init])) {
		pointA = argA;
		pointB = argB;
		hypotenuse = ccpDistance(ccp(pointA.x,pointA.y),ccp(pointB.x,pointB.y));
	}
	return self;
}

-(void)contract {
	float dx = pointB.x - pointA.x;
	float dy = pointB.y - pointA.y;
	float h = ccpDistance(ccp(pointA.x,pointA.y),ccp(pointB.x,pointB.y));
	float diff = hypotenuse - h;
    if (true) {
        float offx = (diff * dx / h) * 0.8;
        float offy = (diff * dy / h) * 0.8;
        pointA.x-=offx;
        pointA.y-=offy;
        pointB.x+=offx;
        pointB.y+=offy;
    }
	
}
-(VPoint*)getPointA {
	return pointA;
}
-(VPoint*)getPointB {
	return pointB;
}
@end
