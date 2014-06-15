//
//  echoprintViewController.h
//  echoprint
//
//  Created by Brian Whitman on 6/13/11.
//  Copyright 2011 The Echo Nest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>  
#import "TSLibraryImport.h"
#import "MicrophoneInput.h"

#import "FPGenerator.h"


// developer.echonest.com
#define API_KEY @"L2NIBHIT9UWJT8TTQ"
//#define API_HOST @"developer.echonest.com"
#define API_HOST @"boiling-reef-2937.herokuapp.com"
//#define API_HOST @"192.168.1.129:37760"

@interface echoprintViewController : UIViewController <MPMediaPickerControllerDelegate> {
	BOOL recording;
    NSTimeInterval startRecordingTimestamp;
	IBOutlet UIButton* recordButton;
	IBOutlet UILabel* statusLine;
	MicrophoneInput* recorder;
    IBOutlet UILabel* meter;

}

- (IBAction)pickSong:(id)sender;
- (IBAction)startMicrophone:(id)sender;
- (void) getSong: (NSString*) fpCode;

@property(assign) NSTimer* meterTimer;

@end

