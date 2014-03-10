//
//  CaptureAudioViewController.m
//  CustomCamera
//
//  Created by MiniMac2 on 2/27/14.
//
//

#import "CaptureAudioViewController.h"
#import "ForegroundCameraLauncher.h"

@interface CaptureAudioViewController ()

@end

@implementation CaptureAudioViewController

@synthesize progressView;
@synthesize soundFilePath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        isRecording = false;
        isFirstCapture = true;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareRecording];
    progressView.progress = 0.0f;
    recordTime = 0.0f;
}

- (void) prepareRecording
{
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString] ;
    NSString* filename = [NSString stringWithFormat:@"sound%@.caf", guid];

    soundFilePath = [docsDir
                               stringByAppendingPathComponent:filename];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    
    audioRecorder = [[AVAudioRecorder alloc]
                     initWithURL:soundFileURL
                     settings:recordSettings
                     error:&error];
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
        
    } else {
        [audioRecorder prepareToRecord];
    }
}


- (void)mouseWasHeld: (NSTimer *)tim {
    recordTime += 0.5;
    progressView.progress = recordTime / 45;
    // etc.
}
// Action method.  This is like an event callback in JavaScript.
-(IBAction) capturePressed:(id)sender forEvent:(UIEvent*)event {
    if(isFirstCapture)
    {
        isFirstCapture = !isFirstCapture;
        [self startRecording];
    } else {
        [self resumeRecording];
    }
    mouseTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                  target:self
                                                selector:@selector(mouseWasHeld:)
                                                userInfo:nil
                                                 repeats:YES];
    
}

- (IBAction)mouseUp:(id)sender forEvent:(UIEvent *)theEvent {
    [self pauseRecording];
    [mouseTimer invalidate];
    mouseTimer = nil;
}

- (void)startRecording {
    if (!audioRecorder.recording)
    {
        [audioRecorder record];
    }
}

- (void)pauseRecording
{
    if (audioRecorder.recording)
    {
        [audioRecorder pause];
    }
}

- (void)stopRecording
{
    if (audioRecorder.recording)
    {
        [audioRecorder stop];
    } else if (audioPlayer.playing) {
        [audioPlayer stop];
    }
    
    [self.plugin gotoPreview:soundFilePath];
}

- (void)resumeRecording
{
    if (!audioRecorder.recording)
    {
        [audioRecorder record];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}


// Action method.  This is like an event callback in JavaScript.
-(IBAction) cancelPressed:(id)sender forEvent:(UIEvent*)event {
	// Call the takePicture method on the UIImagePickerController to capture the image.
    if (audioRecorder.recording)
    {
        [audioRecorder stop];
    } else if (audioPlayer.playing) {
        [audioPlayer stop];
    }
    
	[self.plugin closeCamera];
    
}

// Action method.  This is like an event callback in JavaScript.
-(IBAction) previewPressed:(id)sender forEvent:(UIEvent*)event {
    if(recordTime < 10)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Record at least 10 seconds"
                                                        message:@""
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
	// Call the takePicture method on the UIImagePickerController to capture the image.
    [self stopRecording];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
