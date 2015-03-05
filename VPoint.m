//
//  VPoint.m
//
//  Created by patrick on 14/10/2010.
//  Modified by Jesse on 03/02/2015.

#import "VPoint.h"


@implementation VPoint

@synthesize x;
@synthesize y;

-(void)setPos:(float)argX y:(float)argY {
	x = oldx = argX;
	y = oldy = argY;
}

-(void)update:(float)dt {
/* 
 Verlet integration derived from Taylor theorem at t
 (1) x(t+dt) = x(t) + x'(t)*dt + x"(t)/2!*dt^2 + x"(t)/3!*dt^3 + ...
 (2) x(t-dt) = x(t) - x'(t)*dt + x"(t)/2!*dt^2 - x"(t)/3!*dt^3 + ...
 And by adding (1) and (2), we have
 x(t+dt) + x(t-dt) = 2*x(t) + 2*x"(t)/2!*dt^2 + O(dt^4)
 and then by rearranging, we have
 x(t+dt) = 2*x(t) + x(t-dt) + x"(t)*dt^2 + O(dt^4)
*/
    
	float tempx = x;
	float tempy = y;
	x += x - oldx;
	y += y - oldy;
	oldx = tempx;
	oldy = tempy;
}

-(void)applyGravity:(float)dt {
	y -= 300.0f*dt*dt; //gravity magic number
}

-(void)setX:(float)argX {
	x = argX;
}

-(void)setY:(float)argY {
	y = argY;
}

-(float)getX {
	return x;
}

-(float)getY {
	return y;
}

@end
