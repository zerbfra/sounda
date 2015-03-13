//
//  AudioDeviceList.h
//  Sounda
//
//  Created by Francesco Zerbinati on 13/03/15.
//  Copyright (c) 2015 Francesco Zerbinati. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <CoreAudio/CoreAudio.h>

@interface AudioDeviceList : NSObject


+ (AudioDeviceList *)shared;

-(void)buildAudioDevicesList:(NSPopUpButton *)target;

@end
