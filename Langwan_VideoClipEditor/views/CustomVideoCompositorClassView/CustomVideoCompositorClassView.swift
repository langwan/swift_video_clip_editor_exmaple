//
//  PlayVideoFromComp.swift
//  Langwan_VideoClipEditor
//
//  Created by langwan on 2020/2/21.
//  Copyright © 2020 langwan. All rights reserved.
//

import SwiftUI
import AVFoundation
import AVKit

struct CustomVideoCompositorClassView : View {
    
    
    @State var playerView = PlayerView()
    var body: some View {
        VStack {
            playerView
            
            
        }.onAppear(perform: onLoad)
    }
    
    
    func onLoad() {
        let composition = AVMutableComposition()
        
        
        let path =  Bundle.main.path(forResource: "clip", ofType: "mp4")
        let assetA = AVURLAsset(url: URL(fileURLWithPath: path!))
        let assetTrackA = assetA.tracks(withMediaType: .video).first
        
        let stackA = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let assetTimeRange = CMTimeRangeMake(start: CMTime.zero, duration: assetA.duration)
        let startTime = CMTime.zero
        do {
            try stackA?.insertTimeRange(assetTimeRange, of: assetTrackA!, at: startTime)
        } catch {
            print(error.localizedDescription)
        }
        let videoComposition = AVMutableVideoComposition(propertiesOf: composition)
        videoComposition.customVideoCompositorClass = CustomVideoCompositor.self
        _ = CMTimeRangeMake(start: CMTimeMake(value: 30, timescale: 30), duration:  CMTimeMake(value: 30, timescale: 30))
        let instruction = VideoCompositionInstruction(timeRange:assetTimeRange)
        // instruction.timeRange = assetTimeRange
        videoComposition.instructions = [instruction]
        
        
        DispatchQueue.main.async {
            self.playerView.play(asset: composition, videoComposition:videoComposition)
        }
        
        
    }
}


struct CustomVideoCompositorClassView_Previews: PreviewProvider {
    static var previews: some View {
        CustomVideoCompositorClassView()
    }
}




