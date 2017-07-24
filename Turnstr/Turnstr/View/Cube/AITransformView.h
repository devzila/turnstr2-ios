//
//  AITransformView.h
//  Layers
//
//  Created by test on 3/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Trackball.h"

@interface AITransformView : UIView {
    
    CALayer						*rootLayer;
    CATransformLayer		*transformLayer;
    Trackball						*trackball;
    
    CGFloat Layer_Size;
    
    UIImageView *imgSide1, *imgSide2, *imgSide3, *imgSide4, *imgSide5, *imgSide6;
    NSMutableArray *arrURLs;
    
}

- (id)initWithFrame:(CGRect)frame cube_size:(CGFloat)layerSize;
//- (void)setupWithUrls:(NSString *)url, ...;
- (void)setupWithUrls:(NSArray *)urls;

-(void)setScroll:(CGPoint)startPoint endPoint:(CGPoint)endPOint;

@property(nonatomic, retain) Trackball *trackball;

//- (void)setupLayers;

@end
