//
//  HomeViewModel.swift
//  Assignment
//
//  Created by Pranjal Agarwal on 24/01/24.
//

import Foundation

protocol ImageGeneratorBusinessLogic: AnyObject {
    func fetchImageAndStoreInCache()
}

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

final class ImageGeneratorViewModel: ImageGeneratorBusinessLogic {

    let url = URL(string: "https://dog.ceo/api/breeds/image/random")
    var controller: ImageGeneratorDisplayLogic?
    var response: Data?
    var error: Error?

    func fetchImageAndStoreInCache() {
        guard let url else {
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
            } catch {
                self.error = error
            }
            refreshUI()
        }
    }

    private func fetchImageUsing(url: String) async throws {
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
            try await LRUCache.shared.storeImageData(using: url.absoluteString, and: data)
        }
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
