//
//  UIImageExt.swift
//  FindABox
//
//  Created by jerome on 16/09/2019.
//  Copyright © 2019 Jerome TONNELIER. All rights reserved.
//

import UIKit
import AVFoundation
import KStorage

public enum HEICError: Error {
  case heicNotSupported
  case cgImageMissing
  case couldNotFinalize
}

public extension UIImage {
    
    /// Returns a image that fills in newSize
    func resizedImage(newSize: CGSize) -> UIImage? {
        // Guard newSize is different
        guard size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    typealias quality = CGFloat
    func heicData(compressionQuality: quality = 0.8) throws -> Data {
        let data = NSMutableData()
        guard let imageDestination =
          CGImageDestinationCreateWithData(
            data, AVFileType.heic as CFString, 1, nil
          )
          else {
            throw HEICError.heicNotSupported
        }

        // 2
        guard let cgImage = self.cgImage else {
          throw HEICError.cgImageMissing
        }

        // 3
        let options: NSDictionary = [
          kCGImageDestinationLossyCompressionQuality: compressionQuality
        ]

        // 4
        CGImageDestinationAddImage(imageDestination, cgImage, options)
        guard CGImageDestinationFinalize(imageDestination) else {
          throw HEICError.couldNotFinalize
        }

        return data as Data
    }
}

public extension UIImage {

    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!

        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)

        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }

}

public extension UIImage {
    
    /// Fix image orientaton to protrait up
    func fixedOrientation() -> UIImage? {
        guard imageOrientation != UIImage.Orientation.up else {
            // This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        
        guard let cgImage = self.cgImage else {
            // CGImage is not available
            return nil
        }
        
        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil // Not able to create CGContext
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
        case .up, .upMirrored:
            break
        @unknown default:
            break
        }
        
        // Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            break
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
}

public class ImageManager {
    private init() {}
    static let shared: ImageManager = ImageManager()
    private var storage = DataStorage()
    
    public static func save(_ image: UIImage, imagePath: String? = nil) throws -> URL {
        if let path = imagePath {
            return try save(image, path: path)
        } else {
            return try save(image, path: FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).path)
        }
    }
    
    private static func save(_ image: UIImage, path: String) throws -> URL {
        try ImageManager.shared.storage.save(image, path: path)
    }
    
    public static func fetchImage(with name: String) -> UIImage? {
        guard let url = URL(string: DataStorage.storageDirectoryPath + "/" + name) else { return nil }
        return try? ImageManager.shared.storage.fetchImage(at: url)
    }
}


// MARK: - CodableImage
/// A class that wrapps an UIImage and an imageURL to handle locally saved images for upaload and distant image URL for display
class CodableImage: Codable, Hashable {
    static func == (lhs: CodableImage, rhs: CodableImage) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var image: UIImage?  {
        didSet {
            guard let image = image,
                  let url = try? ImageManager.save(image) else {
                return
            }
            imageURL = url
        }
    }
    var imageURL: URL?
    
    // MARK: - init
    init(imageURL: URL) {
        self.imageURL = imageURL
    }
    init?(_ image: UIImage) {
        self.image = image
    }
    
    // MARK: - codable
    enum CodingKeys: String, CodingKey {
        case imageURL
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //mandatory
        if let str = try container.decodeIfPresent(String.self, forKey: .imageURL) {
            imageURL = URL(string: str)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(imageURL?.absoluteString, forKey: .imageURL)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(imageURL)
        hasher.combine(image)
    }
}
