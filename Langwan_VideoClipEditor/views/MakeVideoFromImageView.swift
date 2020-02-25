//
//  MakeVideoFromImage.swift
//  Langwan_VideoClipEditor
//
//  Created by langwan on 2020/2/22.
//  Copyright © 2020 langwan. All rights reserved.
//

import SwiftUI
import AVFoundation
import AssetsLibrary


struct MakeVideoFromImageView : View {
    var composition = AVMutableComposition()
    @State var playerView = PlayerView()
    var body: some View {
        VStack {
            playerView
            
            
        }.onAppear(perform: onLoad)
    }
    
    func onLoad() {
        
        let stack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        composition.naturalSize = CGSize(width: 1920, height: 1080)
        
        
        let image = UIImage(named: "image")
        
        let makeVideo = MakeVideoFromImage()
        makeVideo.make(image: image!) { (url) in
            let asset = AVURLAsset(url: url)
            
            let assetTrack = asset.tracks(withMediaType: .video).first
            
            
            let endTime = CMTimeMakeWithSeconds(2.0, preferredTimescale: 30)
            let frameTime = CMTimeMake(value: 1, timescale: 30)
            let assetTimeRange = CMTimeRangeMake(start: CMTime.zero, duration:frameTime)
            var startTime = CMTime.zero
            do {
                while startTime < endTime {
                    try stack?.insertTimeRange(assetTimeRange, of: assetTrack!, at: startTime)
                    startTime = CMTimeAdd(startTime, frameTime)
                }
            } catch {
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                print("asset.duration", asset.duration)
                self.playerView.play(asset: self.composition)
                
                
                
            }
        }
        
        
        
        
    }
}



struct MakeVideoFromImageView_Previews: PreviewProvider {
    static var previews: some View {
        MakeVideoFromImageView()
    }
}
