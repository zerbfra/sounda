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

    // Do any additional setup after loading the view.
    
    self.audioFiles = [NSMutableDictionary dictionary];
    
    [[AudioDeviceList shared] buildAudioDevicesList:self.audioDeviceSelector];
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


-(void) playSoundUrl:(NSURL*) url {
    
    if([self.snd isPlaying]) {
        [self.snd stop];
    }
    
    self.snd = [[NSSound alloc] initWithContentsOfURL:url byReference:NO];
    
    
    NSArray *data = [[[self audioDeviceSelector] selectedItem] representedObject];
    
    [self.snd setPlaybackDeviceIdentifier:[data objectAtIndex:0]];
    
    NSLog(@"channels mapped to device: %@", [self.snd playbackDeviceIdentifier]);
    
    [self.snd play];
    
}


- (NSURL*)getAudioFileFromDialog {
    
    NSInteger result;
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    NSArray *filesToOpen;
    NSURL *theNewFilePath;
    NSMutableArray *fileTypes = [NSMutableArray arrayWithArray:[NSSound soundUnfilteredTypes]];
    
    [oPanel setAllowsMultipleSelection:NO];
    [oPanel setDirectoryURL:[NSURL URLWithString:NSHomeDirectory()]];
    oPanel.allowedFileTypes = fileTypes;
    
    result = [oPanel runModal];
    
    filesToOpen = [oPanel URLs];
    theNewFilePath = [filesToOpen objectAtIndex:0];
    NSLog(@"Sound file is now: %@", theNewFilePath);
    
    return theNewFilePath;
}


- (IBAction)stopSounds:(id)sender {
    if([self.snd isPlaying]) {
        [self.snd stop];
    }
}

- (IBAction)audioButtonPressed:(id)sender {
    
    NSButton *button = (NSButton*) sender;
    
    NSLog(@"%@",button.identifier);
    
    if([self.audioFiles objectForKey:(NSString*)button.identifier] == nil) {
        
        NSLog(@"%@ -- %@",[self.audioFiles objectForKey:button.identifier],button.identifier);
        
        NSURL *fileForButton = [self getAudioFileFromDialog];
        
        [self.audioFiles setObject:fileForButton forKey:button.identifier];
        NSString* theFileName = [[fileForButton lastPathComponent] stringByDeletingPathExtension];
        button.title = theFileName;
        
        //NSLog(@"%@",self.audioFiles);
        
        //[self playSoundUrl:fileForButton];
    } else {
        [self playSoundUrl:[self.audioFiles objectForKey:button.identifier]];
    }
    
}
@end
