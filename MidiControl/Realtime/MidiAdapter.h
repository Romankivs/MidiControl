#import <Foundation/Foundation.h>
#import <CoreMIDI/CoreMIDI.h>

NS_ASSUME_NONNULL_BEGIN

@interface MidiAdapter : NSObject

-(id)init;

-(OSStatus)createMIDISource:(MIDIClientRef)client named:(CFStringRef)name protocol:(MIDIProtocolID)protocol port:(MIDIPortRef *)outPort;

-(void)popSourceMessages:(void (^)(const MIDIEventPacket))callback;

@end

NS_ASSUME_NONNULL_END
