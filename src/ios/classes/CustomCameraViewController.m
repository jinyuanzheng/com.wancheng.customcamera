//
//  CustomCameraViewController.m
//  CustomCamera
//
//  Created by Shane Carr on 1/3/14.
//
//

#import "ForegroundCameraLauncher.h"
#import "CustomCameraViewController.h"
#import "CameraEngine.h"

@implementation CustomCameraViewController

// Entry point method
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Instantiate the UIImagePickerController instance
		self.picker = [[UIImagePickerController alloc] init];
        
		// Configure the UIImagePickerController instance
		self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		self.picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
		self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
		self.picker.showsCameraControls = NO;
        self.picker.cameraViewTransform = CGAffineTransformIdentity;
        self.picker.videoQuality = UIImagePickerControllerQualityType640x480;
        self.picker.wantsFullScreenLayout = YES;
        
		// Make us the delegate for the UIImagePickerController
		self.picker.delegate = self;
        
		// Set the frames to be full screen
		CGRect screenFrame = [[UIScreen mainScreen] bounds];
		self.view.frame = screenFrame;
		self.picker.view.frame = screenFrame;
        
		// Set this VC's view as the overlay view for the UIImagePickerController
		self.picker.cameraOverlayView = self.view;
	}
	return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[CameraEngine engine] shutdown];
    
}

// Action method.  This is like an event callback in JavaScript.
-(IBAction) takePhotoButtonPressed:(id)sender forEvent:(UIEvent*)event {
	// Call the takePicture method on the UIImagePickerController to capture the image.
	[self.picker takePicture];
}

// Action method.  This is like an event callback in JavaScript.
-(IBAction) cancelButtonPressed:(id)sender forEvent:(UIEvent*)event {
	// Call the takePicture method on the UIImagePickerController to capture the image.
    [self.picker dismissModalViewControllerAnimated:YES];
	[self.plugin closeCamera];

}

// Action method.  This is like an event callback in JavaScript.
-(IBAction) gotoVideoRecordPressed:(id)sender forEvent:(UIEvent*)event {
	// Call the takePicture method on the UIImagePickerController to capture the image.
	[self.plugin gotoVideoRecord];
    
}

-(IBAction) getPhoto:(id) sender {
    self.picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
}

// Delegate method.  UIImagePickerController will call this method as soon as the image captured above is ready to be processed.  This is also like an event callback in JavaScript.
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

@end