//
//  PlayVideoFromComp.swift
//  Langwan_VideoClipEditor
//
//  Created by langwan on 2020/2/21.
//  Copyright © 2020 langwan. All rights reserved.
//

import SwiftUI
import AVFoundation

struct AnimationToolView : View {
    
    var composition = AVMutableComposition()
    @State var playerView = PlayerView()
    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                
                self.playerView
                    .frame(width: geometry.size.width, height: geometry.size.width / 3 * 2, alignment: .center)
                    .background(Color.red)
                
            }.onAppear(perform: self.onLoad)
            
        }
    }
    
    
    func onLoad() {
        
        let stack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        guard let path =  Bundle.main.path(forResource: "clip", ofType: "mp4") else {
            print("clip is not find.")
            return
        }
        
        let asset = AVURLAsset(url: URL(fileURLWithPath: path))
        
        
        
        let assetTrack = asset.tracks(withMediaType: .video).first
        
        print("asset size", assetTrack?.naturalSize)
        
        let assetTimeRange = CMTimeRangeMake(start: CMTime.zero, duration: asset.duration)
        let startTime = CMTime.zero
        do {
            try stack?.insertTimeRange(assetTimeRange, of: assetTrack!, at: startTime)
        } catch {
            print(error.localizedDescription)
        }
        
        
        let textLayer = CATextLayer()
        
        textLayer.backgroundColor = UIColor.blue.cgColor
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.string = "T E S T"
        textLayer.font = UIFont(name: "Arial", size: 18)
        textLayer.shadowOpacity = 0.5
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        textLayer.shouldRasterize = true
        // textLayer.rasterizationScale = showInBounds.width / videoTrack.naturalSize.width
        
        let parentLayer = CALayer()
        
        let syncLayer = AVSynchronizedLayer()
        syncLayer.addSublayer(textLayer)
        
        
        let videoComposition = AVMutableVideoComposition(propertiesOf: composition)
        //videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(additionalLayer: textLayer, asTrackID: kCMPersistentTrackID_Invalid)
        
        
        
        DispatchQueue.main.async {
            
            self.playerView.playAndSyncLayer(asset: self.composition, videoComposition: videoComposition, syncLayer: syncLayer)
        }
        
        
    }
}

