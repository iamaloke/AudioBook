//
//  VerticalListView.swift
//  AudioBook
//
//  Created by Alok Kumar on 28/04/25.
//

import SwiftUI

struct VerticalListView: View {
    
    @StateObject var viewModel = AudioViewModel()
    
    var body: some View {
        VStack {
            List(viewModel.callbackAudio, id: \.self) { audio in
                HStack(alignment: .top) {
                    AsyncImage(url: audio.artworkUrl60, scale: 1) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Image(systemName: "star")
                    }
                    .frame(width: 100)
                    
                    Text(audio.artistName)
                }
            }
        }
        .onAppear {
            viewModel.fetchAudioCallback()
        }
    }
}

#Preview {
    VerticalListView()
}
