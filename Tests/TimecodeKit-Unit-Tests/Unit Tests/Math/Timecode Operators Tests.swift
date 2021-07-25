//
//  Timecode Operators Tests.swift
//  TimecodeUnitTests
//
//  Created by Steffan Andrews on 2020-06-16.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import TimecodeKit

class Timecode_UT_Operators_Tests: XCTestCase {
    
    override func setUp() { }
    override func tearDown() { }
    
    func testAdd_and_Subtract_Operators() {
        
        var tc = Timecode(at: ._30)
        
        // + and - operators
        
        tc =      TCC(h: 00, m: 00, s: 00, f: 00).toTimecode(at: ._30)!
        
        tc = tc + TCC(h: 00, m: 00, s: 00, f: 05).toTimecode(at: ._30)!
        XCTAssertEqual(tc.components, TCC(h: 00, m: 00, s: 00, f: 05))
        
        tc = tc - TCC(h: 00, m: 00, s: 00, f: 04).toTimecode(at: ._30)!
        XCTAssertEqual(tc.components, TCC(h: 00, m: 00, s: 00, f: 01))
        
        // (underflow: wraps)
        tc = tc - TCC(h: 00, m: 00, s: 00, f: 04).toTimecode(at: ._30)!
        XCTAssertEqual(tc.components, TCC(h: 23, m: 59, s: 59, f: 27))
        
        // (overflow: wraps)
        tc = tc + TCC(h: 00, m: 00, s: 00, f: 05).toTimecode(at: ._30)!
        XCTAssertEqual(tc.components, TCC(h: 00, m: 00, s: 00, f: 02))
        
        
        // += and -= operators
        
        tc =      TCC(h: 00, m: 00, s: 00, f: 00).toTimecode(at: ._30)!
        
        tc +=     TCC(h: 00, m: 00, s: 00, f: 05).toTimecode(at: ._30)!
        XCTAssertEqual(tc.components, TCC(h: 00, m: 00, s: 00, f: 05))
        
        tc -=     TCC(h: 00, m: 00, s: 00, f: 04).toTimecode(at: ._30)!
        XCTAssertEqual(tc.components, TCC(h: 00, m: 00, s: 00, f: 01))
        
        // (underflow: wraps)
        tc -=     TCC(h: 00, m: 00, s: 00, f: 04).toTimecode(at: ._30)!
        XCTAssertEqual(tc.components, TCC(h: 23, m: 59, s: 59, f: 27))
        
        // (overflow: wraps)
        tc +=     TCC(h: 00, m: 00, s: 00, f: 05).toTimecode(at: ._30)!
        XCTAssertEqual(tc.components, TCC(h: 00, m: 00, s: 00, f: 02))
        
    }
    
    func testMultiply_and_Divide_Operators() {
        
        var tc = Timecode(at: ._30)
        
        // * and / operators
        
        tc =      TCC(h: 01, m: 00, s: 00, f: 00).toTimecode(at: ._30)!
        
        tc = tc * 5
        XCTAssertEqual(tc.components, TCC(h: 05, m: 00, s: 00, f: 00))
        
        tc = tc / 5
        XCTAssertEqual(tc.components, TCC(h: 01, m: 00, s: 00, f: 00))
        
        // (overflow: wraps)
        tc = tc * 30 // == aka 30:00:00:00, 6 hours over 24:00:00:00
        XCTAssertEqual(tc.components, TCC(h: 06, m: 00, s: 00, f: 00))
        
        // (underflow: wraps)
        tc = tc * -2.5 // == aka -15:00:00:00, 15 hours under 24:00:00:00
        XCTAssertEqual(tc.components, TCC(h: 09, m: 00, s: 00, f: 00))
        
        // (underflow: wraps)
        tc = tc / -2 // == aka -4:30:00:00, 4 hours 30 min under 24:00:00:00
        XCTAssertEqual(tc.components, TCC(h: 19, m: 30, s: 00, f: 00))
        
        // += and -= operators
        
        tc =      TCC(h: 01, m: 00, s: 00, f: 00).toTimecode(at: ._30)!
        
        tc *=     5
        XCTAssertEqual(tc.components, TCC(h: 05, m: 00, s: 00, f: 00))
        
        tc /=     5
        XCTAssertEqual(tc.components, TCC(h: 01, m: 00, s: 00, f: 00))
        
        // (overflow: wraps)
        tc *=     30 // == aka 30:00:00:00, 6 hours over 24:00:00:00
        XCTAssertEqual(tc.components, TCC(h: 06, m: 00, s: 00, f: 00))
        
        // (underflow: wraps)
        tc *=     -2.5 // == aka -15:00:00:00, 15 hours under 24:00:00:00
        XCTAssertEqual(tc.components, TCC(h: 09, m: 00, s: 00, f: 00))
        
        // (underflow: wraps)
        tc /=     -2 // == aka -4:30:00:00, 4 hours 30 min under 24:00:00:00
        XCTAssertEqual(tc.components, TCC(h: 19, m: 30, s: 00, f: 00))
        
    }
    
}

#endif
