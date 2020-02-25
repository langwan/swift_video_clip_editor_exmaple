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

struct AdvancedTransitionView : View {
    
    
    @State var playerView = PlayerView()
    var body: some View {
        VStack {
            playerView
            
            
        }.onAppear(perform: onLoad)
    }
    
    
    func onLoad() {
        let composition = AVMutableComposition()
        
        
        var path =  Bundle.main.path(forResource: "clip", ofType: "mp4")
        let assetA = AVURLAsset(url: URL(fileURLWithPath: path!))
        let assetTrackA = assetA.tracks(withMediaType: .video).first
        
        let stackA = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        var assetTimeRange = CMTimeRangeMake(start: CMTime.zero, duration: assetA.duration)
        var startTime = CMTime.zero
        do {
            try stackA?.insertTimeRange(assetTimeRange, of: assetTrackA!, at: startTime)
        } catch {
            print(error.localizedDescription)
        }
        
        
        
        path =  Bundle.main.path(forResource: "clip2", ofType: "mp4")
        let assetB = AVURLAsset(url: URL(fileURLWithPath: path!))
        let assetTrackB = assetB.tracks(withMediaType: .video).first
        
        let stackB = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        assetTimeRange = CMTimeRangeMake(start: CMTime.zero, duration: assetB.duration)
        startTime = CMTimeMake(value: 60, timescale: 30)
        do {
            try stackB?.insertTimeRange(assetTimeRange, of: assetTrackB!, at: startTime)
        } catch {
            print(error.localizedDescription)
        }
        
        
        
        let videoComposition = AVMutableVideoComposition(propertiesOf: composition)
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        videoComposition.renderSize = composition.naturalSize
        print("videoComposition.instructions", videoComposition.instructions.count)
        
        let instructions = videoComposition.instructions as! [AVMutableVideoCompositionInstruction]
        
        for instruction in instructions {
            if instruction.layerInstructions.count < 2 {
                continue
            }
            
            var layerA = instruction.layerInstructions.first as! AVMutableVideoCompositionLayerInstruction
            
            
            
            
            let layerB = instruction.layerInstructions.last as! AVMutableVideoCompositionLayerInstruction
            
            let fromEndTranform = CGAffineTransform(translationX: composition.naturalSize.width, y: 0)
            let toStartTranform = CGAffineTransform(translationX: -composition.naturalSize.width, y: 0)
            let range = CMTimeRangeMake(start: instruction.timeRange.start, duration: CMTimeMake(value: 60, timescale: 30))
            
            let identityTransform = CGAffineTransform.identity
            
            layerB.setTransformRamp(fromStart: fromEndTranform, toEnd: identityTransform, timeRange: range)
            layerA.setTransformRamp(fromStart: identityTransform, toEnd: toStartTranform, timeRange: range)
            layerA.setOpacityRamp(fromStartOpacity: 1.0, toEndOpacity: 0.0, timeRange: range)
            //            instruction.layerInstructions = [layerA, layerB]
            //
            
        }
        
        //
        //        let instruction =  AVMutableVideoCompositionInstruction()
        //        instruction.timeRange =
        //
        //
        //        videoComposition.instructions.append(instruction)
        //        //instruction.layerInstructions = [layerA, layerB]
        
        DispatchQueue.main.async {
            
            
            self.playerView.play(asset: composition, videoComposition:videoComposition)
        }
        
        
    }
}


struct AdvancedTransitionView_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedTransitionView()
    }
}



