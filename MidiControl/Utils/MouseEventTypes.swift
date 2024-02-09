//
//  MouseEventTypes.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 09.02.2024.
//

import Foundation
import CoreGraphics

enum MouseEventType: Int32, Identifiable, CaseIterable, CustomStringConvertible {
    case leftUp
    case leftDown
    case leftDrag
    case rightUp
    case rightDown
    case rightDrag
    case otherUp
    case otherDown
    case otherDrag
    case move

    var id: Self { self }

    var description: String {
        switch self {
        case .leftUp:
            return "Left Button Up"
        case .leftDown:
            return "Left Button Down"
        case .leftDrag:
            return "Left Button Drag"
        case .rightUp:
            return "Right Button Up"
        case .rightDown:
            return "Right Button Down"
        case .rightDrag:
            return "Right Button Drag"
        case .otherUp:
            return "Other Button Up"
        case .otherDown:
            return "Other Button Down"
        case .otherDrag:
            return "Other Button Drag"
        case .move:
            return "Move"
        }
    }

    func toCGEventType() -> CGEventType {
        switch self {
        case .leftUp:
            return .leftMouseDown
        case .leftDown:
            return .leftMouseUp
        case .leftDrag:
            return .leftMouseDragged
        case .rightUp:
            return .rightMouseDown
        case .rightDown:
            return .rightMouseUp
        case .rightDrag:
            return .rightMouseDragged
        case .otherUp:
            return .otherMouseDown
        case .otherDown:
            return .otherMouseUp
        case .otherDrag:
            return .otherMouseDragged
        case .move:
            return .mouseMoved
        }
    }
}
