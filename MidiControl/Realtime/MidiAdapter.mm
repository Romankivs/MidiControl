#import "MidiAdapter.h"
#import "SingleProducerSingleConsumerQueue.hpp"

typedef SingleProducerSingleConsumerQueue<MIDIEventPacket> MIDIMessageFIFO;

@implementation MidiAdapter {
    std::unique_ptr<MIDIMessageFIFO> messageQueue;
}

-(id)init {
    self = [super init];
    if (self) {
        messageQueue = std::make_unique<MIDIMessageFIFO>(64);
    }
    return self;
}

// MARK: - Core MIDI

-(OSStatus)createMIDISource:(MIDIClientRef)client named:(CFStringRef)name protocol:(MIDIProtocolID)protocol port:(MIDIEndpointRef *)outPort {
    __block MIDIMessageFIFO *msgQueue = messageQueue.get();
    const auto status = MIDIInputPortCreateWithProtocol(client, name, protocol, outPort, ^(const MIDIEventList * _Nonnull evtlist, void * _Nullable srcConnRefCon) {

        if (evtlist->numPackets > 0 && msgQueue) {
            auto pkt = &evtlist->packet[0];

            for (int i = 0; i < evtlist->numPackets; ++i) {
                if (!msgQueue->push(evtlist->packet[i])) {
                    msgQueue->push(evtlist->packet[i]);
                }
                pkt = MIDIEventPacketNext(pkt);
            }
        }
    });
    return status;
}

-(void)popSourceMessages:(void (^)(const MIDIEventPacket))callback {
    if (!messageQueue)
        return;

    while (const auto message = messageQueue->pop()) {
        callback(*message);
    }
}

@end

