//
//  ContentView.swift
//  Langwan_VideoClipEditor
//
//  Created by langwan on 2020/2/21.
//  Copyright © 2020 langwan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            
            NavigationView {
                List {
                    Section {
                        NavigationLink(destination: PlayVideoFromCompositionView()) {
                            Text("Play Video From Composition")
                        }
                        
                        NavigationLink(destination: MakeVideoFromImageView()) {
                            Text("Make AVAsset From UIImage")
                        }
                        
                        NavigationLink(destination: TransitionView()) {
                            Text("Transition")
                        }
                        
                        NavigationLink(destination: AdvancedTransitionView()) {
                            Text("Advanced Transition")
                        }
                        
                        NavigationLink(destination: CustomVideoCompositorClassView()) {
                            Text("Custom Video Compositor Class + Effect + Transform")
                        }
                        
                        NavigationLink(destination: AnimationToolView()) {
                            Text("AnimationToolView")
                        }
                        
                        NavigationLink(destination: AVAsynchronousCIImageFilteringRequestView()) {
                            Text("AVAsynchronousCIImageFilteringRequest")
                        }
                    }
                }.navigationBarTitle("Video Clip Editor")
                    .navigationBarHidden(false)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
