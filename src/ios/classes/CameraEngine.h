//
//  CameraEngine.h
//  Encoder Demo
//
//  Created by Geraint Davies on 19/02/2013.
//  Copyright (c) 2013 GDCL http://www.gdcl.co.uk/license.htm
//

#import <Foundation/Foundation.h>
#import "AVFoundation/AVCaptureSession.h"
#import "AVFoundation/AVCaptureOutput.h"
#import "AVFoundation/AVCaptureDevice.h"
#import "AVFoundation/AVCaptureInput.h"
#import "AVFoundation/AVCaptureVideoPreviewLayer.h"
#import "AVFoundation/AVMediaFormat.h"

@interface CameraEngine : NSObject

+ (CameraEngine*) engine;
- (void) startup;
- (void) shutdown;
- (AVCaptureVideoPreviewLayer*) getPreviewLayer;

- (void) startCapture;
- (void) pauseCapture;
- (NSString*) stopCapture;
- (void) resumeCapture;
- (NSString*) capturePhoto;
- (void) setOrientation:(AVCaptureVideoOrientation) orientation ;

@property (atomic, readwrite) BOOL isCapturing;
@property (atomic, readwrite) BOOL isPaused;
@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic) dispatch_queue_t sessionQueue; // Communicate with the session and other session objects on this queue.

@end
