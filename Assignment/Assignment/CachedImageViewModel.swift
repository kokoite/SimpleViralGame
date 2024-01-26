//
//  CachedImageViewModel.swift
//  Assignment
//
//  Created by Pranjal Agarwal on 26/01/24.
//

import Foundation

protocol CachedImageViewBusinessLogic {
    func getCachedImage()
    func deleteCachedImage()
}

final class CachedImageViewModel: CachedImageViewBusinessLogic {
    var response: [Data] = []
    var error: Error?
    var controller: CachedImageViewDisplayLogic?

    func getCachedImage() {
        Task {
            do {
                self.response = try await LRUCache.shared.getAllCached()
            } catch {
                self.error = error
                print("error is \(error.localizedDescription)")
            }
            refreshGetCachedImage()
        }
    }

    func deleteCachedImage() {
        Task {
            do {
                try await LRUCache.shared.clearAll()
            } catch {
                self.error = error
                print("Error is \(error.localizedDescription)")
            }
            refreshDeletedCached()
        }
    }

    func refreshGetCachedImage() {
        guard error == nil, !response.isEmpty else {
            DispatchQueue.main.async {
                self.controller?.displayCachedImages(using: [], and: self.error)
            }
            return
        }
        DispatchQueue.main.async {
            self.controller?.displayCachedImages(using: self.response, and: nil)
        }
    }

    func refreshDeletedCached() {
        DispatchQueue.main.async {
            self.controller?.displayDeleteCachedImage(using: self.error)
        }
    }
}
