//
//  BaseShader.metal
//  MetalBase
//
//  Created by Jonathan Attfield on 26/01/2024.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 vertexShader(uint vertexID [[vertex_id]]) {
    float3 vertices[3] = {
        float3(0.0, 0.5, 0.0),
        float3(-0.5, -0.5, 0.0),
        float3(0.5, -0.5, 0.0)
    };
    
    float3 position = vertices[vertexID];
    return float4(position, 1.0);
}

fragment half4 fragmentShader() {
    half4 triangleColour = half4(1.0, 0.0, 0.0, 1.0);
    return triangleColour;
}
