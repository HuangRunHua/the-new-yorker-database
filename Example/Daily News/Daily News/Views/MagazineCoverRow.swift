//
//  MagazineCoverRow.swift
//  Daily News
//
//  Created by Huang Runhua on 2022/9/27.
//

import SwiftUI

struct MagazineCoverRow: View {
    
    var magazine: Magazine
    
    var coverImageURL: URL? {
        return URL(string: self.magazine.coverImageURL)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            AsyncImage(url: self.coverImageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom)
                case .empty, .failure:
                    Rectangle()
                        .aspectRatio(self.magazine.coverImageWidth/self.magazine.coverImageHeight, contentMode: .fit)
                        .foregroundColor(.secondary)
                @unknown default:
                    EmptyView()
                }
            }
            HStack {
                Text(self.magazine.date)
                    .font(Font.custom("Georgia", size: 15))
                    .foregroundColor(.gray)
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.secondary)
                }

            }
        }
    }
}

struct MagazineCoverRow_Previews: PreviewProvider {
    static var previews: some View {
        MagazineCoverRow(magazine: Magazine(id: "111111-1111-1111-111111111111", coverStory: "cover story", coverImageURL: "https://media.newyorker.com/photos/632de17e882c6ff52b2d3b1f/master/w_380,c_limit/2022_10_03.jpg", coverImageWidth: 555, coverImageHeight: 688, articles: [], date: "Oct 3rh 2022"))
    }
}
