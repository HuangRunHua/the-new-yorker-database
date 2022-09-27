//
//  ContentView.swift
//  Daily News
//
//  Created by Huang Runhua on 2022/9/26.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var modelData: ModelData
    
    @State var translateText: String?
    
    var currentArticle: Article {
        return modelData.article
    }
    
    var coverImageURL: URL? {
        return URL(string: self.currentArticle.coverImageURL)
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading, spacing: 7) {
                    Text(self.currentArticle.hashTag.uppercased())
                        .font(Font.custom("Georgia", size: 15))
                        .foregroundColor(.red)
                        .textSelection(.enabled)
                    Text(self.currentArticle.title)
                        .font(Font.custom("Georgia", size: 30))
                        .textSelection(.enabled)
                }
                Text(self.currentArticle.subtitle)
                    .font(Font.custom("Georgia", size: 20))
                    .textSelection(.enabled)
            }
            .padding()
            
            Divider()
            
            HStack {
                Text("By " + self.currentArticle.authorName)
                    .font(Font.custom("Georgia", size: 15))
                    .foregroundColor(.gray)
                    .textSelection(.enabled)
                Text("·")
                Text(self.currentArticle.publishDate)
                    .font(Font.custom("Georgia", size: 15))
                    .foregroundColor(.gray)
                    .textSelection(.enabled)
                Spacer()
            }
            .padding([.leading, .trailing, .top])
            .padding(.bottom, 25)
            
            VStack {
                AsyncImage(url: self.coverImageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.bottom)
                    case .empty, .failure:
                        Rectangle()
                            .aspectRatio(self.currentArticle.coverImageWidth/self.currentArticle.coverImageHeight, contentMode: .fit)
                            .foregroundColor(.secondary)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                Text(self.currentArticle.coverImageDescription)
                    .font(Font.custom("Georgia", size: 15))
                    .foregroundColor(.gray)
                    .padding([.bottom])
                    .padding([.leading, .trailing], 7)
            }
            
            ForEach(self.currentArticle.contents) { content in
                VStack(alignment: .leading) {
                    self.transmitToView(content)
                }
            }
            .padding([.leading, .trailing])
            .padding(.bottom, 12)
        }
        .translateSheet($translateText)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}

extension ContentView {
    @ViewBuilder
    private func transmitToView(_ content: Content) -> some View {
        switch content.contentRole {
        case .quote:
            HStack {
                Text(content.text ?? "")
                    .font(Font.custom("Georgia", size: 17))
                    .foregroundColor(.gray)
                    .padding([.leading, .trailing])
                    .multilineTextAlignment(.leading)
                    .textSelection(.enabled)
                    .lineSpacing(7)
                    .contextMenu(ContextMenu(menuItems: {
                        Button("Translate", action: {
                            self.translateText = content.text ?? ""
                        })
                    }))
                    
                Spacer()
            }
            
        case .body:
            HStack {
                Text(content.text ?? "")
                    .font(Font.custom("Georgia", size: 17))
                    .textSelection(.enabled)
                    .lineSpacing(7)
                    .contextMenu(ContextMenu(menuItems: {
                        Button("Translate", action: {
                            self.translateText = content.text ?? ""
                        })
                    }))
                Spacer()
            }
        case .image:
            AsyncImage(url: URL(string: content.imageURL ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .empty, .failure:
                    Rectangle()
                        .aspectRatio((content.imageWidth ?? 1)/(content.imageHeight  ?? 1), contentMode: .fit)
                        .foregroundColor(.secondary)
                        .ignoresSafeArea()
                @unknown default:
                    EmptyView()
                }
            }
        }
    }
}
