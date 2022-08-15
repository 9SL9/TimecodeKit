//
//  Timecode FrameCount Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class Timecode_UT_DI_FrameCount_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testAllFrameRates_ElapsedFrames() {
        // duration of 24 hours elapsed, rolling over to 1 day
        
        // also helps ensure Strideable .distance(to:) returns the correct values
        
        Timecode.FrameRate.allCases.forEach {
            // max frames in 24 hours
            
            var maxFramesIn24hours: Int
            
            switch $0 {
            case ._23_976: maxFramesIn24hours = 2_073_600
            case ._24: maxFramesIn24hours = 2_073_600
            case ._24_98: maxFramesIn24hours = 2_160_000
            case ._25: maxFramesIn24hours = 2_160_000
            case ._29_97: maxFramesIn24hours = 2_592_000
            case ._29_97_drop: maxFramesIn24hours = 2_589_408
            case ._30: maxFramesIn24hours = 2_592_000
            case ._30_drop: maxFramesIn24hours = 2_589_408
            case ._47_952: maxFramesIn24hours = 4_147_200
            case ._48: maxFramesIn24hours = 4_147_200
            case ._50: maxFramesIn24hours = 4_320_000
            case ._59_94: maxFramesIn24hours = 5_184_000
            case ._59_94_drop: maxFramesIn24hours = 5_178_816
            case ._60: maxFramesIn24hours = 5_184_000
            case ._60_drop: maxFramesIn24hours = 5_178_816
            case ._100: maxFramesIn24hours = 8_640_000
            case ._119_88: maxFramesIn24hours = 10_368_000
            case ._119_88_drop: maxFramesIn24hours = 10_357_632
            case ._120: maxFramesIn24hours = 10_368_000
            case ._120_drop: maxFramesIn24hours = 10_357_632
            }
            
            XCTAssertEqual(
                $0.maxTotalFrames(in: ._24hours),
                maxFramesIn24hours,
                "for \($0)"
            )
        }
        
        // number of total elapsed frames in (24 hours - 1 frame), or essentially the maximum timecode expressible for each frame rate
        
        Timecode.FrameRate.allCases.forEach {
            // max frames in 24 hours - 1
            
            var maxFramesExpressibleIn24hours: Int
            
            switch $0 {
            case ._23_976: maxFramesExpressibleIn24hours = 2_073_600 - 1
            case ._24: maxFramesExpressibleIn24hours = 2_073_600 - 1
            case ._24_98: maxFramesExpressibleIn24hours = 2_160_000 - 1
            case ._25: maxFramesExpressibleIn24hours = 2_160_000 - 1
            case ._29_97: maxFramesExpressibleIn24hours = 2_592_000 - 1
            case ._29_97_drop: maxFramesExpressibleIn24hours = 2_589_408 - 1
            case ._30: maxFramesExpressibleIn24hours = 2_592_000 - 1
            case ._30_drop: maxFramesExpressibleIn24hours = 2_589_408 - 1
            case ._47_952: maxFramesExpressibleIn24hours = 4_147_200 - 1
            case ._48: maxFramesExpressibleIn24hours = 4_147_200 - 1
            case ._50: maxFramesExpressibleIn24hours = 4_320_000 - 1
            case ._59_94: maxFramesExpressibleIn24hours = 5_184_000 - 1
            case ._59_94_drop: maxFramesExpressibleIn24hours = 5_178_816 - 1
            case ._60: maxFramesExpressibleIn24hours = 5_184_000 - 1
            case ._60_drop: maxFramesExpressibleIn24hours = 5_178_816 - 1
            case ._100: maxFramesExpressibleIn24hours = 8_640_000 - 1
            case ._119_88: maxFramesExpressibleIn24hours = 10_368_000 - 1
            case ._119_88_drop: maxFramesExpressibleIn24hours = 10_357_632 - 1
            case ._120: maxFramesExpressibleIn24hours = 10_368_000 - 1
            case ._120_drop: maxFramesExpressibleIn24hours = 10_357_632 - 1
            }
            
            XCTAssertEqual(
                $0.maxTotalFramesExpressible(in: ._24hours),
                maxFramesExpressibleIn24hours,
                "for \($0)"
            )
        }
    }
    
    func testSetTimecodeExactly() throws {
        // this is not meant to test the underlying logic, simply that .setTimecode produces the intended outcome
        
        var tc = Timecode(at: ._30)
        
        try tc.setTimecode(exactly: .frames(670_907))
        
        XCTAssertEqual(tc.days, 0)
        XCTAssertEqual(tc.hours, 6)
        XCTAssertEqual(tc.minutes, 12)
        XCTAssertEqual(tc.seconds, 43)
        XCTAssertEqual(tc.frames, 17)
        XCTAssertEqual(tc.subFrames, 0)
    }
    
    func testStatic_componentsFromFrameCount_2997d() {
        // edge cases
        
        let totalFramesin24Hr = 2_589_408
        // let totalSubFramesin24Hr = 207152640
        
        let tcc = Timecode.components(
            from: .init(
                .split(frames: totalFramesin24Hr - 1, subFrames: 79),
                base: ._80SubFrames
            ),
            at: ._29_97_drop
        )
        
        XCTAssertEqual(tcc, TCC(d: 0, h: 23, m: 59, s: 59, f: 29, sf: 79))
    }
}

#endif
