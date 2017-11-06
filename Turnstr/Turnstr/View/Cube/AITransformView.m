//
//  AITransformView.m
//  Layers
//
//  Created by test on 3/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AITransformView.h"
#import "UIImageView+WebCache.h"

@implementation AITransformView

@synthesize trackball;

#pragma mark -
#pragma mark Definitions

#define Border_Width 1.0;
#define Corner_Radius 2.0 //75.0;
//#define Layer_Size 250.0


#pragma mark -
#pragma mark Functions

CGFloat DegreesToRadians(CGFloat degrees)
{return degrees * M_PI / 180;}


#pragma mark -
#pragma mark Setup

- (id)initWithFrame:(CGRect)frame cube_size:(CGFloat)layerSize {
    if (self = [super initWithFrame:frame]) {
        //		self.multipleTouchEnabled = YES;
        Layer_Size = layerSize;
        [self createImageViews];
    }
    return self;
}

/*- (void)setupWithUrls:(NSString *)url, ...
 {
 @try {
 
 arrURLs = [[NSMutableArray alloc] init];
 [arrURLs addObject:url];
 va_list args;
 va_start(args, url);
 
 id arg = nil;
 while ((arg = va_arg(args,id))) {
 [arrURLs addObject:arg];
 }
 
 va_end(args);
 
 NSLog(@"%@", arrURLs);
 
 if (arrURLs.count == 0) {
 return;
 }
 
 if (arrURLs.count < 6) {
 int i = 0;
 do {
 [arrURLs addObject:arrURLs[i]];
 i++;
 } while (arrURLs.count<6);
 }
 
 NSLog(@"%@", arrURLs);
 
 [self setupLayers];
 
 
 } @catch (NSException *exception) {
 NSLog(@"Exception cube: %@", exception.description);
 } @finally {
 
 }
 
 }*/

- (void)setupWithUrls:(NSArray *)urls
{
    @try {
        
        arrURLs = [[NSMutableArray alloc] init];
        for (NSString  *strUrl in urls) {
            if (![strUrl isEqualToString:@""]) {
                [arrURLs addObject:strUrl];
            }
        }
        
        //arrURLs = [[NSMutableArray alloc] initWithArray:urls];
        
        if (arrURLs.count == 0) {
            [arrURLs addObject:@""];
            NSLog(@"There should be atleast one media url");
            //return;
        }
        
        if (arrURLs.count < 6) {
            int i = 0;
            do {
                [arrURLs addObject:arrURLs[i]];
                i++;
            } while (arrURLs.count<6);
        }
        
        NSLog(@"%@", arrURLs);
        
        [self setupLayers];
        
        
    } @catch (NSException *exception) {
        NSLog(@"Exception cube: %@", exception.description);
    } @finally {
        
    }
}

- (void)setupLayers {
    
    //Root Layer
    rootLayer = [CALayer layer];
    rootLayer.frame = self.bounds;
    [self.layer addSublayer:rootLayer];
    
    CGFloat layerSize = Layer_Size;
    CGRect layerRect = CGRectMake(0.0, 0.0, layerSize, layerSize);
    
    
    //Side One_Front_Blue
    CALayer *sideOne = [CALayer layer];
    
    [imgSide1 sd_setImageWithURL:[NSURL URLWithString:arrURLs[0]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error == nil && image != nil) {
            sideOne.contents = (__bridge id _Nullable)([image CGImage]);
        }
        else{
            sideOne.contents = (__bridge id _Nullable)([[UIImage imageNamed:@"thumb"] CGImage]);
        }
    }];
    
    
    //sideOne.contents = (__bridge id _Nullable)([imgSide1.image CGImage]); //(__bridge id _Nullable)([[UIImage imageNamed:@"img.png"] CGImage]);
    sideOne.borderWidth = Border_Width;
    sideOne.cornerRadius = Corner_Radius;
    sideOne.frame = layerRect;
    sideOne.position = self.center;
    
    
    //Side Two_Right_Green
    CALayer *sideTwo = [CALayer layer];
    [imgSide2 sd_setImageWithURL:[NSURL URLWithString:arrURLs[1]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error == nil && image != nil) {
            sideTwo.contents = (__bridge id _Nullable)([image CGImage]);
        }else{
            sideTwo.contents = (__bridge id _Nullable)([[UIImage imageNamed:@"thumb"] CGImage]);
        }
    }];
    //sideTwo.contents = (__bridge id _Nullable)([[UIImage imageNamed:@"img2.png"] CGImage]);
    sideTwo.borderWidth = Border_Width;
    sideTwo.cornerRadius = Corner_Radius;
    
    sideTwo.frame = layerRect;
    sideTwo.position = self.center;
    
    CGFloat degrees = 90.0;
    CGFloat radians = DegreesToRadians(degrees);
    CATransform3D rotation = CATransform3DMakeRotation(radians, 0.0, 1.0, 0.0);
    CATransform3D translation = CATransform3DMakeTranslation(Layer_Size/2, 0.0, Layer_Size/-2);
    CATransform3D position = CATransform3DConcat(rotation, translation);
    sideTwo.transform = position;
    
    
    //Side Three_Back_Red
    CALayer *sideThree = [CALayer layer];
    [imgSide3 sd_setImageWithURL:[NSURL URLWithString:arrURLs[3]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error == nil && image != nil) {
            sideThree.contents = (__bridge id _Nullable)([image CGImage]);
        }else{
            sideThree.contents = (__bridge id _Nullable)([[UIImage imageNamed:@"thumb"] CGImage]);
        }
    }];
    //sideThree.contents = (__bridge id _Nullable)([[UIImage imageNamed:@"img3.png"] CGImage]);
    sideThree.borderWidth = Border_Width;
    sideThree.cornerRadius = Corner_Radius;
    sideThree.frame = layerRect;
    sideThree.position = self.center;
    
    translation = CATransform3DMakeTranslation(0.0, 0.0, -Layer_Size);
    sideThree.transform = translation;
    
    
    //Side Four_Left_Yellow
    CALayer *sideFour = [CALayer layer];
    [imgSide4 sd_setImageWithURL:[NSURL URLWithString:arrURLs[3]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error == nil && image != nil) {
            sideFour.contents = (__bridge id _Nullable)([image CGImage]);
        }else{
            sideFour.contents = (__bridge id _Nullable)([[UIImage imageNamed:@"thumb"] CGImage]);
        }
    }];
    //sideFour.contents = (__bridge id _Nullable)([[UIImage imageNamed:@"img4.png"] CGImage]);
    sideFour.borderWidth = Border_Width;
    sideFour.cornerRadius = Corner_Radius;
    sideFour.frame = layerRect;
    sideFour.position = self.center;
    
    rotation = CATransform3DMakeRotation(radians, 0.0, 1.0, 0.0);
    translation = CATransform3DMakeTranslation(Layer_Size/-2, 0.0, Layer_Size/-2);
    sideFour.transform = CATransform3DConcat(rotation, translation);
				
    
    //Side Five_Top_Purple
    CALayer *sideFive = [CALayer layer];
    [imgSide5 sd_setImageWithURL:[NSURL URLWithString:arrURLs[4]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error == nil && image != nil) {
            sideFive.contents = (__bridge id _Nullable)([image CGImage]);
        }else{
            sideFive.contents = (__bridge id _Nullable)([[UIImage imageNamed:@"thumb"] CGImage]);
        }
    }];
    //sideFive.contents = (__bridge id _Nullable)([[UIImage imageNamed:@"img5.png"] CGImage]);
    sideFive.borderWidth = Border_Width;
    sideFive.cornerRadius = Corner_Radius;
    sideFive.frame = layerRect;
    sideFive.position = self.center;
    
    rotation = CATransform3DMakeRotation(radians, 1.0, .0, 0.0);
    translation = CATransform3DMakeTranslation(0.0, Layer_Size/-2, Layer_Size/-2);
    sideFive.transform = CATransform3DConcat(rotation, translation);
    
    
    //Side Six_Bottom_Orange
    CALayer *sideSix = [CALayer layer];
    [imgSide6 sd_setImageWithURL:[NSURL URLWithString:arrURLs[5]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error == nil && image != nil) {
            sideSix.contents = (__bridge id _Nullable)([image CGImage]);
        }else{
            sideSix.contents = (__bridge id _Nullable)([[UIImage imageNamed:@"thumb"] CGImage]);
        }
    }];
    //sideSix.contents = (__bridge id _Nullable)([[UIImage imageNamed:@"img6.png"] CGImage]);
    sideSix.borderWidth = Border_Width;
    sideSix.cornerRadius = Corner_Radius;
    sideSix.frame = layerRect;
    sideSix.position = self.center;
    
    rotation = CATransform3DMakeRotation(radians, 1.0, .0, 0.0);
    translation = CATransform3DMakeTranslation(0.0, Layer_Size/2, Layer_Size/-2);
    sideSix.transform = CATransform3DConcat(rotation, translation);
    
    
    //Transform Layer
    transformLayer = [CATransformLayer layer];
    
    [transformLayer addSublayer:sideOne];
    [transformLayer addSublayer:sideTwo];
    [transformLayer addSublayer:sideThree];
    [transformLayer addSublayer:sideFour];
    [transformLayer addSublayer:sideFive];
    [transformLayer addSublayer:sideSix];
    
    transformLayer.anchorPointZ = Layer_Size/-2;
    
    [rootLayer addSublayer:transformLayer];
    
}

-(void)createImageViews
{
    CGRect rect = CGRectMake(0, 0, Layer_Size, Layer_Size);
    imgSide1 = [[UIImageView alloc] initWithFrame:rect];
    
    //imgSide1.image = [UIImage imageNamed:@"img.png"];
    imgSide2 = [[UIImageView alloc] initWithFrame:rect];
    imgSide3 = [[UIImageView alloc] initWithFrame:rect];
    imgSide4 = [[UIImageView alloc] initWithFrame:rect];
    imgSide5 = [[UIImageView alloc] initWithFrame:rect];
    imgSide6 = [[UIImageView alloc] initWithFrame:rect];
}

#pragma mark -
#pragma mark Touch Handling

-(void)setScroll:(CGPoint)startPoint endPoint:(CGPoint)endPOint
{
    CGPoint location =  startPoint;
    if(nil == self.trackball) {
        self.trackball = [Trackball trackBallWithLocation:location inRect:self.bounds];
    } else {
        [self.trackball setStartPointFromLocation:location];
    }
    
    location = endPOint;
    CATransform3D transform = [trackball rotationTransformForLocation:location];
    rootLayer.sublayerTransform = transform;
    
    [self.trackball finalizeTrackBallForLocation:location];
}


//Trackball Version by Bill Dudney
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    
    NSLog(@"Begin:%f, %f", location.x, location.y);
    if(nil == self.trackball) {
        self.trackball = [Trackball trackBallWithLocation:location inRect:self.bounds];
    } else {
        [self.trackball setStartPointFromLocation:location];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    
    NSLog(@"%f, %f", location.x, location.y);
    
    CATransform3D transform = [trackball rotationTransformForLocation:location];
    rootLayer.sublayerTransform = transform;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    [self.trackball finalizeTrackBallForLocation:location];
}


/*
 -(void)setBeginingLocation
 {
 //return;
 
 [self SetYposition];
 
 CGFloat W = self.frame.size.width;
 CGFloat H = self.frame.size.height;
 NSLog(@"Acual: %f, %f, layer: %f", W, H, Layer_Size);
 //CGPoint location =  CGPointMake(self.center.x, 0);
 CGPoint location =  CGPointMake(self.center.x, 0);
 if(nil == self.trackball) {
 self.trackball = [Trackball trackBallWithLocation:location inRect:self.bounds];
 } else {
 [self.trackball setStartPointFromLocation:location];
 }
 
 //location = CGPointMake(self.center.x, 20);
 location = CGPointMake(self.center.x, Layer_Size * 10/100);
 CATransform3D transform = [trackball rotationTransformForLocation:location];
 rootLayer.sublayerTransform = transform;
 
 [self.trackball finalizeTrackBallForLocation:location];
 
 
 }
 
 -(void)SetYposition{
 
 CGFloat W = self.frame.size.width;
 CGFloat H = self.frame.size.height;
 NSLog(@"Acual: %f, %f, layer: %f", W, H, Layer_Size);
 
 //CGPoint location =  CGPointMake(0, self.center.y+90);
 CGPoint location =  CGPointMake(0, self.center.y+(Layer_Size*10/100));
 
 if(nil == self.trackball) {
 self.trackball = [Trackball trackBallWithLocation:location inRect:self.bounds];
 } else {
 [self.trackball setStartPointFromLocation:location];
 }
 
 //location = CGPointMake(80, location.y);
 location = CGPointMake((Layer_Size*10/100), location.y);
 CATransform3D transform = [trackball rotationTransformForLocation:location];
 rootLayer.sublayerTransform = transform;
 
 [self.trackball finalizeTrackBallForLocation:location];
 }*/


@end
