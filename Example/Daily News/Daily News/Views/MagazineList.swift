//
//  MagazineList.swift
//  Daily News
//
//  Created by Huang Runhua on 2022/9/27.
//

import SwiftUI

struct MagazineList: View {
    
    private let databaseURL: String = "https://github.com/HuangRunHua/the-new-yorker-database/raw/main/database/database.json"
    
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
        self.magazineList
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
        NavigationView {
            if magazines.isEmpty {
                ProgressView()
            } else {
                List {
                    VStack(alignment: .leading) {
                        Text("Recent Issues")
                            .fontWeight(.bold)
                            .padding([.leading, .top, .trailing])
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .top, spacing: 14) {
                                ForEach(magazines, id: \.identityID) { magazine in
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
                }
                
                .listStyle(.plain)
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack(spacing: 0) {
                            Text("THE")
                                .font(Font.custom("Georgia", size: 10))
                            Text("NEWS+")
                                .font(Font.custom("Georgia", size: 20))
                        }
                    }
                }
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

//                        LazyVGrid(columns: geo.size.width > geo.size.height ? lanscapeGridItemLayout: gridItemLayout) {
//                            ForEach(magazines, id: \.identityID) { magazine in
//                                MagazineCoverRow(magazine: magazine)
//                                    .onTapGesture {
//                                        self.showMagazineContents.toggle()
//                                        self.modelData.selectedMagazine = magazine
//                                    }
//                            }
//                        }
//                        .padding()
