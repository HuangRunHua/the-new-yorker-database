//
//  ModelData.swift
//  Daily News
//
//  Created by Huang Runhua on 2022/9/26.
//

import Foundation
import Combine

final class ModelData: ObservableObject, Decodable {
    @Published var magazineURLs: [MagazineURL] = []
    @Published var magazines: [Magazine] = []
    @Published var magazine: Magazine?
    @Published var articles: [Article] = []
    @Published var article: Article?
    @Published var selectedMagazine: Magazine?
    @Published var selectedArticle: Article?
    @Published var latestMagazine: Magazine?
    @Published var latestArticles: [Article] = []
    
    enum CodingKeys: CodingKey {
        case magazineURLs
        case magazines
        case articles
    }
    
    required init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        magazineURLs = try value.decode([MagazineURL].self, forKey: .magazineURLs)
        magazines = try value.decode([Magazine].self, forKey: .magazines)
        articles = try value.decode([Article].self, forKey: .articles)
    }
    
    init() {}
    
    func fetchLatestMagazineURLs(urlString: String) {
        guard let databaseURL = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: databaseURL)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.magazineURLs = self._parseJsonData(data: data)
                }
            }
        }
        task.resume()
    }
    
    func fetchAllMagazines() {
        self.magazines = []
        for magazineURL in self.magazineURLs {
            _fetchMagazine(urlString: magazineURL.magazineURL)
        }
        self.magazines = self.magazines.sorted(by: { $0.id > $1.id })
    }
    
    func fetchAllArticles() {
        self.articles = []
        if let selectedMagazine = selectedMagazine {
            for article in selectedMagazine.articles.sorted(by: { $0.id < $1.id}) {
                _fetchArticle(urlString: article.articleURL)
            }
        }
    }
    
    func fetchLatestArticles() {
        self.latestArticles = []
        if let latestMagazine = latestMagazine {
            for article in latestMagazine.articles.sorted(by: { $0.id < $1.id}) {
                _fetchArticle(urlString: article.articleURL)
            }
        }
    }
    
    private func _fetchMagazine(urlString: String) {
        guard let magazineURL = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: magazineURL)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    if let currentMagazine = self._parseMagazineJsonData(data: data) {
                        self.magazines.append(currentMagazine)
                    } else {
                        print("No current magazine found")
                    }
                }
            }
        }
        task.resume()
    }

    private func _fetchArticle(urlString: String) {
        guard let articleURL = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: articleURL)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    if let currentArticle = self._parseArticleJsonData(data: data) {
                        self.articles.append(currentArticle)
                    } else {
                        print("No current article found")
                    }
                }
            }
        }
        task.resume()
    }
    
    private func _fetchLatestArticle(urlString: String) {
        guard let articleURL = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: articleURL)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    if let currentArticle = self._parseArticleJsonData(data: data) {
                        self.latestArticles.append(currentArticle)
                    } else {
                        print("No current article found")
                    }
                }
            }
        }
        task.resume()
    }
    
    private func _parseJsonData(data: Data) -> [MagazineURL] {
        let decoder = JSONDecoder()
        do {
            let magazineURLs = try decoder.decode([MagazineURL].self, from: data)
            self.magazineURLs = magazineURLs.sorted(by: { $0.id > $1.id })
        } catch {
            print(error)
        }
        return magazineURLs
    }
    
    private func _parseMagazineJsonData(data: Data) -> Magazine? {
        let decoder = JSONDecoder()
        do {
            let magazine = try decoder.decode(Magazine.self, from: data)
            self.magazine = magazine
        } catch {
            print(error)
        }
        return magazine
    }
    
    private func _parseArticleJsonData(data: Data) -> Article? {
        let decoder = JSONDecoder()
        do {
            let article = try decoder.decode(Article.self, from: data)
            self.article = article
        } catch {
            print(error)
        }
        return article
    }
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}


