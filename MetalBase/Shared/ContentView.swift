//
//  ContentView.swift
//  MetalBase
//
//  Created by Jonathan Attfield on 25/01/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            SwiftUIView {
                MetalView()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
