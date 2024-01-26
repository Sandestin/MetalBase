//
//  Renderer.swift
//  MetalBase
//
//  Created by Jonathan Attfield on 26/01/2024.
//

import Foundation
import MetalKit
import simd

class Renderer : NSObject, MTKViewDelegate {
    let device : MTLDevice
    let commandQueue : MTLCommandQueue
    
    let renderPipelineState : MTLRenderPipelineState
    
    let vertices: [Float] = [
        0.0, 0.5, 0.0,
        -0.5, -0.5, 0.0,
        0.5, -0.5, 0.0
    ]
    
    var vertexBuffer : MTLBuffer
    var viewMatrix = matrix_identity_float4x4
    
    init(view: MTKView, device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()!
        
        let library = device.makeDefaultLibrary()!
        let vertexFn = library.makeFunction(name: "vertexShader")
        let fragmentFn = library.makeFunction(name: "fragmentShader")
     
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Float>.size, options: [])!
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFn
        pipelineDescriptor.fragmentFunction = fragmentFn
        pipelineDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = view.depthStencilPixelFormat
        pipelineDescriptor.rasterSampleCount = view.sampleCount
        do {
            try renderPipelineState = device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("Could not create render pipeline state: \(error)")
        }
        super.init()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // Empty
    }
    
    func draw(in view: MTKView) {
        guard
            let buffer = commandQueue.makeCommandBuffer(),
            let desc = view.currentRenderPassDescriptor,
            let renderEncoder = buffer.makeRenderCommandEncoder(descriptor: desc)
        else { return }
        
        renderEncoder.setRenderPipelineState(renderPipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        renderEncoder.endEncoding()
        
        if let drawable = view.currentDrawable {
            buffer.present(drawable)
        }
        buffer.commit()
    }
}

