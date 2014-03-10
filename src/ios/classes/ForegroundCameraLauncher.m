//
//  CustomCamera.m
//  CustomCamera
//
//  Created by Shane Carr on 1/3/14.
//
//

#import "ForegroundCameraLauncher.h"

#import "CameraEngine.h"


@implementation ForegroundCameraLauncher

// Cordova command method
-(void) takePicture:(CDVInvokedUrlCommand *)command {
    
    // Set the hasPendingOperation field to prevent the webview from crashing
    self.hasPendingOperation = YES;
    
    // Save the CDVInvokedUrlCommand as a property.  We will need it later.
    self.latestCommand = command;
    
    // Make the overlay view controller.
    self.overlay = [[CaptureVideoViewController alloc] initWithNibName:@"CaptureVideoViewController" bundle:nil];
    ((CaptureVideoViewController*)self.overlay).plugin = self;
    
    // Display the view.  This will "slide up" a modal view from the bottom of the screen.
    [self.viewController presentViewController:((CaptureVideoViewController*)self.overlay) animated:YES completion:nil];
    [((CaptureVideoViewController*)self.overlay) openCapturePhoto];
    
}

-(void) takeVideo:(CDVInvokedUrlCommand *)command {
        
    // Set the hasPendingOperation field to prevent the webview from crashing
    self.hasPendingOperation = YES;
        
    // Save the CDVInvokedUrlCommand as a property.  We will need it later.
    self.latestCommand = command;
        
    // Make the overlay view controller.
    self.overlay = [[CaptureVideoViewController alloc] initWithNibName:@"CaptureVideoViewController" bundle:nil];
    ((CaptureVideoViewController*)self.overlay).plugin = self;
    
    // Display the view.  This will "slide up" a modal view from the bottom of the screen.
    [self.viewController presentViewController:((CaptureVideoViewController*)self.overlay) animated:YES completion:nil];
    [((CaptureVideoViewController*)self.overlay) openCaptureVideo];
    
}

-(void) takeAudio:(CDVInvokedUrlCommand *)command {
    
    // Set the hasPendingOperation field to prevent the webview from crashing
    self.hasPendingOperation = YES;
    
    // Save the CDVInvokedUrlCommand as a property.  We will need it later.
    self.latestCommand = command;
    
    // Make the overlay view controller.
    self.overlay = [[CaptureAudioViewController alloc] initWithNibName:@"CaptureAudioViewController" bundle:nil];
    ((CaptureAudioViewController*)self.overlay).plugin = self;
    
    // Display the view.  This will "slide up" a modal view from the bottom of the screen.
    [self.viewController presentViewController:((CaptureAudioViewController*)self.overlay) animated:YES completion:nil];
}

-(void) closeCamera
{
	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"closeCamera"] callbackId:self.latestCommand.callbackId];
    
	// Unset the self.hasPendingOperation property
	self.hasPendingOperation = NO;

    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) gotoVideoRecord
{
    [((CaptureVideoViewController*)self.overlay) openCaptureVideo];
}

-(void) gotoPreview:(NSString*)videoPath
{
    NSLog(videoPath);
    [[CameraEngine engine] shutdown];
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:videoPath] callbackId:self.latestCommand.callbackId];
        
        // Unset the self.hasPendingOperation property
    self.hasPendingOperation = NO;
        
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}
    
// Method called by the overlay when the image is ready to be sent back to the web view
-(void) capturedImageWithPath:(NSString*)imagePath {
	[self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:imagePath] callbackId:self.latestCommand.callbackId];
    
	// Unset the self.hasPendingOperation property
	self.hasPendingOperation = NO;
    
    // Hide the picker view
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

@end