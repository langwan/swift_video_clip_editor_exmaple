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

struct TransitionView : View {
    
   
    @State var playerView = PlayerView()
    var body: some View {
        VStack {
            playerView
            
            
        }.onAppear(perform: onLoad)
    }
    
    
    func onLoad() {
         let composition = AVMutableComposition()
        let stack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        guard let path =  Bundle.main.path(forResource: "clip", ofType: "mp4") else {
            print("clip is not find.")
            return
        }
        
        let asset = AVURLAsset(url: URL(fileURLWithPath: path))
        
        let assetTrack = asset.tracks(withMediaType: .video).first
        
        let assetTimeRange = CMTimeRangeMake(start: CMTime.zero, duration: asset.duration)
        let startTime = CMTime.zero
        do {
            try stack?.insertTimeRange(assetTimeRange, of: assetTrack!, at: startTime)
        } catch {
            print(error.localizedDescription)
        }
        
        let videoComposition = AVMutableVideoComposition(propertiesOf: composition)
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        videoComposition.renderSize = composition.naturalSize
        print("videoComposition.instructions", videoComposition.instructions.count)
        
        let instruction = videoComposition.instructions.first as! AVMutableVideoCompositionInstruction
        
       // print("videoComposition.instruction", instruction)
        var layer = instruction.layerInstructions.first as! AVMutableVideoCompositionLayerInstruction
        
        let range = CMTimeRangeMake(start: CMTime.zero, duration: CMTimeMake(value: 30, timescale: 30))
        
        layer.setOpacityRamp(fromStartOpacity: 1.0, toEndOpacity: 0.0, timeRange: range)
        
        DispatchQueue.main.async {
            

          self.playerView.play(asset: composition, videoComposition:videoComposition)
        }
        
        
    }
}


struct TransitionView_Previews: PreviewProvider {
    static var previews: some View {
        TransitionView()
    }
}

