//
//  AudioDeviceList.m
//  Sounda
//
//  Created by Francesco Zerbinati on 13/03/15.
//  Copyright (c) 2015 Francesco Zerbinati. All rights reserved.
//

#import "AudioDeviceList.h"

@implementation AudioDeviceList


+ (AudioDeviceList *)shared {
    static dispatch_once_t once;
    static AudioDeviceList * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        
    });
    return sharedInstance;
}


-(void)buildAudioDevicesList:(NSPopUpButton *)target {
    
    [target removeAllItems];
    
    AudioObjectPropertyAddress  propertyAddress;
    AudioObjectID               *deviceIDs;
    UInt32                      propertySize;
    NSInteger                   numDevices;
    
    AudioDeviceID theDefault = 0;
    UInt32 theSize = sizeof(AudioDeviceID);
    AudioObjectPropertyAddress theAddress = { kAudioHardwarePropertyDefaultOutputDevice,
        kAudioObjectPropertyScopeGlobal,
        kAudioObjectPropertyElementMaster };
    
    AudioObjectGetPropertyData(kAudioObjectSystemObject,
                               &theAddress,
                               0,
                               NULL,
                               &theSize,
                               &theDefault);
    
    propertyAddress.mSelector = kAudioHardwarePropertyDevices;
    propertyAddress.mScope = kAudioDevicePropertyScopeOutput;
    propertyAddress.mElement = kAudioObjectPropertyElementMaster;
    if (AudioObjectGetPropertyDataSize(kAudioObjectSystemObject, &propertyAddress, 0, NULL, &propertySize) == noErr) {
        numDevices = propertySize / sizeof(AudioDeviceID);
        deviceIDs = (AudioDeviceID *)calloc(numDevices, sizeof(AudioDeviceID));
        
        if (AudioObjectGetPropertyData(kAudioObjectSystemObject, &propertyAddress, 0, NULL, &propertySize, deviceIDs) == noErr) {
            AudioObjectPropertyAddress      deviceAddress;
            char                            deviceName[64];
            
            for (NSInteger idx=0; idx<numDevices; idx++) {
                propertySize = sizeof(deviceName);
                deviceAddress.mSelector = kAudioDevicePropertyDeviceName;
                deviceAddress.mScope = kAudioDevicePropertyScopeOutput;
                deviceAddress.mElement = kAudioObjectPropertyElementMaster;
                if (AudioObjectGetPropertyData(deviceIDs[idx], &deviceAddress, 0, NULL, &propertySize, deviceName) == noErr) {
                    CFStringRef     uidString;
                    
                    propertySize = sizeof(uidString);
                    deviceAddress.mSelector = kAudioDevicePropertyDeviceUID;
                    deviceAddress.mScope = kAudioDevicePropertyScopeOutput;
                    deviceAddress.mElement = kAudioObjectPropertyElementMaster;
                    if (AudioObjectGetPropertyData(deviceIDs[idx], &deviceAddress, 0, NULL, &propertySize, &uidString) == noErr) {
                        
                        deviceAddress.mSelector = kAudioDevicePropertyStreams;
                        deviceAddress.mScope = kAudioDevicePropertyScopeOutput;
                        UInt32 dataSize = 0;
                        UInt32 streamCount = 0;
                        if (AudioObjectGetPropertyDataSize(deviceIDs[idx],  &deviceAddress, 0, NULL, &dataSize) == noErr) {
                            
                            streamCount = dataSize / sizeof(AudioStreamID);
                            
                            if (streamCount > 0)
                            {
                                
                                UInt32 ioSize = 0;
                                UInt32 theNumberOutputChannels = 0;
                                UInt32      theIndex = 0;
                                OSStatus err = noErr;
                                deviceAddress.mScope = kAudioObjectPropertyScopeOutput;
                                deviceAddress.mSelector = kAudioDevicePropertyStreamConfiguration;
                                
                                AudioObjectGetPropertyDataSize(deviceIDs[idx], &deviceAddress, 0, NULL, &ioSize);
                                if (ioSize != 0)
                                {
                                    AudioBufferList *theBufferList = (AudioBufferList*)malloc(ioSize);
                                    if(theBufferList != NULL)
                                    {
                                        // get the input stream configuration
                                        err = AudioObjectGetPropertyData(deviceIDs[idx], &deviceAddress, 0, NULL, &ioSize, theBufferList);
                                        if(err == noErr)
                                        {
                                            // count the total number of output channels in the stream
                                            for(theIndex = 0; theIndex < theBufferList->mNumberBuffers; ++theIndex)
                                                theNumberOutputChannels += theBufferList->mBuffers[theIndex].mNumberChannels;
                                        }
                                        free(theBufferList);
                                        
                                    }
                                }
                                
                                NSLog(@"device: %s channels: %d", deviceName, theNumberOutputChannels);
                                
                                
                                
                                
                                [target addItemWithTitle:[NSString stringWithFormat:@"%s", deviceName]];
                                [[target itemWithTitle:[NSString stringWithFormat:@"%s", deviceName]] setRepresentedObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@", uidString], [NSNumber numberWithInt:0], [NSNumber numberWithInt:1], nil]];
                                
                                
                                
                                if (theDefault == deviceIDs[idx]) {
                                    NSLog(@"found the default audio device: %s (UID:%@)", deviceName, uidString);
                                    if ([target itemWithTitle:[NSString stringWithFormat:@"%s", deviceName]]) {
                                        [target selectItemWithTitle:[NSString stringWithFormat:@"%s", deviceName]];
                                    } else if ([target itemWithTitle:[NSString stringWithFormat:@"1|2 %s", deviceName]]) {
                                        [target selectItemWithTitle:[NSString stringWithFormat:@"1|2 %s", deviceName]];
                                    }
                                }
                            }
                            
                        }
                        
                        CFRelease(uidString);
                    }
                }
            }
        }
        
        free(deviceIDs);
    }
    
}



@end
