//
//  ArticleContentRow.swift
//  Daily News
//
//  Created by Huang Runhua on 2022/9/28.
//

import SwiftUI

struct ArticleContentRow: View {
    
    var currentArticle: Article
    
    var coverImageURL: URL? {
        return URL(string: self.currentArticle.coverImageURL)
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(currentArticle.hashTag.uppercased())
                        .font(Font.custom("Georgia", size: 15))
                        .foregroundColor(.hashtagColor)
                        .multilineTextAlignment(.leading)
                    
                    Text(currentArticle.title)
                        .font(Font.custom("Georgia", size: 20))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.defaultFontColor)
                }
                Spacer()
                AsyncImage(url: self.coverImageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 100)
                            .cornerRadius(7)
                    case .empty, .failure:
                        Rectangle()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 100)
                            .foregroundColor(.secondary)
                            .cornerRadius(7)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            Divider()
        }
    }
}

struct ArticleContentRow_Previews: PreviewProvider {
    static var previews: some View {
        ArticleContentRow(currentArticle: Article(
            title: "When Migrants Become Political Pawns Clothing", subtitle: "Governor DeSantis appeared to be attempting to troll people whose magnanimity, he seemed to believe, is inversely proportional to the extent to which a given problem has an impact on their own lives.", coverImageURL: "https://media.newyorker.com/photos/632e6d4211f4b55ac7d6eaf6/4:3/w_223,c_limit/comment-homepage.jpg", contents: [], coverImageWidth: 500, coverImageHeight: 500, hashTag: "Comment", authorName: "author name", coverImageDescription: "cover image description", publishDate: "publish date"))
    }
}
