//
//  LRUCache.swift
//  Assignment
//
//  Created by Pranjal Agarwal on 26/01/24.
//

import Foundation

final class LRUCache {
    static let shared = LRUCache()
    private var cache: [Node] = []

    private init() {
        let data = UserDefaults.standard.value(forKey: "CachedImage") as? Data
        guard let data else { return }
        let cache = try? JSONDecoder().decode([Node].self, from: data)
        self.cache = cache ?? []
    }

    func storeImageData(using key: String, and value: Data) async throws {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        try value.write(to: fileURL)
        let fileExists = FileManager.default.fileExists(atPath: fileURL.path)
        print("file exists \(fileExists)")
        if cache.count == 20 {
            let node =  cache[0]
            try await deleteFile(at: node.path)
            cache.removeFirst()
        }
        let node = Node(url: key, path: fileURL.path, lastAccessed: Date())
        cache.append(node)
        if let data = try? JSONEncoder().encode(cache) {
            UserDefaults.standard.setValue(data, forKey: "CachedImage")
        }
    }

    func clearAll() async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            for node in cache {
                try? await deleteFile(at: node.path)
            }
            try await group.next()
        }
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
        if let data = try? JSONEncoder().encode(cache) {
            UserDefaults.standard.setValue(data, forKey: "CachedImage")
        }
        return try? Data(contentsOf: URL(filePath: path))
    }

    func getAllCached() async throws -> [Data] {
        let data = UserDefaults.standard.value(forKey: "CachedImage") as? Data
        guard let data, !data.isEmpty else { return [] }
        let cache = (try JSONDecoder().decode([Node].self, from: data))
        let cac: [Node]  = cache
        var images: [Data] = []
        for node in cac {
            let path = node.path
            let fileExists = FileManager.default.fileExists(atPath: path)
            print("file exists for all cache \(fileExists)")
            let data = try? Data(contentsOf: URL(filePath: path))
            if let data {
                images.append(data)
            }
        }
        return images
    }

    private func deleteFile(at path: String) async throws {
        let fileExists = FileManager.default.fileExists(atPath: path)
        print("file exists \(fileExists)")
        try FileManager.default.removeItem(atPath: path)
    }
}
