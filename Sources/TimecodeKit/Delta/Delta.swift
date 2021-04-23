//
//  Delta.swift
//  TimecodeKit
//
//  Created by Steffan Andrews on 2021-04-23.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

import Foundation

extension Timecode {
	
	/// Represents an abstract delta between two `Timecode` structs.
	public struct Delta {
		
		let delta: Timecode
		let sign: Sign
		
		public init(_ delta: Timecode,
					_ sign: Sign = .positive) {
			
			self.delta = delta
			self.sign = sign
			
		}
		
		/// Returns true if sign is negative.
		public var isNegative: Bool {
			
			sign == .negative
			
		}
		
		/// Returns the delta value expressed as a concrete `Timecode` value by wrapping around lower/upper timecode limit bounds if necessary.
		public var timecode: Timecode {
			
			switch sign {
			case .positive:
				return delta.adding(wrapping: TCC())
				
			case .negative:
				return
					Timecode(
						TCC(f: 0),
						at: delta.frameRate,
						limit: delta.upperLimit,
						subFramesDivisor: delta.subFramesDivisor
					)!
					.subtracting(wrapping: delta.components)
			}
			
		}
		
		/// Returns a `Timecode` value offsetting it by the delta value, wrapping around lower/upper timecode limit bounds if necessary.
		public func timecode(offsetting base: Timecode) -> Timecode {
			
			base + timecode
			
		}
		
		/// Returns real time equivalent of the delta time.
		public var realTimeValue: TimeInterval {
			
			switch sign {
			case .positive:
				return delta.realTimeValue.seconds
				
			case .negative:
				return -delta.realTimeValue.seconds
			}
			
		}
		
	}
	
}

extension Timecode.Delta: CustomStringConvertible, CustomDebugStringConvertible {
	
	public var description: String {
		
		switch sign {
		case .positive: return delta.description
		case .negative: return "-\(delta.description)"
		}
		
	}
	
	public var debugDescription: String {
		
		switch sign {
		case .positive: return "Timecode.Delta(\(delta.description))"
		case .negative: return "Timecode.Delta(-\(delta.description))"
		}
		
	}
	
	public var verboseDescription: String {
		
		"Timecode Delta \(description) @ \(delta.frameRate.stringValue)"
		
	}
	
}

extension Timecode.Delta {
	
	public enum Sign {
		
		case positive
		case negative
		
	}
	
}
