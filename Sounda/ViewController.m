//
//  ViewController.m
//  Sounda
//
//  Created by Francesco Zerbinati on 13/03/15.
//  Copyright (c) 2015 Francesco Zerbinati. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // initialize the dictionary for audio files
    self.audioFiles = [NSMutableDictionary dictionary];
    
    [[AudioDeviceList shared] buildAudioDevicesList:self.audioDeviceSelector];
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}


/* Given a sound, play it on the selected device */
-(void) playSoundUrl:(NSURL*) url {
    
    // if already playing, stop it
    [self stopSounds:nil];
    
    // allocate the sound
    self.snd = [[NSSound alloc] initWithContentsOfURL:url byReference:NO];
    
    
    NSArray *data = [[[self audioDeviceSelector] selectedItem] representedObject];
    
    // send the sound to the selected device
    [self.snd setPlaybackDeviceIdentifier:[data objectAtIndex:0]];
    
    NSLog(@"channels mapped to device: %@", [self.snd playbackDeviceIdentifier]);
    
    // play it!
    [self.snd play];
    
}

/* Open a dialog to select the file to play */
- (NSURL*)getAudioFileFromDialog {
    
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];

    [oPanel setAllowsMultipleSelection:NO];
    [oPanel setDirectoryURL:[NSURL URLWithString:NSHomeDirectory()]];
    
    // only sound files
    NSMutableArray *fileTypes = [NSMutableArray arrayWithArray:[NSSound soundUnfilteredTypes]];
    oPanel.allowedFileTypes = fileTypes;
    
    // run
    [oPanel runModal];
    
    // the new file
    NSURL *selectedFile = [[oPanel URLs] objectAtIndex:0];
    
    // the new selected file is returned
    NSLog(@"Sound file is now: %@", selectedFile);
    
    return selectedFile;
}


- (IBAction)stopSounds:(id)sender {
    // check if playing, stop if necessary
    if([self.snd isPlaying]) {
        [self.snd stop];
    }
}

- (IBAction)audioButtonPressed:(id)sender {
    
    // get the sender (button)
    NSButton *button = (NSButton*) sender;
    
    // if a file is NOT loaded "on the button"
    if([self.audioFiles objectForKey:(NSString*)button.identifier] == nil) {
        
        // retrieve the file
        NSURL *fileForButton = [self getAudioFileFromDialog];
        
        // fill the dictionary with the selected audio file
        [self.audioFiles setObject:fileForButton forKey:button.identifier];
        
        // update the button text with the name of the file
        NSString* theFileName = [[fileForButton lastPathComponent] stringByDeletingPathExtension];
        button.title = theFileName;

    } else {
        // if the file is already loaded, simply play it
        [self playSoundUrl:[self.audioFiles objectForKey:button.identifier]];
    }
    
}
@end
