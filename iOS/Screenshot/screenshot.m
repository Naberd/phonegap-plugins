//  Created by Simon Madine on 29/04/2010.
//  Copyright 2010 The Angry Robot Zombie Factory.
//   - Converted to Cordova 1.6.1 by Josemando Sobral.
//  MIT licensed
//
//  Modifications to support orientation change by @ffd8
//
//  Rewrited plugin to Cordova 3.0+
//  added save path and file name support
//

#import "Screenshot.h"


@implementation Screenshot;

@synthesize webView;


 - (void)saveScreenshot:(CDVInvokedUrlCommand*)command
//- (void)saveScreenshot:(NSArray*)arguments withDict:(NSDictionary*)options
{
	CGRect imageRect;
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	// statusBarOrientation is more reliable than UIDevice.orientation
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
	if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
		// landscape check
		imageRect = CGRectMake(0, 0, CGRectGetHeight(screenRect), CGRectGetWidth(screenRect));
	} else {
		// portrait check
		imageRect = CGRectMake(0, 0, CGRectGetWidth(screenRect), CGRectGetHeight(screenRect));
	}
    
	// Adds support for Retina Display. Code reverts back to original if iOs 4 not detected.
	if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, 0);
    else
        UIGraphicsBeginImageContext(imageRect.size);
    
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	[[UIColor blackColor] set];
	CGContextTranslateCTM(ctx, 0, 0);
	CGContextFillRect(ctx, imageRect);
    
	[webView.layer renderInContext:ctx];
	//get file path and file name from arguments
    NSString *basefile = [command.arguments objectAtIndex:0];
    //landing base dir documents
    NSString *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
    // apply path to file to default path
    pngPath = [pngPath stringByAppendingPathComponent: basefile];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	// writing image
    [UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
   
}

@end
