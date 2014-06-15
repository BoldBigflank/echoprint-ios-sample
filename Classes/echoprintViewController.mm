//
//  echoprintViewController.m
//  echoprint
//
//  Created by Brian Whitman on 6/13/11.
//  Copyright 2011 The Echo Nest. All rights reserved.
//

#import "echoprintViewController.h"
#import "ASIHTTPRequest.h"

@implementation echoprintViewController

- (IBAction)pickSong:(id)sender {
	NSLog(@"Pick song");
	MPMediaPickerController* mediaPicker = [[[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic] autorelease];
	mediaPicker.delegate = self;
	[self presentViewController:mediaPicker animated:YES completion:nil];
	
}
- (IBAction) startMicrophone:(id)sender {
	if(recording) {
		recording = NO;
		[recorder stopRecording];
		[recordButton setTitle:@"Record" forState:UIControlStateNormal];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = paths[0];
		NSString *filePath =[documentsDirectory stringByAppendingPathComponent:@"output.caf"];
		[statusLine setText:@"Communicating With Server"];
		[statusLine setNeedsDisplay];
		[self.view setNeedsDisplay];
        NSString* fpCode = [FPGenerator generateFingerprintForFile:filePath];
        [self getSong:fpCode];
        [self stopAudioMetering];
	} else {
		[statusLine setText:@"Listening..."];
		recording = YES;
		[recordButton setTitle:@"Done Listening" forState:UIControlStateNormal];
		[recorder startRecording];
        startRecordingTimestamp = [[NSDate date] timeIntervalSince1970];
		[statusLine setNeedsDisplay];
		[self.view setNeedsDisplay];
        [meter setText:[NSString stringWithFormat:@"Current DB: %f", recorder.averagePower]];
        
        [self startAudioMetering];
        
	}

}

- (void)startAudioMetering
{
    self.meterTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                       target:self
                                                     selector:@selector(updateAudioMeter)
                                                     userInfo:nil
                                                      repeats:YES];
}

- (void)updateAudioMeter //called by timer
{
    // audioRecorder being your instance of AVAudioRecorder
    [recorder updateMeter];
    [meter setText:[NSString stringWithFormat:@"Current DB: %f", recorder.peakPower]];

    [meter setNeedsDisplay];
    [self.view setNeedsDisplay];
}

- (void)stopAudioMetering
{
    [self.meterTimer invalidate];
}


- (void)mediaPicker:(MPMediaPickerController *)mediaPicker 
  didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
	[self dismissViewControllerAnimated:YES completion:nil];
	for (MPMediaItem* item in mediaItemCollection.items) {
		NSString* title = [item valueForProperty:MPMediaItemPropertyTitle];
		NSURL* assetURL = [item valueForProperty:MPMediaItemPropertyAssetURL];
		NSLog(@"title: %@, url: %@", title, assetURL);
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = paths[0];

		NSURL* destinationURL = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:@"temp_data"]];
		[[NSFileManager defaultManager] removeItemAtURL:destinationURL error:nil];
		TSLibraryImport* import = [[TSLibraryImport alloc] init];
		[import importAsset:assetURL toURL:destinationURL completionBlock:^(TSLibraryImport* import) {
			//check the status and error properties of
			//TSLibraryImport
			NSString *outPath = [documentsDirectory stringByAppendingPathComponent:@"temp_data"];
			NSLog(@"done now. %@", outPath);
			[statusLine setText:@"analysing..."];
			
            NSString* fpCode = [FPGenerator generateFingerprintForFile:outPath];
            
			[statusLine setNeedsDisplay];
			[self.view setNeedsDisplay];
			[self getSong:fpCode];
		}];
		
	}
}


- (void) getSong: (NSString*) fpCode {
	NSLog(@"Done %@", fpCode);

    // Debug code, transformers start 0:52-1:22
//    fpCode = @"eJy1mVFuZSkMRLcExjawHDCw_yXMoT_mzUQK-YhaLZW6b97jgl2uKtIppVzTA8p5geUX1PmC8YS1HpAlXmDrBcMfIHU_oKT1gtpfMOIFaz9A1R_A1l_wQ3_7C5q_YMoDctIX9POAu8YD2hN6ecGqDyh3_e9B7QV1vODZfb0LfA9jPOBX3df2gvf8PrufTjwg9ydEf8AP3Jj5Be_uZ3lBsRc857ec-gC9Yvk9-HjAT91vL7gb_x56e8EPs19eUPwFfbzgus63IDpf8NR2mfUBJfsLRn_Bmi84_gBVfYHtB_zOF97cGC-Y9oBcntDzC_Z5gJi-4C7wPfyq--MFqz1AbT7gpw6uF_xquvUBP81vesHeDxBNL3j3t50H_NDBsl_Q5gtWf8DvJjRe8Kv-lgf8MKEeL3jOr9xLw_dg5QVv9X52_29O96v7f3F-b6j8Hn7o_t_SZ8njBT908Am_6eB7Qh_Z22Se8H2m39Rak4VEP-q1x9Dm7dg5crTmFU3m_VM1fImJ7BTevY2lk7fEMTmW3COvPXPZzUTDWlguqae2otqIGH2WsmLM3SK3vFyr7qp5txPSRlOXveYpkptxqcybbezuNmb0MY_M5LWapRkNcvKCY-HuJd_Fj-ryQWyoXVK0Xc4YrfnpU44Lm6-mzaxLy7zZa6rNpY5c2GuknVox0upZkQYvYAvNrbPTY5WNzt7rGkWGkKU5JjfELRS4DGvDGxLNprrI2ElnaWO7HS7krRQW97151yona50e29WaVS1zjt2GVF199JjTfC6bsjU-MHKN-PLsA7ql06-cFmvxxuF6-qKCc59ss7PTMcxHbhFRtm06sUadjRdWzr1vyU7qfY5SDtMzVWuVskNFdWxJI4rV2mqFB_Sk-Sg7R8m7Fik2bFs7I9koudqZ7TTJM0Wn2QKpjC_KGlC8Wt6quYjFMB1WjA1Ub2tukXPT4Mjz5DU6S2WIU32NWGlQtNzbDrwo8jl5UqQqukftQztHpA52Vhmb7a26tmim0dlbjjZtHIiRrcOVMk83WNIlVrDjIr5iNwnhi-ny2HcrudehI9U6FvxbptBmHz2LwppyKEaOjkdVWnyYl2ONarvnMpNt9TxgZx3UWVabUeP0TDVSPz0Wvem7k43KMpstoMeGcKotV1SETuqcH-h8MH959gGXFlovYUMtFClxlXq2RHAc0eM01UpYKXWdtmtqeSznLpE1WR1dGA-dKuvsg5FoCHucw3txhiv1KrMxCBBTpNXZd1kFArQOJ32lljaDPzMtgOoxyfssyBtWhgmnesoUJZgpmuUulHhR9N4b7TuK5uyhq6zbT0tt5iYbmq4WLdgi12H0gnG5ucwoj81sHCaz7KqGEAWKNGFM7ta30EP1g0GcNUZxzbmVKYPOQT_xLJ32FmVnCWUzQVjOznMb1KQlW6hCaspBNE2I7rEy1i3S2X1XSneExjp9D9jaka_eYDrsyaiOC2vXesU1-2ZmJgO0tXTztForHDLddhYeNbk6a36kXXWAr7Oz5oIw5wPtNvXLsw8UnUxPKB-zoqyueRUEhHXRs54VIfbFyGWv8BNpWFMpgGtw9eLTx-cuSEjLfaYmlZvRYopLSXVCm1Vy5Nr7omrO7ZSW0xYxG_dsO1HvQe-En8KKhJLwLQT2OFbpG91hSwiwsPZqyIyboOf4e9F0y2CMst1q9sXnKgcR_oZQMnAcgWOWnqWujizrvD9fpVVI3RrkpnDobFGPVjram42xn0NNtjMaGDbaTHCep2YIXmFc74PbUK971mE4ymU15UinFwweImDUmQ2imFRsHkRZGC_2NGfQ3By1NKQ8jx2dhDtKnVwJmVpc6monHN2oY0ulNgwSybxm5qXfX5Eq5VyHcaiHLLmkVBdvm5GogXzBakSEBkHwjcdsJApBQV0ZxM1Kg1p-wIuil_9_9p-fprUpyri_GJioAWOBbSsCirizT-yi0UaEP6FYKghBwF9Y0ZGBjbWjPK5OE5OmMTMBh3Unhowo4Kys4jRITmVcrrSyvxOBKOmt7mZwD9Y-uo-aRJKih4oPcMwdFS8uXROWzzAg_9ey7--CMsQ6fQ_qcv20pNbGGaXXhp96w9nSREa78jK-dAaKQCENxcEPoA2LQlKfmCqLt5YFV6G43NurLe13PgXxOMuTZwIDLZkMpzvpY0NmH0aUqAxKwGCaHrwBEdl-ZRo_Qizj8C-CkDN5UK7OXRcxakED9HhN45ZhVxAq6Qc_1BVC-ViO8fkPzEETvjz7FzzdGxTKGIE2MGIHHRUM8Jw7EJgUQSTIH91W9H1Cb4DtWNYdWEIT4pMpFG1Ol2nZ8PnogsUaVokdZMhQsbIJ8bmvjWYrc8DaN8ELdSu93wQUNd-EVlEyfiiMD9XArI6OWZgPLBKSkAaws4QB7GAsx2H0UFRveA7p4U5lXIvZ-wYz9CA88wDJhWM-UlemgGI6ieFuHg5gE5gFznBILh7S2emtJ9GiLVvXbNIpBEJqjqzTzsYw2n0nw7bR64CxENMJXL5trsw02tX-QmSAzwO6xdJTyDhEok1KUoLHHTWiCEPN8OxCGkAn0C9S0Zm5RyZLYQa1HMjesGz0iGTns9nZH8Cy4uuzD2RSGWe6VkGyoUF0lKiCOfZTEs-IZKG84jolUYSBJM0jVKRn4tNASvFAMc7GzsfGy25TmWy_I8b-08bXaK2gWIwcvCDvEp_2iLEXcQTpxs-OZRQ6kABPhc-UgSkRHtMfBmAkpEHvREGUskP4vSACQR6TvmkZIwhSHTWuBuMD3nEEjnZvJ8wgparleg-lZ5mMOmQ2itYuZC5nKVw0uIPgVZMph5N8AmnBd2-cOzdzbVbCIZDjXTG3hvUws-0KZIb3Fbv2ew-41wQseXFMMsUy1oZfiTTCzCN_HcoO1GCg3Pd_Yg4Szjtld9IQbkYohd6EwhtEO3Xv92aRFpq6d9xbQPEPcD7s6__PPkC77iyhXaRlmkjgn4QQqEzuX1d8tt7LlxOI8SYmbWDLXArahMRkYzrUBBFNCMAd9zTufYvoSoyhn6S-s3IhnNNpuoJQIIF0FF9bODoSQPT-89sUSShERrgYSa4NjWAYxDjlhJN-QDrxssliRDycPLiZlUFon0SAZPCFW0gn3qawzWKdXeBL95ZEgfDYoBnLMqOW6817YUJ3jHsjDbgZcc9Ourjpj5tYJXIXigmJNtdX_NIydwrSRB3jJhBeUrinUPpJqMwmOZ2hhcHGJNSZcbT3ejF3ShqMoXLzTDcOsBu0ZfTLfLRPoMIq0Vkkk2pHOXGvfx9YlYvel2cf-AcUL3dC";
    //    NSString *apiString = [NSString stringWithFormat:@"http://%@/api/v4/song/identify?api_key=%@&version=4.11&code=%@&format=json", API_HOST, API_KEY, fpCode];
    NSString *apiString = [NSString stringWithFormat:@"http://%@/query?api_key=%@&version=4.12&code=%@&format=json", API_HOST, API_KEY, fpCode];
    
    NSURL *url = [NSURL URLWithString:apiString];
	
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:url];
	[request setAllowCompressedResponse:NO];
	[request startSynchronous];
	NSError *error = [request error];
	if (!error) {
		NSString *response = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
//		NSLog(@"%@", dictionary);
        
		if([[dictionary objectForKey:@"success"] boolValue]) {
            NSDictionary *match = dictionary[@"match"];
			NSString * song_title = match[@"track"];
			NSString * artist_name = match[@"artist"];
            double timeDiff = [match[@"timeDiff"] doubleValue];
            double riff_offset = [match[@"riff_offset"] doubleValue];
            
            NSTimeInterval recordingTime = [[NSDate date] timeIntervalSince1970] - startRecordingTimestamp;
//			[statusLine setText:[NSString stringWithFormat:@"%@ - %@", song_title, [NSString stringWithFormat:@"%f", timeDiff ]]];
            [ statusLine setText:[ NSString stringWithFormat:@"Now Riffing: %@", artist_name ] ];
            [recorder playRiff:song_title offset:timeDiff+riff_offset+recordingTime];
            
		} else {
			[statusLine setText:@"Couldn't Find a Match"];
		}
	} else {
		[statusLine setText:@"Error Communicating With Server"];
		NSLog(@"error: %@", error);
	}
	[statusLine setNeedsDisplay];
	[self.view setNeedsDisplay];
}




- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
	[self dismissViewControllerAnimated:YES completion:nil];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	recorder = [[MicrophoneInput alloc] init];
	recording = NO;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
