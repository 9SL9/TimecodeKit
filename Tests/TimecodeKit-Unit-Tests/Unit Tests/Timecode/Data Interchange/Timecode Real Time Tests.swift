//
//  Timecode Real Time Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class Timecode_RealTime_Tests: XCTestCase {
    // pre-computed constants
    
    // confirmed correct in PT and Cubase
    let secInTC10Days_ShrunkFrameRates = 864_864.000
    let secInTC10Days_BaseFrameRates = 864_000.000
    let secInTC10Days_DropFrameRates = 863_999.136
    let secInTC10Days_30DF = 86_313.6 * 10
    
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_init_RealTimeValue_Exactly() throws {
        try TimecodeFrameRate.allCases.forEach {
            let tc = try Timecode(
                realTime: 2,
                at: $0,
                limit: ._24hours
            )
            
            // don't imperatively check each result, just make sure that a value was set;
            // setter logic is unit-tested elsewhere, we just want to check the Timecode.init interface here.
            XCTAssertNotEqual(tc.seconds, 0, "for \($0)")
        }
    }
    
    func testTimecode_init_RealTimeValue_Clamping() {
        let tc = Timecode(
            clampingRealTime: 86400 + 3600, // 25 hours @ 24fps
            at: ._24,
            limit: ._24hours
        )
        
        XCTAssertEqual(
            tc.components,
            TCC(h: 23, m: 59, s: 59, f: 23, sf: tc.subFramesBase.rawValue - 1)
        )
    }
    
    func testTimecode_init_RealTimeValue_Wrapping() {
        let tc = Timecode(
            wrappingRealTime: 86400 + 3600, // 25 hours @ 24fps
            at: ._24,
            limit: ._24hours
        )
        
        XCTAssertEqual(tc.days, 0)
        XCTAssertEqual(tc.hours, 1)
        XCTAssertEqual(tc.minutes, 0)
        XCTAssertEqual(tc.seconds, 0)
        XCTAssertEqual(tc.frames, 0)
        XCTAssertEqual(tc.subFrames, 0)
    }
    
    func testTimecode_init_RealTimeValue_RawValues() {
        let tc = Timecode(
            rawValuesRealTime: (86400 * 2) + 3600, // 2 days + 1 hour @ 24fps
            at: ._24,
            limit: ._24hours
        )
        
        XCTAssertEqual(tc.days, 2)
        XCTAssertEqual(tc.hours, 1)
        XCTAssertEqual(tc.minutes, 0)
        XCTAssertEqual(tc.seconds, 0)
        XCTAssertEqual(tc.frames, 0)
        XCTAssertEqual(tc.subFrames, 0)
    }
    
    func testTimecode_init_RealTimeValue_RawValues_Negative() {
        let tc = Timecode(
            rawValuesRealTime: -(3600 + 60 + 5),
            at: ._24,
            limit: ._24hours
        )
        
        // Negates only the largest non-zero component if input is negative
        XCTAssertEqual(
            tc.components,
            TCC(d: 00, h: -01, m: 01, s: 05, f: 00, sf: 00)
        )
    }
    
    func testTimecode_RealTimeValue() throws {
        // get real time
        
        // set up a reasonable accuracy to account for floating-point precision/rounding
        let accuracy = 0.000000001
        
        try TimecodeFrameRate.allCases.forEach {
            let tc = try Timecode(TCC(d: 10), at: $0, limit: ._100days)
            
            switch $0 {
            case ._23_976,
                 ._24_98,
                 ._29_97,
                 ._47_952,
                 ._59_94,
                 ._119_88:
                
                XCTAssertEqual(
                    tc.realTimeValue,
                    secInTC10Days_ShrunkFrameRates,
                    accuracy: accuracy,
                    "at: \($0)"
                )
                
            case ._24,
                 ._25,
                 ._30,
                 ._48,
                 ._50,
                 ._60,
                 ._100,
                 ._120:
                
                XCTAssertEqual(
                    tc.realTimeValue,
                    secInTC10Days_BaseFrameRates,
                    accuracy: accuracy,
                    "at: \($0)"
                )
                
            case ._29_97_drop,
                 ._59_94_drop,
                 ._119_88_drop:
                
                XCTAssertEqual(
                    tc.realTimeValue,
                    secInTC10Days_DropFrameRates,
                    accuracy: accuracy,
                    "at: \($0)"
                )
                
            case ._30_drop,
                 ._60_drop,
                 ._120_drop:
                
                XCTAssertEqual(
                    tc.realTimeValue,
                    secInTC10Days_30DF,
                    accuracy: accuracy,
                    "at: \($0)"
                )
            }
        }
        
        // set timecode from real time
        
        let tcc = TCC(d: 10)
        
        try TimecodeFrameRate.allCases.forEach {
            var tc = try Timecode(tcc, at: $0, limit: ._100days)
            
            switch $0 {
            case ._23_976,
                 ._24_98,
                 ._29_97,
                 ._47_952,
                 ._59_94,
                 ._119_88:
                
                XCTAssertNoThrow(
                    try tc.setTimecode(realTime: secInTC10Days_ShrunkFrameRates),
                    "at: \($0)"
                )
                XCTAssertEqual(tc.components, tcc, "at: \($0)")
                
            case ._24,
                 ._25,
                 ._30,
                 ._48,
                 ._50,
                 ._60,
                 ._100,
                 ._120:
                
                XCTAssertNoThrow(
                    try tc.setTimecode(realTime: secInTC10Days_BaseFrameRates),
                    "at: \($0)"
                )
                XCTAssertEqual(tc.components, tcc, "at: \($0)")
                
            case ._29_97_drop,
                 ._59_94_drop,
                 ._119_88_drop:
                
                XCTAssertNoThrow(
                    try tc.setTimecode(realTime: secInTC10Days_DropFrameRates),
                    "at: \($0)"
                )
                XCTAssertEqual(tc.components, tcc, "at: \($0)")
                
            case ._30_drop,
                 ._60_drop,
                 ._120_drop:
                
                XCTAssertNoThrow(
                    try tc.setTimecode(realTime: secInTC10Days_30DF),
                    "at: \($0)"
                )
                XCTAssertEqual(tc.components, tcc, "at: \($0)")
            }
        }
    }
    
    func testTimecode_RealTimeValue_SubFrames() throws {
        // ensure subframes are calculated correctly
        
        // test for precision and rounding issues by iterating every subframe for each frame rate
        
        let subFramesBase: Timecode.SubFramesBase = ._80SubFrames
        
        for subFrame in 0 ..< subFramesBase.rawValue {
            let tcc = TCC(d: 99, h: 23, sf: subFrame)
            
            try TimecodeFrameRate.allCases.forEach {
                var tc = try Timecode(
                    tcc,
                    at: $0,
                    limit: ._100days,
                    base: subFramesBase
                )
                
                // timecode to samples
                
                let realTime = tc.realTimeValue
                
                // samples to timecode
                
                XCTAssertNoThrow(
                    try tc.setTimecode(realTime: realTime),
                    "at: \($0) subframe: \(subFrame)"
                )
                
                XCTAssertEqual(
                    tc.components,
                    tcc,
                    "at: \($0) subframe: \(subFrame)"
                )
            }
        }
    }
    
    func testTimecode_RealTimeValue_RealWorld_SubFrames() throws {
        // test against real-world values extracted from DAWs
        
        // Cubase 11 XML file output (high resolution floating-point times in seconds)
        
        // the timecodes in the constant variable names are the timecodes as seen in Cubase
        // the float-point number constant values are extracted from a Track Archive XML file exported from the Cubase project which outputs very high precision float-point numbers in seconds to define many attributes such as the project start time, and event start times and lengths on tracks which are in absolute time mode (not musical bars/beats mode which gets stored as PPQ values in the XML file instead of float-point seconds)
        
        // 23.976fps, 80 subframe divisor
        
        //  _HH_MM_SS_FF_SF
        
        // session start timecode
        let _00_49_27_15_00 = 2970.5926250000002255546860396862030029296875
        
        // events: delta times from session start time
        let _00_49_29_17_00_delta = 2.0854162836310767836778268247144296765327453613281
        let _00_49_31_09_00_delta = 3.7537499627098442900319241744000464677810668945312
        let _00_49_33_21_79_delta = 6.297436893962323978257700218819081783294677734375
        let _00_49_38_01_79_delta = 10.468270548180987233877203834708780050277709960938
        
        // test timecode formation from real time
        
        let start = try Timecode(
            realTime: _00_49_27_15_00,
            at: ._23_976
        )
        XCTAssertEqual(
            start.components,
            TCC(h: 00, m: 49, s: 27, f: 15, sf: 00)
        )
        
        let event1 = try Timecode(
            realTime: _00_49_27_15_00 + _00_49_29_17_00_delta,
            at: ._23_976
        )
        XCTAssertEqual(
            event1.components,
            TCC(h: 00, m: 49, s: 29, f: 17, sf: 00)
        )
        
        let event2 = try Timecode(
            realTime: _00_49_27_15_00 + _00_49_31_09_00_delta,
            at: ._23_976
        )
        XCTAssertEqual(
            event2.components,
            TCC(h: 00, m: 49, s: 31, f: 09, sf: 00)
        )
        
        let event3 = try Timecode(
            realTime: _00_49_27_15_00 + _00_49_33_21_79_delta,
            at: ._23_976,
            base: ._80SubFrames
        )
        XCTAssertEqual(
            event3.components,
            TCC(h: 00, m: 49, s: 33, f: 21, sf: 79)
        )
        
        let event4 = try Timecode(
            realTime: _00_49_27_15_00 + _00_49_38_01_79_delta,
            at: ._23_976,
            base: ._80SubFrames
        )
        XCTAssertEqual(
            event4.components,
            TCC(h: 00, m: 49, s: 38, f: 01, sf: 79)
        )
        
        // test real time matching the seconds constants
        
        // start
        XCTAssertEqual(
            try TCC(h: 00, m: 49, s: 27, f: 15, sf: 00)
                .toTimecode(at: ._23_976)
                .realTimeValue,
            _00_49_27_15_00
        )
        
        // event1
        XCTAssertEqual(
            try TCC(h: 00, m: 49, s: 29, f: 17, sf: 00)
                .toTimecode(at: ._23_976)
                .realTimeValue,
            _00_49_27_15_00 + _00_49_29_17_00_delta,
            accuracy: 0.0000005
        )
        
        // event2
        XCTAssertEqual(
            try TCC(h: 00, m: 49, s: 31, f: 09, sf: 00)
                .toTimecode(at: ._23_976)
                .realTimeValue,
            _00_49_27_15_00 + _00_49_31_09_00_delta,
            accuracy: 0.0000005
        )
        
        // event3
        XCTAssertEqual(
            try TCC(h: 00, m: 49, s: 33, f: 21, sf: 79)
                .toTimecode(at: ._23_976, base: ._80SubFrames)
                .realTimeValue,
            _00_49_27_15_00 + _00_49_33_21_79_delta,
            accuracy: 0.0000005
        )
        
        // event4
        XCTAssertEqual(
            try TCC(h: 00, m: 49, s: 38, f: 01, sf: 79)
                .toTimecode(at: ._23_976, base: ._80SubFrames)
                .realTimeValue,
            _00_49_27_15_00 + _00_49_38_01_79_delta,
            accuracy: 0.0000005
        )
    }
    
    // MARK: - .toTimecode()
    
    func testTCC_toTimecode() throws {
        // toTimecode(rawValuesAt:)
        
        XCTAssertEqual(
            try TCC(h: 1, m: 5, s: 20, f: 14)
                .toTimecode(at: ._23_976),
            try Timecode(
                TCC(h: 1, m: 5, s: 20, f: 14),
                at: ._23_976
            )
        )
        
        // toTimecode(rawValuesAt:) with subframes
        
        let tcWithSubFrames = try TCC(h: 1, m: 5, s: 20, f: 14, sf: 94)
            .toTimecode(
                at: ._23_976,
                base: ._100SubFrames,
                format: [.showSubFrames]
            )
        XCTAssertEqual(
            tcWithSubFrames,
            try Timecode(
                TCC(h: 1, m: 5, s: 20, f: 14, sf: 94),
                at: ._23_976,
                base: ._100SubFrames,
                format: [.showSubFrames]
            )
        )
        XCTAssertEqual(
            tcWithSubFrames.stringValue,
            "01:05:20:14.94"
        )
    }
    
    func testTimeInterval_toTimeCode_at() throws {
        // toTimecode(at:)
        
        XCTAssertEqual(
            try TimeInterval(secInTC10Days_BaseFrameRates)
                .toTimecode(at: ._24, limit: ._100days)
                .components,
            TCC(d: 10)
        )
        
        // toTimecode(at:) with subframes
        
        let tcWithSubFrames = try TimeInterval(3600.0)
            .toTimecode(
                at: ._24,
                base: ._100SubFrames,
                format: [.showSubFrames]
            )
        XCTAssertEqual(
            tcWithSubFrames,
            try Timecode(
                TCC(h: 1),
                at: ._24,
                base: ._100SubFrames,
                format: [.showSubFrames]
            )
        )
        XCTAssertEqual(
            tcWithSubFrames.stringValue,
            "01:00:00:00.00"
        )
    }
}

#endif
