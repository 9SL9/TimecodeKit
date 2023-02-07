//
//  AVFoundation Utils.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if canImport(AVFoundation) && !os(watchOS)

import Foundation
import AVFoundation

extension CMFormatDescription {
    /// Returns extensions as a dictionary.
    ///
    /// Extensions dictionaries are valid property list objects.
    /// This means that dictionary keys are all CFStrings, and the values are all either CFNumber, CFString, CFBoolean, CFArray, CFDictionary, CFDate, or CFData
    ///
    /// You can subscript the dictionary using global AVFoundation key constants beginning with `kCMFormatDescriptionExtension_`
    internal var extensionsDictionary: [CFString: Any] {
        let nsDict = CMFormatDescriptionGetExtensions(self) as NSDictionary?
        let dict = nsDict as? [CFString: Any]
        return dict ?? [:]
    }
}

#endif
