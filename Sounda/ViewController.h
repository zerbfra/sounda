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

@property (weak) IBOutlet NSPopUpButton *audioDeviceSelector;

@property (strong,nonatomic) NSSound *snd;

@property (strong,nonatomic) NSMutableDictionary *audioFiles;



- (IBAction)stopSounds:(id)sender;
- (IBAction)audioButtonPressed:(id)sender;

@end

