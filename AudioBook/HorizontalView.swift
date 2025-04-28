//
//  HorizontalView.swift
//  AudioBook
//
//  Created by Alok Kumar on 28/04/25.
//

import SwiftUI

struct HorizontalView: View {
    
    @StateObject var viewModel = AudioViewModel()
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(viewModel.asyncAudio, id: \.self) { audio in
                        VStack(alignment: .center) {
                            AsyncImage(url: audio.artworkUrl60, scale: 1) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                Image(systemName: "star")
                            }
                            .clipShape(.rect(cornerRadius: 12))
                            .frame(width: 150, height: 120)
                            .padding(.all, 10)
                            
                            Text(audio.artistName)
                                .padding(.vertical, 10)
                        }
                        .background(.gray.opacity(0.5))
                    }
                }
            }
            .padding(.top)
            
            Spacer()
        }
        .task {
            await viewModel.fetchAudioAsync()
        }
    }
}

#Preview {
    HorizontalView()
}
