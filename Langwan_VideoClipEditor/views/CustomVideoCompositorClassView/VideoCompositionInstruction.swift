//
//  VideoCompositionInstruction.swift
//  Langwan_VideoClipEditor
//
//  Created by langwan on 2020/2/23.
//  Copyright © 2020 langwan. All rights reserved.
//

import Foundation
import AVFoundation

final class VideoCompositionInstruction: NSObject, AVVideoCompositionInstructionProtocol {
    
    var timeRange: CMTimeRange
    
    let enablePostProcessing: Bool = true
    let containsTweening: Bool = false
    
    var requiredSourceTrackIDs: [NSValue]?
    
    var passthroughTrackID: CMPersistentTrackID = kCMPersistentTrackID_Invalid
    
    lazy var transform:CGAffineTransform! = {
        let obj = CGAffineTransform()
        return obj
    }()
    
    init(timeRange: CMTimeRange) {
        self.timeRange = timeRange
        super.init()
    }
    
}
