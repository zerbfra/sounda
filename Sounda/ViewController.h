//
//  ViewController.h
//  Sounda
//
//  Created by Francesco Zerbinati on 13/03/15.
//  Copyright (c) 2015 Francesco Zerbinati. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AudioDeviceList.h"

@interface ViewController : NSViewController

// selector for the audio device
@property (weak) IBOutlet NSPopUpButton *audioDeviceSelector;

// the NSSound used to play sounds
@property (strong,nonatomic) NSSound *snd;

// dictionary of all sounds loaded
@property (strong,nonatomic) NSMutableDictionary *audioFiles;


// button that stop sounds
- (IBAction)stopSounds:(id)sender;

// when one of the "audio" button is pressed
- (IBAction)audioButtonPressed:(id)sender;

@end

