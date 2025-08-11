//
//  ContentView.swift
//  PhotoPrompter
//
//  Created by Talmage Gaisford on 8/8/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DualCameraView()
                .tabItem {
                    Image(systemName: "camera.fill")
                    Text("Camera")
                }
            GalleryView()
                .tabItem {
                    Image(systemName: "photo.on.rectangle")
                    Text("Gallery")
                }
        }
    }
}

#Preview {
    ContentView()
}
