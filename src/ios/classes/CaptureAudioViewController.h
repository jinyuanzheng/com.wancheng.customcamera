//
//  CaptureAudioViewController.h
//  CustomCamera
//
//  Created by MiniMac2 on 2/27/14.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class ForegroundCameraLauncher;

@interface CaptureAudioViewController : UIViewController
{
    BOOL isRecording;
    NSTimer *mouseTimer;
    BOOL isFirstCapture;
    float recordTime;
    
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;

}
// Action method
-(IBAction) capturePressed:(id)sender forEvent:(UIEvent*)event;
-(IBAction) cancelPressed:(id)sender forEvent:(UIEvent*)event;
- (void)startRecording;
- (void)pauseRecording;
- (void)stopRecording;
- (void)resumeRecording;

// Declare some properties (to be explained soon)
@property (strong, nonatomic) ForegroundCameraLauncher* plugin;
@property (strong, nonatomic) NSString *soundFilePath;

@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@end