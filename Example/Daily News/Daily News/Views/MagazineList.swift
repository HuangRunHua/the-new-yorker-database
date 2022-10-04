//
//  MagazineList.swift
//  Daily News
//
//  Created by Huang Runhua on 2022/9/27.
//

import SwiftUI

struct MagazineList: View {
    
    private let databaseURL: String = "https://github.com/HuangRunHua/the-new-yorker-database/raw/main/database/database.plist"
    
    @EnvironmentObject var modelData: ModelData
    
    var magazineURLs: [MagazineURL] {
        return modelData.magazineURLs
    }
    
    var magazines: [Magazine] {
        return modelData.magazines
    }
    
    private let gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    private let lanscapeGridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @State private var showMagazineContents: Bool = false
    
    private let thumbnailWidth: CGFloat = 50
    private let thumbnailCornerRadius: CGFloat = 5
    
    var body: some View {
        TabView {
            NavigationView {
                Text("News+")
                    .navigationTitle("News+")
            }
            .tabItem {
                    Label("Today", systemImage: "list.dash")
                }
            
            
            ZStack {
                if let selectedArticle = self.modelData.selectedArticle {
                    ZStack(alignment: .bottomTrailing) {
                        ArticleView(currentArticle: selectedArticle)
                            .environmentObject(modelData)
                        self.coverThumbnail
                    }
                    .sheet(isPresented: $showMagazineContents) {
                        if let selectedmagazine = self.modelData.selectedMagazine {
                            ArticleConetntsList(magazine: selectedmagazine)
                                .environmentObject(modelData)
                        }
                    }
                } else {
                    self.magazineList
                }
            }.tabItem {
                Label("Magazine", systemImage: "doc.richtext")
            }
        }
    }
}

struct MagazineList_Previews: PreviewProvider {
    static var previews: some View {
        MagazineList()
            .environmentObject(ModelData())
    }
}

extension MagazineList {
    private var magazineList: some View {
        GeometryReader { geo in
            NavigationView {
                if magazines.isEmpty {
                    ProgressView()
                        .navigationTitle("THE NEW YORKER")
                } else {
                    ScrollView {
                        LazyVGrid(columns: geo.size.width > geo.size.height ? lanscapeGridItemLayout: gridItemLayout) {
                            ForEach(magazines, id: \.identityID) { magazine in
                                MagazineCoverRow(magazine: magazine)
                                    .onTapGesture {
                                        self.showMagazineContents.toggle()
                                        self.modelData.selectedMagazine = magazine
                                    }
                            }
                        }
                        .padding()
                    }
                    .navigationTitle("THE NEW YORKER")
                }
            }
            #if !os(macOS)
            .navigationViewStyle(.stack)
            #endif
            .onAppear {
                self.modelData.fetchLatestMagazineURLs(urlString: databaseURL)
            }
            .onChange(of: magazineURLs.count) { newValue in
                if newValue > 0 {
                    self.modelData.fetchAllMagazines()
                }
            }
            .sheet(isPresented: $showMagazineContents) {
                if let selectedmagazine = self.modelData.selectedMagazine {
                    ArticleConetntsList(magazine: selectedmagazine)
                        .environmentObject(modelData)
                }
            }
        }
    }
    
    @ViewBuilder
    private var coverThumbnail: some View {
        if let selectedMagazine = self.modelData.selectedMagazine {
            if let coverImageURL = URL(string: selectedMagazine.coverImageURL) {
                AsyncImage(url: coverImageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: self.thumbnailWidth)
                    case .empty, .failure:
                        Rectangle()
                            .aspectRatio(selectedMagazine.coverImageWidth/selectedMagazine.coverImageHeight, contentMode: .fit)
                                .foregroundColor(.secondary)
                                .frame(width: self.thumbnailWidth)
                    @unknown default:
                        EmptyView()
                    }
                }
                .padding(5)
                .background(Color.white)
                .shadow(radius: 5)
                .cornerRadius(self.thumbnailCornerRadius)
                .padding()
                .onTapGesture {
                    self.showMagazineContents.toggle()
                }
            }
        }
    }
}
