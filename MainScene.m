#import "MainScene.h"
#import "VNet.h"

@interface MainScene()
@property(nonatomic,strong) VNet *net;
@property(nonatomic, assign) CGPoint currentPoint;
@end

@implementation MainScene

+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    // 'mainScene' is an autorelease object.
    MainScene *mainScene = [MainScene node];
    
    //this allows the touch to register on the whole screen :D
    mainScene.contentSize = [CCDirector sharedDirector].viewSize;
    
    // add layer as a child to scene
    [scene addChild: mainScene];
    
    // return the scene
    return scene;
}

-(id) init {
    
    if( (self=[super init]) ) {
        [self addChild:[CCNodeColor nodeWithColor:[CCColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]]];
        CGSize size = [CCDirector sharedDirector].viewSize;
        CGPoint A = ccp(size.width/5, size.height);
        CGPoint B = ccp(size.width*4/5, size.height);
        self.currentPoint = B;
        
        CCSpriteFrame * frame = [CCSpriteFrame frameWithImageNamed:@"rope.png"];
        
        self.net = [[VNet alloc] initWithPoints:A pointB:B spriteFrame:frame node: self width: ccpDistance(A, B) andHeight: ccpDistance(A, B)/2];
        
        self.userInteractionEnabled = YES;
        
        
    }
    
    return self;
    
}
-(void)update:(CCTime)delta {
    CGSize size = [CCDirector sharedDirector].viewSize;
    CGPoint A = ccp(size.width/5, size.height*2/3);
    [self.net updateWithPoints:A pointB:self.currentPoint dt:delta];
    [self.net updateSprites];
    //[self.rope debugDrawAtNode:self];
}

-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    self.currentPoint = [touch locationInNode:self];
}
-(void) touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    self.currentPoint = [touch locationInNode:self];
}


@end
