//
//  MicrophoneInput.m
//  Echoprint
//
//  Created by Brian Whitman on 1/23/11.
//  Copyright 2011 The Echo Nest. All rights reserved.
//

#import "MicrophoneInput.h"


@implementation MicrophoneInput

- (void)viewDidLoad
{
    [super viewDidLoad];
    recordEncoding = ENC_PCM;
}

-(IBAction) startRecording
{
	NSLog(@"startRecording");
	[audioRecorder release];
	audioRecorder = nil;
	
	// Init audio with record capability
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
	
	NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
	recordSettings[AVFormatIDKey] = @(kAudioFormatLinearPCM);
	recordSettings[AVSampleRateKey] = @44100.0f;
	recordSettings[AVNumberOfChannelsKey] = @2;
	recordSettings[AVLinearPCMBitDepthKey] = @16;
	recordSettings[AVLinearPCMIsBigEndianKey] = @NO;
	recordSettings[AVLinearPCMIsFloatKey] = @NO;
	
	//set the export session's outputURL to <Documents>/output.caf
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = paths[0];
	NSURL* outURL = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:@"output.caf"]];
	[[NSFileManager defaultManager] removeItemAtURL:outURL error:nil];
	NSLog(@"url loc is %@", outURL);
	
	NSError *error = nil;
	audioRecorder = [[ AVAudioRecorder alloc] initWithURL:outURL settings:recordSettings error:&error];
	
	if ([audioRecorder prepareToRecord] == YES){
        audioRecorder.meteringEnabled = YES;
		[audioRecorder record];
	}else {
		int errorCode = CFSwapInt32HostToBig ([error code]); 
		NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode); 
		
	}
	NSLog(@"recording");

    // Meter monitoring
    [audioRecorder updateMeters];
    
//    NSOperationQueue *queue             = [[NSOperationQueue alloc] init];
//    NSInvocationOperation *operation    = [[NSInvocationOperation alloc]
//                                           initWithTarget:self selector:@selector(updateMeter) object:nil];
//    [queue addOperation: operation];
}

-(IBAction) stopRecording
{
	NSLog(@"stopRecording");
	[audioRecorder stop];
	NSLog(@"stopped");
}

-(IBAction) playRecording
{
	NSLog(@"playRecording");
	// Init audio with playback capability
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
	
	NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/output.caf", [[NSBundle mainBundle] resourcePath]]];
	NSError *error;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlayer.numberOfLoops = 0;
	[audioPlayer play];
	NSLog(@"playing");
}

-(IBAction) stopPlaying
{
	NSLog(@"stopPlaying");
	[audioPlayer stop];
	NSLog(@"stopped");
}

- (void)dealloc
{
	[audioPlayer release];
	[audioRecorder release];
	[super dealloc];
}

- (void) playRiff:(NSString*)riff offset:(double)offset{
    NSLog(@"playRiff");
	// Init audio with playback capability
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
	
	NSURL *url = 
                 [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:riff ofType:@"mp3"]];
	NSError *error;
    [audioPlayer dealloc];
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlayer.numberOfLoops = 0;
    audioPlayer.currentTime = offset;
//    [audioPlayer setCurrentTime:o];
	[audioPlayer play];
	NSLog(@"playing");

}

-(void)updateMeter
{
    [audioRecorder updateMeters];
    _averagePower   = [audioRecorder averagePowerForChannel:0];
    _peakPower      = [audioRecorder peakPowerForChannel:0];

//    do {
//        //don't forget:
//        _averagePower   = [audioRecorder averagePowerForChannel:0];
//        _peakPower      = [audioRecorder peakPowerForChannel:0];
//        
//        //we don't to surprise a ViewController with a method call
//        //not in main thread
//        [NSThread sleepForTimeInterval:.05]; // 20 FPS
//    } while ([audioRecorder isRecording]);
}

- (void)meterLevelsDidUpdate
{
    
    
}


@end
