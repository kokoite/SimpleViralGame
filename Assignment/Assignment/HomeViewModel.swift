//
//  HomeViewModel.swift
//  Assignment
//
//  Created by Pranjal Agarwal on 24/01/24.
//

import Foundation

class Node: NSObject, Codable {
    let url: String
    let path: String
    var lastAccessed: Date

    init(url: String, path: String, lastAccessed: Date) {
        self.url = url
        self.path = path
        self.lastAccessed = lastAccessed
    }
}

class LRUCache {
    static let shared = LRUCache()
    var cache: [Node] = []

    private init() {
        let data = UserDefaults.standard.value(forKey: "CachedImage") as? Data
        guard let data else { return }
        let cache = try? JSONDecoder().decode([Node].self, from: data)
        self.cache = cache ?? []
    }

    func storeImageData(using key: String, and value: Data) async {
        let tempPath = NSTemporaryDirectory().appending(UUID().uuidString)
        let tempURL = URL(filePath: tempPath)
        try? value.write(to: tempURL)
        if cache.count == 20 {
            let node = cache[0]
            deleteFile(at: node.path)
            cache.removeFirst()
        }
        try? value.write(to: tempURL)
        let node = Node(url: key, path: tempPath, lastAccessed: Date())
        cache.append(node)
        if let data = try? JSONEncoder().encode(cache) {
            UserDefaults.standard.setValue(data, forKey: "CachedImage")
        }
    }

    func clearAll() {
        cache = []
        UserDefaults.standard.removeObject(forKey: "CachedImage")
    }

    func getImageData(using key: String) async -> Data? {
        let node = cache.filter { $0.url == key }.first
        guard let path = node?.path, let node else {
            return nil
        }
        cache.removeAll { $0 == node }
        let modNode = Node(url: node.url, path: node.path, lastAccessed: Date())
        cache.append(modNode)
        UserDefaults.standard.setValue(cache, forKey: "CachedImage")
        return try? Data(contentsOf: URL(filePath: path))
    }

    func getAllCached() -> [Data] {
        let data = UserDefaults.standard.value(forKey: "CachedImage") as? Data
        guard let data else { return [] }
        let cache = (try? JSONDecoder().decode([Node].self, from: data))
        let cac: [Node]  = cache ?? []
        var images: [Data] = []
        for node in cac {
            let path = node.path
            let data = try? Data(contentsOf: URL(filePath: path))
            if let data {
                images.append(data)
            } else {
                print("Data is while fetching user defaults nil")
            }
        }
        return images
    }

    private func deleteFile(at path: String) {
        let temp = NSTemporaryDirectory()
        let file = URL(filePath: temp).appendingPathComponent(path)
        do {
            try FileManager.default.removeItem(at: file)
            print("File deleted successfully")
        } catch {
            print("Error while deleting file is \(error.localizedDescription)")
        }
    }
}

struct ApiError: Error {
    let title, subtitle: String

    init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }
}

final class ImageResponse: Decodable {
    let message: String
    let status: String
}

final class HomeViewModel {

    let url = URL(string: "https://dog.ceo/api/breeds/image/random")
    var controller: ImageGeneratorDisplayLogic?
    var response: Data?
    var error: Error?

    func fetchImageAndStoreInCache() {
        guard let url else {
            print("url is invalid")
            return
        }

        Task {
            do {
                let request = URLRequest(url: url)
                let (data, _ ) = try await URLSession.shared.data(for: request)
                let response = try JSONDecoder().decode(ImageResponse.self, from: data)
                guard response.status == "success" else {
                    throw ApiError(title: "Status Failed", subtitle: "Something went wrong")
                }
                try await fetchImageUsing(url: response.message)
                print("all good")

            } catch {
                self.error = error
                print("error is \(error.localizedDescription)")
            }
            refreshUI()
        }
    }

    func fetchImageUsing(url: String) async throws {
        let obj = await LRUCache.shared.getImageData(using: url)
        guard obj == nil else {
            response = obj
            return
        }

        guard let url = URL(string: url) else {
            return
        }
        let request = URLRequest(url: url)
        let (data, _ ) = try await URLSession.shared.data(for: request)
        Task {
            await LRUCache.shared.storeImageData(using: url.absoluteString, and: data)
            print("completed")
        }
        print("ui not blocked")
        response = data
    }

    private func refreshUI() {
        guard error == nil, let response else {
            DispatchQueue.main.async {
                self.controller?.displayError(using: self.error)
            }
            return
        }
        DispatchQueue.main.async {
            self.controller?.displayImage(using: response)
        }
    }
}
