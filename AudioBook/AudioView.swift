//
//  AudioView.swift
//  AudioBook
//
//  Created by Alok Kumar on 27/04/25.
//

import SwiftUI

struct AudioView: View {
    var url: URL?
    var artistName: String
    var width: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .aspectRatio(16/9, contentMode: .fit)
                    .clipped()
            } placeholder: {
                Image(systemName: "star")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .aspectRatio(16/9, contentMode: .fit)
                    .foregroundColor(.gray)
            }
            .background()
            
            Text(artistName)
                .font(.system(size: 20, weight: .bold))
                .padding(8)
        }
        .frame(width: width)
        .background(.gray.opacity(0.5))
    }
}

#Preview {
    AudioView(url: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Video6/v4/2c/e7/02/2ce702f4-70f9-f24d-08a3-30971aa3c908/mzl.gjkskwdd.lsr/100x100bb.jpg"), artistName: "Alok", width: 320)
}
