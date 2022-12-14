//
//  MagazineList.swift
//  Daily News
//
//  Created by Huang Runhua on 2022/9/27.
//

import SwiftUI

struct MagazineList: View {
    
    private let databaseURL: String = "https://github.com/HuangRunHua/the-new-yorker-database/raw/main/database/database.json"
    
    private let latestMagazineJSONURL: String = "https://github.com/HuangRunHua/the-new-yorker-database/raw/main/database/latest.json"
    
    private let dailyArticlesJSONURL: String = "https://github.com/HuangRunHua/the-new-yorker-database/raw/main/database/daily-articles.json"
    
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var dailyArticleModelData: DailyArticleModelData
    
    @Environment(\.colorScheme) var colorScheme
    
    var magazineURLs: [MagazineURL] {
        return modelData.magazineURLs
    }
    
    var magazines: [Magazine] {
        return modelData.magazines.sorted(by: { $0.id > $1.id })
    }
    
    /// 最新一期的杂志
    var latestMagazine: [Magazine] {
        return modelData.latestMagazine
    }
    
    var dailyArticleMagazine: [Magazine] {
        return dailyArticleModelData.latestMagazine
    }
    
    var latestMagazineURL: [LatestMagazineURL] {
        return modelData.latestMagazineURL
    }
    
    var dailyArticleMagazineURL: [LatestMagazineURL] {
        return dailyArticleModelData.latestMagazineURL
    }
    
    private let gridItemLayout = [GridItem(.flexible())]
    
    private let lanscapeGridItemLayout = [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)]
    
    @State private var showMagazineContents: Bool = false
    
    private let thumbnailWidth: CGFloat = 50
    private let thumbnailCornerRadius: CGFloat = 5
    
    enum Tab: Int {
        case latest, daily
    }
        
    @State private var selectedTab = Tab.daily
    
    var body: some View {
        self.magazineList
    }
}

struct MagazineList_Previews: PreviewProvider {
    static var previews: some View {
        MagazineList()
            .environmentObject(ModelData())
            .environmentObject(DailyArticleModelData())
    }
}

extension MagazineList {
    private var magazineList: some View {
        VStack(spacing: 0) {
            ZStack {
                if self.selectedTab == .latest {
                    self.latestTabView
                }
                else if self.selectedTab == .daily {
                    self.dailyArticles
                }
            }
        }
    }
     
    
    var tabBarView: some View {
        VStack(spacing: 0) {
            Divider()
                .foregroundColor(.gray)
            
            HStack(spacing: 20) {
                Spacer()
                tabBarItem(.daily, title: "Latest", icon: "list.dash")
                Spacer()
                tabBarItem(.latest, title: "Stories", icon: "doc.plaintext.fill")
                Spacer()
            }
            .padding(.top, 8)
        }
        .frame(height: 50)
        .background(Color.tabColor.edgesIgnoringSafeArea(.all))
    }
    
    @ViewBuilder
    private var latestArticles: some View {
        if self.modelData.latestArticles.isEmpty {
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
        } else {
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(self.modelData.latestArticles) { article in
                        NavigationLink {
                            ArticleView(currentArticle: article)
                                .environmentObject(modelData)
                        } label: {
                            ArticleContentRow(currentArticle: article)
                        }
                    }
                }
            }
        }
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
                        self.tabBarView
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
                        self.tabBarView
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
            if newValue > 0 {
                self.dailyArticleModelData.fetchLatestMagazine()
            }
        }
        .onChange(of: self.dailyArticleMagazine.count) { newValue in
            if newValue > 0 {
                self.dailyArticleModelData.fetchLatestArticles()
            }
        }
    }
    
    @ViewBuilder
    private var magazineListRow: some View {
        LazyVGrid(columns: lanscapeGridItemLayout) {
            ForEach(magazines, id: \.identityID) { magazine in
                NavigationLink {
                    ArticleConetntsList(magazine: magazine)
                        .environmentObject(modelData)
                } label: {
                    MagazineCoverRow(magazine: magazine)
                }
            }
        }
        .padding([.leading, .trailing, .bottom])
    }
    
    @ViewBuilder
    private var magazineTabView: some View {
        ScrollView {
            Divider()
            self.magazineListRow
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Magazines")
                    .font(Font.custom("Georgia", size: 20))
            }
        }
        .onAppear {
            self.modelData.fetchLatestMagazineURLs(urlString: databaseURL)
            self.modelData.fetchLatestMagazine()
        }
        .onChange(of: magazineURLs.count) { newValue in
            if newValue > 0 {
                self.modelData.fetchAllMagazines()
            }
        }
    }
    
    @ViewBuilder
    private var latestTabView: some View {
        NavigationView {
            if magazines.isEmpty {
                VStack(spacing: 0) {
                    Spacer()
                    ProgressView()
                    Spacer()
                    self.tabBarView
                }
            } else {
                VStack(spacing: 0) {
                    List {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Recent Issues".uppercased())
                                    .fontWeight(.bold)
                                    .padding([.leading, .top, .trailing])
                            }
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(alignment: .bottom, spacing: 14) {
                                    ForEach(magazines.prefix(8), id: \.identityID) { magazine in
                                        NavigationLink {
                                            ArticleConetntsList(magazine: magazine)
                                                .environmentObject(modelData)
                                        } label: {
                                            MagazineCoverRow(magazine: magazine)
                                                .frame(width: 200)
                                        }
                                    }
                                }
                                .padding([.leading, .trailing, .bottom])
                            }
                        }
                        .listRowInsets(EdgeInsets())
                        
                        VStack(alignment: .leading) {
                            Text("Latest Stories".uppercased())
                                .fontWeight(.bold)
                                .padding([.leading, .top, .trailing])
                            
                            self.latestArticles
                                .padding([.leading, .trailing])
                        }
                        .padding(.bottom)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                    }
                    
                    .listStyle(.plain)
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            VStack(spacing: 0) {
                                Text("Weekly")
                                    .font(Font.custom("Georgia", size: 20))
                            }
                        }

                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink {
                                self.magazineTabView
                            } label: {
                                Image(systemName: "doc.plaintext")
                            }

                        }
                    }
                    .refreshable {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            self.modelData.fetchAllMagazines()
                            self.modelData.fetchLatestMagazine()
                        }
                    }
                    
                    self.tabBarView
                }
            }
        }
        
        #if !os(macOS)
        .navigationViewStyle(.stack)
        #endif
        .onAppear {
            self.modelData.fetchLatestMagazineURLs(urlString: databaseURL)
            self.modelData.fetchLatestEposideMagazineURL(urlString: self.latestMagazineJSONURL)
            self.modelData.fetchLatestMagazine()
        }
        .onChange(of: magazineURLs.count) { newValue in
            if newValue > 0 {
                self.modelData.fetchAllMagazines()
            }
        }
        .onChange(of: self.latestMagazineURL.count) { newValue in
            if newValue > 0 {
                self.modelData.fetchLatestMagazine()
            }
        }
        .onChange(of: self.latestMagazine.count) { newValue in
            if newValue > 0 {
                self.modelData.fetchLatestArticles()
            }
        }
    }
    
    
    func tabBarItem(_ tab: Tab, title: String, icon: String) -> some View {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 3) {
                    VStack {
                        Image(systemName: icon)
                            .font(.system(size: 24))
                            .foregroundColor(selectedTab == tab ? .accentColor : .gray)
                    }
                    .frame(width: 55, height: 28)
                    
                    Text(title)
                        .font(.system(size: 11))
                        .foregroundColor(selectedTab == tab ? .accentColor : .gray)
                }
            }
            .frame(width: 65, height: 42)
            .onTapGesture {
                selectedTab = tab
            }
        }
}


