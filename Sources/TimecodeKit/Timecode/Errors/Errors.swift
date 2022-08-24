//
//  Errors.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Timecode {
    public enum ValidationError: Error {
        case outOfBounds
    }
    
    public enum StringParseError: Error {
        case malformed
    }
}