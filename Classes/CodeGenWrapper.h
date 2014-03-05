//
//  CodeGenWrapper.h
//  Echoprint
//
//  Created by Виктор Полевой on 04.03.14.
//
//

#import <Foundation/Foundation.h>

#import <string>
#import <regex>

#import "Codegen.h"

@interface CodeGenWrapper : NSObject
{
    @private
    Codegen *codegen;
    
    NSString *fingerprint;
}

- (id) initWithPCM:(float*)pcmFloatValue numberOfSamples:(NSUInteger)numSamples startOffset:(NSInteger)startOffset;

- (NSString*) codeString;
@end
