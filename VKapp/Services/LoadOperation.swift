//
//  LoadOperation.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 4/4/18.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import UIKit

class GetCachedImages: Operation{
    private let cacheLifeTime : TimeInterval = 3600
    private static let pathName: String = {
        
        let pathName = "pictures"
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName }
        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathName
    }()
    
    private lazy var filePath: String? = {
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        let hasheName = String(describing: url.hashValue)
        return cachesDirectory.appendingPathComponent(GetCachedImages.pathName + "/" + hasheName).path
    }()
    
    private let url: String
    var outputImage: UIImage?
    
    init(url: String) {
        self.url = url
    }
    override func main() {
        
        guard filePath != nil && !isCancelled else { return }
        
        if getImageFromCache() { return }
        guard !isCancelled else { return }
        
        if !downloadImage() { return }
        guard !isCancelled else { return }
        
        saveImageToCache()
    }
    private func getImageFromCache() -> Bool {

                guard let fileName = filePath,
                    let info = try? FileManager.default.attributesOfItem(atPath: fileName),
                    let modificationDate = info[FileAttributeKey.modificationDate] as? Date else { return false }
        
                let lifeTime = Date().timeIntervalSince(modificationDate)
        
                guard lifeTime <= cacheLifeTime,
                    let image = UIImage(contentsOfFile: fileName) else { return false }
 
        
        self.outputImage = image
        return true
    }
    
    private func downloadImage() -> Bool  {
        
        guard let url = URL(string: url),
            let data = try? Data.init(contentsOf: url), // исправить Data на URLSession
            let image = UIImage(data: data) else { return false }
        
        self.outputImage = image
        return true
    }
    
    private func saveImageToCache() {
        guard let fileName = filePath, let image = outputImage else { return }
        let data = UIImagePNGRepresentation(image)
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }
}


class FetchImages: Operation {
    private let indexPath: IndexPath
    private weak var tableView: UITableView?
    
    init(indexPath: IndexPath, tableView: UITableView) {
        self.indexPath = indexPath
        self.tableView = tableView
    }
    
    override func main() {
        guard let tableView = tableView,
            let getCachedImages = dependencies[0] as? GetCachedImages,
            let image = getCachedImages.outputImage else { return }
        
        if let cell = tableView.cellForRow(at: indexPath) as? FriendsTVCCell {
            cell.cellImage.image = image
        } else if let cell = tableView.cellForRow(at: indexPath) as? GroupsTVCell  {
            cell.cellImage.image = image
        }
        
    }
}
