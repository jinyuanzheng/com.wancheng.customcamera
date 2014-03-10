//
//  CaptureVideoViewController.h
//  CustomCamera
//
//  Created by MiniMac2 on 2/23/14.
//
//

#import <UIKit/UIKit.h>

@class ForegroundCameraLauncher;

@interface CaptureVideoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL isRecording;
    NSTimer *mouseTimer;
    BOOL isFirstCapture;
    float recordTime;
}
    // Action method
-(IBAction) takePhotoButtonPressed:(id)sender forEvent:(UIEvent*)event;
-(IBAction) cancelButtonPressed:(id)sender forEvent:(UIEvent*)event;
- (void)startRecording;
- (void)pauseRecording;
- (void)stopRecording;
- (void)resumeRecording;
- (void) openCaptureVideo;
- (void) openCapturePhoto;
    
// Declare some properties (to be explained soon)
@property (strong, nonatomic) ForegroundCameraLauncher* plugin;
@property (strong, nonatomic) IBOutlet UIView *cameraView;    
@property (strong, nonatomic) NSString *videoPath;
    
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;

@property (strong, nonatomic) IBOutlet UIButton *btnAlbum;
@property (strong, nonatomic) IBOutlet UIButton *btnTakePhoto;
@property (strong, nonatomic) IBOutlet UIButton *btnRecordMode;

@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnRecord;
@property (strong, nonatomic) IBOutlet UIButton *btnPreview;

@property (strong, nonatomic) IBOutlet UIImageView *imgTopbar;
@property (strong, nonatomic) IBOutlet UIImageView *imgBottombar;

@end