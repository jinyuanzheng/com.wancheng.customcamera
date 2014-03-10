//
//  CaptureVideoViewController.m
//  CustomCamera
//
//  Created by MiniMac2 on 2/23/14.
//
//

#import "CaptureVideoViewController.h"
#import "ForegroundCameraLauncher.h"
#import "CameraEngine.h"

@interface CaptureVideoViewController ()

@end

@implementation CaptureVideoViewController

@synthesize progressView;
@synthesize btnAlbum;
@synthesize btnCancel;
@synthesize btnPreview;
@synthesize btnRecord;
@synthesize btnTakePhoto;
@synthesize btnRecordMode;
@synthesize imgTopbar;
@synthesize imgBottombar;
    
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
 //    [[CameraEngine engine] setOrientation:(AVCaptureVideoOrientation) UIInterfaceOrientationPortrait];
    progressView.progress = 0.0f;
    recordTime = 0.0f;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self startPreview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
//    [[CameraEngine engine] setOrientation:(AVCaptureVideoOrientation)[self interfaceOrientation]];
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void) startPreview
{
    [[CameraEngine engine] startup];

    AVCaptureVideoPreviewLayer* preview = [[CameraEngine engine] getPreviewLayer];
    [preview removeFromSuperlayer];
    CGRect viewRect = CGRectMake(0, 0 , self.view.frame.size.width, self.view.frame.size.width);
    preview.frame = viewRect;
    [self.cameraView setFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width)];
    
    
    [self.cameraView.layer addSublayer:preview];
}
    
- (void)mouseWasHeld: (NSTimer *)tim {
    recordTime += 0.5;
    progressView.progress = recordTime / 45;
    // etc.
}

-(IBAction) capturePhotoButtonPressed:(id)sender forEvent:(UIEvent*)event {
    _videoPath = [[CameraEngine engine] capturePhoto];
    [self.plugin gotoPreview:_videoPath];
}

-(IBAction) getPhoto:(id) sender {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Get a reference to the captured image
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Get a file path to save the JPEG
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString] ;
    NSString *filename = [NSString stringWithFormat:@"test_%@.jpg", guid];
    
    //NSString* filename = @"test.jpg";
    NSString* imagePath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    // Get the image data (blocking; around 1 second)
    NSData* imageData = UIImageJPEGRepresentation(image, 0.5);
    
    // Write the data to the file
    [imageData writeToFile:imagePath atomically:YES];
    
    // Tell the plugin class that we're finished processing the image
    [self.plugin capturedImageWithPath:imagePath];
}

- (void) openCapturePhoto
{
    btnTakePhoto.hidden = NO;
    btnRecordMode.hidden = NO;
    btnAlbum.hidden = NO;
    btnRecord.hidden = YES;
    btnPreview.hidden = YES;
    btnCancel.hidden = YES;
}

- (void) openCaptureVideo
{
    btnTakePhoto.hidden = YES;
    btnRecordMode.hidden = YES;
    btnAlbum.hidden = YES;
    btnRecord.hidden = NO;
    btnPreview.hidden = NO;
    btnCancel.hidden = NO;
}
    // Action method.  This is like an event callback in JavaScript.
-(IBAction) takePhotoButtonPressed:(id)sender forEvent:(UIEvent*)event {
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


// Action method.  This is like an event callback in JavaScript.
-(IBAction) gotoVideoRecordPressed:(id)sender forEvent:(UIEvent*)event {
	// Call the takePicture method on the UIImagePickerController to capture the image.
	[self.plugin gotoVideoRecord];
    
}

- (IBAction)mouseUp:(id)sender forEvent:(UIEvent *)theEvent {
    [self pauseRecording];
    [mouseTimer invalidate];
    mouseTimer = nil;
}
    
- (void)startRecording {
    [[CameraEngine engine] startCapture];
}

- (void)pauseRecording
{
    [[CameraEngine engine] pauseCapture];
}
    
- (void)stopRecording
{
    self.videoPath = [[CameraEngine engine] stopCapture];

    [self.plugin gotoPreview:_videoPath];

}
    
- (void)resumeRecording
{
    [[CameraEngine engine] resumeCapture];
}
    
    // Action method.  This is like an event callback in JavaScript.
-(IBAction) cancelButtonPressed:(id)sender forEvent:(UIEvent*)event {
	// Call the takePicture method on the UIImagePickerController to capture the image.
    self.videoPath = [[CameraEngine engine] stopCapture];
	[self.plugin closeCamera];
    
}
    
    // Action method.  This is like an event callback in JavaScript.
-(IBAction) previewButtonPressed:(id)sender forEvent:(UIEvent*)event {
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
