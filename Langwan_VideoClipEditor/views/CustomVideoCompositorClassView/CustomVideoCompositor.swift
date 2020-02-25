//
//  CustomVideoCompositor.swift
//  Langwan_VideoClipEditor
//
//  Created by langwan on 2020/2/23.
//  Copyright © 2020 langwan. All rights reserved.
//

import AVFoundation
import CoreImage

class CustomVideoCompositor : NSObject, AVVideoCompositing {
    private let queue = DispatchQueue(label: "com.langwan.videoclipeditor.Langwan-VideoClipEditor.render", qos: .default)
    private var renderContext: AVVideoCompositionRenderContext = AVVideoCompositionRenderContext()
    
    private let colorSpace = CGColorSpaceCreateDeviceRGB()
    private let ciContext: CIContext = {
        if let eaglContext = EAGLContext(api: .openGLES3) ?? EAGLContext(api: .openGLES2) {
            return CIContext(eaglContext: eaglContext)
        }
        return CIContext()
    }()
    
    private static let pixelFormat = kCVPixelFormatType_32BGRA
    
    let sourcePixelBufferAttributes: [String : Any]? = [
        kCVPixelBufferPixelFormatTypeKey as String : NSNumber(value: CustomVideoCompositor.pixelFormat),
        kCVPixelBufferOpenGLESCompatibilityKey as String : NSNumber(value: true),
    ]
    
    let requiredPixelBufferAttributesForRenderContext: [String : Any] = [
        kCVPixelBufferPixelFormatTypeKey as String : NSNumber(value: CustomVideoCompositor.pixelFormat),
        kCVPixelBufferOpenGLESCompatibilityKey as String : NSNumber(value: true),
    ]
    
    
    func renderContextChanged(_ newRenderContext: AVVideoCompositionRenderContext) {
        renderContext = newRenderContext
    }
    
    func startRequest(_ request: AVAsynchronousVideoCompositionRequest) {
        // print("startRequest")
        autoreleasepool {
            queue.async {
                
                guard let instruction = request.videoCompositionInstruction as? VideoCompositionInstruction else {
                    print("instruction is not VideoCompositionInstruction")
                    return
                }
                
                let frameBuffer = self.renderFrame(forRequest: request)
                request.finish(withComposedVideoFrame: frameBuffer)
            }
        }
    }
    
    
    private func renderFrame(forRequest request: AVAsynchronousVideoCompositionRequest) -> CVPixelBuffer {
        //print("renderFrame")
        
        let stackId = request.sourceTrackIDs[0]
        guard let frameBuffer = request.sourceFrame(byTrackID: CMPersistentTrackID(stackId)) else {
            let blankBuffer = self.renderContext.newPixelBuffer()
            return blankBuffer!
            
        }
        
        let sourceImage = CIImage(cvPixelBuffer: frameBuffer)
        
        //let filter = CIFilter(name: "CIPhotoEffectProcess")!
        let w = CVPixelBufferGetWidth(frameBuffer)
        let transform = CGAffineTransform(translationX: CGFloat(w / 2), y: 0)
        
        let outputImage = sourceImage.applyingFilter("CIPhotoEffectProcess").transformed(by: transform)
        
        let renderedBuffer = renderContext.newPixelBuffer()
        ciContext.render(outputImage, to: renderedBuffer!, bounds: outputImage.extent, colorSpace: self.colorSpace)
        return renderedBuffer!
    }
    
}
