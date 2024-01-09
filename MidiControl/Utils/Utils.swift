//
//  Utils.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 09.01.2024.
//

import Foundation

func extractBits(from number: UInt32, at position: Int, numberOfBits: Int) -> UInt32 {
    // Ensure that the position and number of bits are within valid ranges
    guard position >= 0 && position <= 32 && numberOfBits > 0 && numberOfBits <= 32 else {
        fatalError("Invalid position or number of bits.")
    }

    // Mask the desired bits at the specified position
    let mask: UInt32 = (1 << numberOfBits) - 1
    let maskedValue = (number >> position) & mask

    return maskedValue
}

func statusFromUMP(ump: UInt32) -> MIDICVStatus {
    return MIDICVStatus(rawValue: extractBits(from: ump, at: 20, numberOfBits: 4)) ?? .noteOff
}

