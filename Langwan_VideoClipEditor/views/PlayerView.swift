//
//  PlayerView.swift
//  Langwan_VideoClipEditor
//
//  Created by langwan on 2020/2/22.
//  Copyright © 2020 langwan. All rights reserved.
//

import UIKit
import SwiftUI
import AVFoundation
import AVKit

struct PlayerView: UIViewRepresentable {
    @State var playerUIView = PlayerUIView(frame: .zero)
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
    }
    
    func makeUIView(context: Context) -> UIView {
        
        return playerUIView
    }
    
    func play(asset:AVAsset) {
        playerUIView.play(asset: asset)
    }
    
    func getFrameSize() -> CGRect {
        return playerUIView.frame
    }
    
    func play(asset:AVAsset, videoComposition:AVMutableVideoComposition) {
        playerUIView.play(asset: asset, videoComposition:videoComposition)
    }
    
    func playAndSyncLayer(asset:AVAsset, videoComposition:AVMutableVideoComposition, syncLayer:AVSynchronizedLayer){
        playerUIView.playAndSyncLayer(asset: asset, videoComposition:videoComposition, syncLayer: syncLayer)
    }
}


class PlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    let player = AVPlayer()
    func play(asset:AVAsset) {
        
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        player.play()
        
        playerLayer.player = player
        layer.addSublayer(playerLayer)
    }
    
    func play(asset:AVAsset, videoComposition:AVMutableVideoComposition) {
        
        let playerItem = AVPlayerItem(asset: asset)
        playerItem.videoComposition = videoComposition
        
        
        playerLayer.player = player
        player.replaceCurrentItem(with: playerItem)
        
        player.play()
        
    }
    
    func playAndSyncLayer(asset:AVAsset, videoComposition:AVMutableVideoComposition, syncLayer:AVSynchronizedLayer) {
        
        let playerItem = AVPlayerItem(asset: asset)
        playerItem.videoComposition = videoComposition
        syncLayer.playerItem  = playerItem
        self.layer.addSublayer(syncLayer)
        //syncLayer.frame = self.layer.frame
        playerLayer.player = player
        player.replaceCurrentItem(with: playerItem)
        
        player.play()
        
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.addSublayer(playerLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
