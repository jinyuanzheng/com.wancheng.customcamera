//
//  CustomCamera.h
//  CustomCamera
//
//  Created by Shane Carr on 1/3/14.
//
//

#import <Cordova/CDV.h>

#import "CustomCameraViewController.h"
#import "CaptureVideoViewController.h"
#import "CaptureAudioViewController.h"

@interface ForegroundCameraLauncher : CDVPlugin

// Cordova command method
-(void) takePicture:(CDVInvokedUrlCommand*)command;

// Create and override some properties and methods (these will be explained later)
-(void) capturedImageWithPath:(NSString*)imagePath;
    
-(void) closeCamera;
-(void) gotoVideoRecord;
-(void) gotoPreview:(NSString*)videoPath;
    
@property (strong, nonatomic) id overlay;
@property (strong, nonatomic) CDVInvokedUrlCommand* latestCommand;
@property (readwrite, assign) BOOL hasPendingOperation;

@end