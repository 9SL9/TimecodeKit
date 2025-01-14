//
//  Timecode.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

/// Value type representing SMPTE timecode.
///
/// - A variety of initializers and methods are available for string and numeric representation, validation, and conversion
/// - Mathematical operators are available between two instances: `+`, `-`, `*`, `\`
/// - Comparison operators are available between two instances: `==`, `!=`, `<`, `>`
/// - `Range` and `Stride` can be formed between two instances
public struct Timecode {
    // MARK: - Immutable properties
    
    /// Frame rate.
    ///
    /// Note: Several properties are available on the frame rate that is selected, including its ``stringValue`` representation or whether the rate ``TimecodeFrameRate/isDrop``.
    ///
    /// Setting this value directly does not trigger any validation.
    public var frameRate: TimecodeFrameRate
    
    /// Timecode maximum upper bound.
    ///
    /// This also affects how timecode values wrap when adding or clamping.
    ///
    /// Setting this value directly does not trigger any validation.
    public var upperLimit: UpperLimit
    
    /// Subframes base (divisor).
    ///
    /// The number of subframes that make up a single frame.
    ///
    /// (ie: a divisor of 80 subframes per frame implies a visible value range of 00...79)
    ///
    /// This will vary depending on application. Most common divisors are 80 or 100.
    public var subFramesBase: SubFramesBase
    
    /// Timecode string output format configuration.
    public var stringFormat: StringFormat
    
    // MARK: - Mutable properties
    
    /// Timecode days component.
    ///
    /// Valid only if ``upperLimit-swift.property`` is set to `._100days`.
    ///
    /// Setting this value directly does not trigger any validation.
    public var days: Int = 0
    
    /// Timecode hours component.
    ///
    /// Valid range: 0 ... 23.
    ///
    /// Setting this value directly does not trigger any validation.
    public var hours: Int = 0
    
    /// Timecode minutes component.
    ///
    /// Valid range: 0 ... 59.
    ///
    /// Setting this value directly does not trigger any validation.
    public var minutes: Int = 0
    
    /// Timecode seconds component.
    ///
    /// Valid range: 0 ... 59.
    ///
    /// Setting this value directly does not trigger any validation.
    public var seconds: Int = 0
    
    /// Timecode frames component.
    ///
    /// Valid range is dependent on the `frameRate` property.
    ///
    /// Setting this value directly does not trigger any validation.
    public var frames: Int = 0
    
    /// Timecode subframes component. Represents a partial division of a frame.
    ///
    /// Some implementations refer to these as SMPTE frame "bits".
    ///
    /// There are no set industry standards regarding subframe divisors.
    /// - Cubase/Nuendo, Logic Pro/Final Cut Pro use 80 subframes per frame (0 ... 79);
    /// - Pro Tools uses 100 subframes (0 ... 99).
    public var subFrames: Int = 0
}

// Can't put this in another file since it prevents automatic synthesis
// But for sake of consistency, we'll put it on an extension here since all other
// protocol conformances exist in separate files. Sad panda.
extension Timecode: Codable { }
