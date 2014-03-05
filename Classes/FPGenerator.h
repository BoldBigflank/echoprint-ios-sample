//
//  FPGenerator.h
//  Echoprint
//
//  Created by Виктор Полевой on 04.03.14.
//
//

#import <Foundation/Foundation.h>
#include <AudioToolbox/AudioToolbox.h>
#include "CAStreamBasicDescription.h"

#import "CodeGenWrapper.h"

@interface FPGenerator : NSObject

+ (NSString*) generateFingerprintForFile:(NSString*)fullFileName;

@end
