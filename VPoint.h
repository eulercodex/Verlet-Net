//
//  VPoint.h
//
//  Created by patrick on 14/10/2010.
//  Modified by Jesse on 03/02/2015.

#import <Foundation/Foundation.h>

@interface VPoint : NSObject {
	float x,y,oldx,oldy;
}

@property(nonatomic,assign) float x;
@property(nonatomic,assign) float y;

-(void)setPos:(float)argX y:(float)argY;
-(void)update:(float)dt;
-(void)applyGravity:(float)dt;

@end
