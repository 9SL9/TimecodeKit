//
//  TimecodeFrameRate.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// MARK: - FrameRate

/// Timecode frame rate.
/// Industry-standard BITC (burn-in timecode) display rates.
public enum TimecodeFrameRate: String, FrameRateProtocol {
    /// 23.976 fps (aka 23.98)
    ///
    /// Also known as 24p for HD video, sometimes rounded up to 23.98 fps. started out as the format for dealing with 24fps film in a NTSC post environment.
    case _23_976 = "23.976"
    
    /// 24 fps
    ///
    /// (film, ATSC, 2k, 4k, 6k)
    case _24 = "24"
    
    /// 24.98 fps
    ///
    /// This frame rate is commonly used to facilitate transfers between PAL and NTSC video and film sources. It is mostly used to compensate for some error.
    case _24_98 = "24.98"
    
    /// 25 fps
    ///
    /// (PAL, used in Europe, Uruguay, Argentina, Australia), SECAM, DVB, ATSC)
    case _25 = "25"
    
    /// 29.97 fps (30p)
    ///
    /// (NTSC American System (US, Canada, Mexico, Colombia, etc.), ATSC, PAL-M (Brazil))
    /// (30 / 1.001) frame/sec
    case _29_97 = "29.97"
    
    /// 29.97 drop fps
    case _29_97_drop = "29.97d"
    
    /// 30 fps
    ///
    /// (ATSC) This is the frame count of NTSC broadcast video. However, the actual frame rate or speed of the video format runs at 29.97 fps.
    ///
    /// This timecode clock does not run in realtime. It is slightly slower by 0.1%.
    /// ie: 1:00:00:00:00 (1 day/24 hours) at 30 fps is approx 1:00:00:00;02 in 29.97df
    case _30 = "30"
    
    /// 30 drop fps:
    ///
    /// The 30 fps drop count is an adaptation that allows a timecode display running at 29.97 fps to actually show the clock-on-the-wall-time of the timeline by “dropping” or skipping specific frame numbers in order to “catch the clock up” to realtime.
    ///
    /// - Warning: This is not a video frame rate - it is a display rate only.
    case _30_drop = "30d"
    
    /// 47.952 (48p?)
    ///
    /// Double 23.976 fps
    case _47_952 = "47.952"
    
    /// 48 fps
    ///
    /// Double 24 fps
    case _48 = "48"
    
    /// 50 fps
    ///
    /// Double 25 fps
    case _50 = "50"
    
    /// 59.94 fps
    ///
    /// Double 29.97 fps
    ///
    /// This video frame rate is supported by high definition cameras and is compatible with NTSC (29.97 fps).
    case _59_94 = "59.94"
    
    /// 59.94 drop fps
    ///
    /// Double 29.97 drop fps
    case _59_94_drop = "59.94d"
    
    /// 60 fps
    ///
    /// Double 30 fps
    ///
    /// This video frame rate is supported by many high definition cameras. However, the NTSC compatible 59.94 fps frame rate is much more common.
    case _60 = "60"
    
    /// 60 drop fps
    ///
    /// Double 30 fps
    ///
    /// See the description for 30 drop for more info.
    ///
    /// - Warning: This is not a video frame rate - it is a display rate only.
    case _60_drop = "60d"
    
    /// 100 fps
    ///
    /// Double 50 fps / quadruple 25 fps
    case _100 = "100"
    
    /// 119.88 fps
    ///
    /// Double 59.94 fps / quadruple 29.97 fps
    case _119_88 = "119.88"
    
    /// 119.88 drop fps
    ///
    /// Double 59.94 drop fps / quadruple 29.97 drop fps
    case _119_88_drop = "119.88d"
    
    /// 120 fps
    ///
    /// Double 60 fps / quadruple 30 fps
    case _120 = "120"
    
    /// 120 drop fps
    ///
    /// Double 60 fps drop / quadruple 30 fps drop
    ///
    /// See the description for 30 drop for more info.
    ///
    /// - Warning: This is not a video frame rate - it is a display rate only.
    case _120_drop = "120d"
}

extension TimecodeFrameRate: CaseIterable {
    /// All drop frame rates.
    public static let allDrop: [Self] = allCases.filter { $0.isDrop }
    
    /// All non-drop frame rates.
    public static let allNonDrop: [Self] = allCases.filter { !$0.isDrop }
}

extension TimecodeFrameRate: CustomStringConvertible {
    public var description: String {
        stringValue
    }
}

extension TimecodeFrameRate: Codable { }

@available(macOS 10.15, macCatalyst 13, iOS 11, *)
extension TimecodeFrameRate: Identifiable {
    public var id: String {
        rawValue
    }
}
