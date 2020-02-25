//
//  PlayVideoFromComp.swift
//  Langwan_VideoClipEditor
//
//  Created by langwan on 2020/2/21.
//  Copyright © 2020 langwan. All rights reserved.
//

import SwiftUI
import AVFoundation

struct PlayVideoFromCompositionView : View {
    
    var composition = AVMutableComposition()
    @State var playerView = PlayerView()
    var body: some View {
        VStack {
            playerView
            
            
        }.onAppear(perform: onLoad)
    }
    
    
    func onLoad() {
        
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
        DispatchQueue.main.async {
            
            self.playerView.play(asset: self.composition)
        }
        
        
    }
}


struct PlayVideoFromCompositionView_Previews: PreviewProvider {
    static var previews: some View {
        PlayVideoFromCompositionView()
    }
}

