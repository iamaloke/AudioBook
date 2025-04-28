//
//  ContentView.swift
//  AudioBook
//
//  Created by Alok Kumar on 27/04/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = AudioViewModel()
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        ForEach(viewModel.audios, id: \.self) { audio in
                            AudioView(url: audio.artworkUrl100, artistName: audio.artistName,width: geo.size.width * 0.9)
                                .background(.blue)
                        }
                    }
                }
                .padding(.top)
            }
            .onAppear {
                viewModel.fetchAudio()
            }
        }
    }
}

#Preview {
    ContentView()
}
