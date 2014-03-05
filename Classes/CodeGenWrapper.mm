//
//  CodeGenWrapper.m
//  Echoprint
//
//  Created by Виктор Полевой on 04.03.14.
//
//

#import "CodeGenWrapper.h"

@implementation CodeGenWrapper

- (id) initWithPCM:(float*)pcmFloatValue numberOfSamples:(NSUInteger)numSamples startOffset:(NSInteger)startOffset
{
    if (self = [super init])
    {
        self->fingerprint = Codegen::encode(pcmFloatValue, numSamples, startOffset);        
    }
    
    return self;
}

- (NSString*) codeString
{
    return self->fingerprint;
}

- (NSInteger) numCodes
{
    if (self->codegen != nil)
    {
        return self->codegen->getNumCodes();
    }
    
    return 0;
}

- (float) version
{
    if (self->codegen != nil)
    {
        return self->codegen->getVersion();
    }
    
    return 0;
}

@end
