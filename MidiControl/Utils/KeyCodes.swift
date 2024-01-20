//
//  KeyCodes.swift
//  MidiControl
//
//  Created by Sviatoslav Romankiv on 20.01.2024.
//

enum KeyCode: Int32, Identifiable, CaseIterable, CustomStringConvertible {
    case A = 0x00
    case S = 0x01
    case D = 0x02
    case F = 0x03
    case H = 0x04
    case G = 0x05
    case Z = 0x06
    case X = 0x07
    case C = 0x08
    case V = 0x09
    case B = 0x0B
    case Q = 0x0C
    case W = 0x0D
    case E = 0x0E
    case R = 0x0F
    case Y = 0x10
    case T = 0x11
    case num1 = 0x12
    case num2 = 0x13
    case num3 = 0x14
    case num4 = 0x15
    case num6 = 0x16
    case num5 = 0x17
    case equals = 0x18
    case num9 = 0x19
    case num7 = 0x1A
    case minus = 0x1B
    case num8 = 0x1C
    case num0 = 0x1D
    case bracketRight = 0x1E
    case O = 0x1F
    case U = 0x20
    case bracketLeft = 0x21
    case I = 0x22
    case P = 0x23
    case `return` = 0x24
    case L = 0x25
    case J = 0x26
    case apostrophe = 0x27
    case K = 0x28
    case semicolon = 0x29
    case backslash = 0x2A
    case comma = 0x2B
    case slash = 0x2C
    case N = 0x2D
    case M = 0x2E
    case period = 0x2F
    case tab = 0x30
    case space = 0x31
    case tilde = 0x32
    case delete = 0x33
    case esc = 0x35
    case cmd = 0x37
    case shift = 0x38
    case capsLock = 0x39
    case option = 0x3A
    case control = 0x3B
    case keypadDot = 0x41
    case keypadMultiply = 0x43
    case keypadPlus = 0x45
    case keypadMinus = 0x4E
    case keypadDivide = 0x4B
    case keypadEnter = 0x4C
    case keypadEquals = 0x51
    case keypad0 = 0x52
    case keypad1 = 0x53
    case keypad2 = 0x54
    case keypad3 = 0x55
    case keypad4 = 0x56
    case keypad5 = 0x57
    case keypad6 = 0x58
    case keypad7 = 0x59
    case keypad8 = 0x5B
    case keypad9 = 0x5C
    case F5 = 0x60
    case F6 = 0x61
    case F7 = 0x62
    case F3 = 0x63
    case F8 = 0x64
    case F9 = 0x65
    case F11 = 0x67
    case F13 = 0x69
    case F14 = 0x6B
    case F10 = 0x6D
    case F12 = 0x6F
    case F15 = 0x71
    case help = 0x72
    case home = 0x73
    case pageUp = 0x74
    case delBelowHelp = 0x75
    case F4 = 0x76
    case end = 0x77
    case F2 = 0x78
    case pageDown = 0x79
    case F1 = 0x7A
    case leftArrow = 0x7B
    case rightArrow = 0x7C
    case downArrow = 0x7D
    case upArrow = 0x7E

    var id: Self { self }

    var description: String {
        switch self {
        case .A: return "A"
        case .S: return "S"
        case .D: return "D"
        case .F: return "F"
        case .H: return "H"
        case .G: return "G"
        case .Z: return "Z"
        case .X: return "X"
        case .C: return "C"
        case .V: return "V"
        case .B: return "B"
        case .Q: return "Q"
        case .W: return "W"
        case .E: return "E"
        case .R: return "R"
        case .Y: return "Y"
        case .T: return "T"
        case .num1: return "1"
        case .num2: return "2"
        case .num3: return "3"
        case .num4: return "4"
        case .num6: return "6"
        case .num5: return "5"
        case .equals: return "="
        case .num9: return "9"
        case .num7: return "7"
        case .minus: return "-"
        case .num8: return "8"
        case .num0: return "0"
        case .bracketRight: return "]"
        case .O: return "O"
        case .U: return "U"
        case .bracketLeft: return "["
        case .I: return "I"
        case .P: return "P"
        case .return: return "Return"
        case .L: return "L"
        case .J: return "J"
        case .apostrophe: return "'"
        case .K: return "K"
        case .semicolon: return ";"
        case .backslash: return "\\"
        case .comma: return ","
        case .slash: return "/"
        case .N: return "N"
        case .M: return "M"
        case .period: return "."
        case .tab: return "Tab"
        case .space: return "Space"
        case .tilde: return "~"
        case .delete: return "Delete"
        case .esc: return "Esc"
        case .cmd: return "Cmd (Apple)"
        case .shift: return "Shift"
        case .capsLock: return "Caps Lock"
        case .option: return "Option"
        case .control: return "Control"
        case .keypadDot: return "Keypad Dot"
        case .keypadMultiply: return "Keypad Multiply"
        case .keypadPlus: return "Keypad Plus"
        case .keypadMinus: return "Keypad Minus"
        case .keypadDivide: return "Keypad Divide"
        case .keypadEnter: return "Keypad Enter"
        case .keypadEquals: return "Keypad Equals"
        case .keypad0: return "Keypad 0"
        case .keypad1: return "Keypad 1"
        case .keypad2: return "Keypad 2"
        case .keypad3: return "Keypad 3"
        case .keypad4: return "Keypad 4"
        case .keypad5: return "Keypad 5"
        case .keypad6: return "Keypad 6"
        case .keypad7: return "Keypad 7"
        case .keypad8: return "Keypad 8"
        case .keypad9: return "Keypad 9"
        case .F5: return "F5"
        case .F6: return "F6"
        case .F7: return "F7"
        case .F3: return "F3"
        case .F8: return "F8"
        case .F9: return "F9"
        case .F11: return "F11"
        case .F13: return "F13"
        case .F14: return "F14"
        case .F10: return "F10"
        case .F12: return "F12"
        case .F15: return "F15"
        case .help: return "Help"
        case .home: return "Home"
        case .pageUp: return "Page Up"
        case .delBelowHelp: return "Delete Below Help"
        case .F4: return "F4"
        case .end: return "End"
        case .F2: return "F2"
        case .pageDown: return "Page Down"
        case .F1: return "F1"
        case .leftArrow: return "Left Arrow"
        case .rightArrow: return "Right Arrow"
        case .downArrow: return "Down Arrow"
        case .upArrow: return "Up Arrow"
        }
    }
}
