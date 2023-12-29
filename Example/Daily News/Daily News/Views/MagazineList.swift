//
//  MagazineList.swift
//  Daily News
//
//  Created by Huang Runhua on 2022/9/27.
//

import SwiftUI

struct MagazineList: View {
    private let dailyArticlesJSONURL: String = "https://github.com/HuangRunHua/the-new-yorker-database/raw/main/database/daily-articles.json"
    
    @EnvironmentObject var dailyArticleModelData: DailyArticleModelData
    
    @Environment(\.colorScheme) var colorScheme
    
    var dailyArticleMagazineURL: [LatestMagazineURL] {
        return dailyArticleModelData.latestMagazineURL
    }
    
    var body: some View {
        self.magazineList
    }
}

struct MagazineList_Previews: PreviewProvider {
    static var previews: some View {
        MagazineList()
            .environmentObject(DailyArticleModelData())
    }
}

extension MagazineList {
    private var magazineList: some View {
        self.dailyArticles
    }
    
    @ViewBuilder
    private var dailyArticles: some View {
        NavigationView {
            if self.dailyArticleModelData.latestArticles.isEmpty {
                VStack(spacing: 0) {
                    Spacer()
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    Spacer()
                }
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack(spacing: 0) {
                            Text("Headlines")
                                .font(Font.custom("Georgia", size: 20))
                        }
                    }
                }
                
            } else {
                VStack(spacing: 0) {
                    ScrollView(showsIndicators: true) {
                        Divider()
                        VStack {
                            ForEach(self.dailyArticleModelData.latestArticles) { article in
                                NavigationLink {
                                    ArticleView(currentArticle: article)
                                        .environmentObject(dailyArticleModelData)
                                } label: {
                                    ArticlePeekView(currentArticle: article)
                                }
                            }
                        }
                        .padding(.bottom)
                    }
                    .refreshable {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            self.dailyArticleModelData.fetchLatestMagazine()
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack(spacing: 0) {
                            Text("Headlines")
                                .font(Font.custom("Georgia", size: 20))
                        }
                    }
                }
            }
        }
        .onAppear {
            self.dailyArticleModelData.fetchLatestEposideMagazineURL(urlString: self.dailyArticlesJSONURL)
            self.dailyArticleModelData.fetchLatestMagazine()
        }
        .onChange(of: self.dailyArticleMagazineURL.count) { newValue in
            self.dailyArticleModelData.fetchLatestMagazine()
        }
    }
}


