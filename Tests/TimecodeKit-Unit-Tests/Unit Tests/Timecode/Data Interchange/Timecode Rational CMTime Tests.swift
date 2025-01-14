//
//  Timecode Rational CMTime Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit
import CoreMedia

class Timecode_Rational_CMTime_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_init_CMTime_Exactly() throws {
        try TimecodeFrameRate.allCases.forEach {
            let tc = try Timecode(
                CMTime(value: 10, timescale: 1),
                at: $0,
                limit: ._24hours
            )
            
            // don't imperatively check each result, just make sure that a value was set;
            // setter logic is unit-tested elsewhere, we just want to check the Timecode.init interface here.
            XCTAssertNotEqual(tc.seconds, 0, "for \($0)")
        }
    }
    
    func testTimecode_init_CMTime() throws {
        // these rational fractions and timecodes are taken from actual FCP XML files as known truth
        
        try TimecodeFrameRate.allCases.forEach { fRate in
            switch fRate {
            case ._23_976:
                XCTAssertEqual(
                    try Timecode(CMTime(value: 335335, timescale: 24000), at: fRate).components,
                    TCC(h: 00, m: 00, s: 13, f: 23)
                )
            case ._24:
                XCTAssertEqual(
                    try Timecode(CMTime(value: 167500, timescale: 12000), at: fRate).components,
                    TCC(h: 00, m: 00, s: 13, f: 23)
                )
            case ._24_98:
                break // TODO: finish this
            case ._25: // same fraction is found in FCP XML for 25p and 25i video rates
                XCTAssertEqual(
                    try Timecode(CMTime(value: 34900, timescale: 2500), at: fRate).components,
                    TCC(h: 00, m: 00, s: 13, f: 24)
                )
            case ._29_97: // same fraction is found in FCP XML for 29.97p and 29.97i video rates
                XCTAssertEqual(
                    try Timecode(CMTime(value: 838838, timescale: 60000), at: fRate).components,
                    TCC(h: 00, m: 00, s: 13, f: 29)
                )
                XCTAssertEqual(
                    try Timecode(CMTime(value: 1920919, timescale: 30000), at: fRate).components,
                    TCC(h: 00, m: 01, s: 03, f: 29)
                )
            case ._29_97_drop:
                XCTAssertEqual(
                    try Timecode(CMTime(value: 419419, timescale: 30000), at: fRate).components,
                    TCC(h: 00, m: 00, s: 13, f: 29)
                )
                XCTAssertEqual(
                    try Timecode(CMTime(value: 1918917, timescale: 30000), at: fRate).components,
                    TCC(h: 00, m: 01, s: 03, f: 29)
                )
            case ._30:
                XCTAssertEqual(
                    try Timecode(CMTime(value: 83800, timescale: 6000), at: fRate).components,
                    TCC(h: 00, m: 00, s: 13, f: 29)
                )
            case ._30_drop:
                break // TODO: finish this
            case ._47_952:
                break // TODO: finish this
            case ._48:
                break // TODO: finish this
            case ._50:
                XCTAssertEqual(
                    try Timecode(CMTime(value: 69900, timescale: 5000), at: fRate).components,
                    TCC(h: 00, m: 00, s: 13, f: 49)
                )
            case ._59_94:
                XCTAssertEqual(
                    try Timecode(CMTime(value: 839839, timescale: 60000), at: fRate).components,
                    TCC(h: 00, m: 00, s: 13, f: 59)
                )
            case ._59_94_drop:
                break // TODO: finish this
            case ._60:
                XCTAssertEqual(
                    try Timecode(CMTime(value: 83900, timescale: 6000), at: fRate).components,
                    TCC(h: 00, m: 00, s: 13, f: 59)
                )
            case ._60_drop:
                break // TODO: finish this
            case ._100:
                break // TODO: finish this
            case ._119_88:
                break // TODO: finish this
            case ._119_88_drop:
                break // TODO: finish this
            case ._120:
                break // TODO: finish this
            case ._120_drop:
                break // TODO: finish this
            }
        }
    }
    
    func testTimecode_init_CMTime_Clamping() {
        let tc = Timecode(
            clamping: CMTime(value: 86400 + 3600, timescale: 1), // 25 hours @ 24fps
            at: ._24,
            limit: ._24hours
        )
        
        XCTAssertEqual(
            tc.components,
            TCC(h: 23, m: 59, s: 59, f: 23, sf: tc.subFramesBase.rawValue - 1)
        )
    }
    
    func testTimecode_init_CMTime_Wrapping() {
        let tc = Timecode(
            wrapping: CMTime(value: 86400 + 3600, timescale: 1), // 25 hours @ 24fps
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
    
    func testTimecode_init_CMTime_RawValues() {
        let tc = Timecode(
            rawValues: CMTime(value: (86400 * 2) + 3600, timescale: 1), // 2 days + 1 hour @ 24fps
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
    
    func testTimecode_cmTime() throws {
        // test a small range of timecodes at each frame rate
        // and ensure the fraction can re-form the same timecode
        try TimecodeFrameRate.allCases.forEach { fRate in
            let s = try TCC(m: 8, f: 20).toTimecode(at: fRate)
            let e = try TCC(m: 10, f: 5).toTimecode(at: fRate)

            try (s ... e).forEach { tc in
                let f = tc.cmTime
                let reformedTC = try Timecode(f, at: fRate)
                XCTAssertEqual(tc, reformedTC)
            }
        }
    }
    
    func testTimecode_cmTime_SpotCheck() throws {
        let tc = try TCC(h: 00, m: 00, s: 13, f: 29).toTimecode(at: ._29_97_drop)
        XCTAssertEqual(tc.cmTime.value, 419419)
        XCTAssertEqual(tc.cmTime.timescale, 30000)
    }
    
    func testCMTime_toTimecode() throws {
        XCTAssertEqual(
            try CMTime(value: 3600, timescale: 1).toTimecode(at: ._24).components,
            TCC(h: 1)
        )
    }
}

#endif
