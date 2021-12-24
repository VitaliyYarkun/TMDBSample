import UIKit

extension Data {
    func imageScaledToHeight(height: CGFloat) -> Data {
      let image = UIImage(data: self)!
      let oldHeight = image.size.height
      let scaleFactor = height / oldHeight
      let newWidth = image.size.width * scaleFactor
      let newSize = CGSize(width: newWidth, height: height)
      let newRect = CGRect(x: 0, y: 0, width: newWidth, height: height)
      
      UIGraphicsBeginImageContext(newSize)
      image.draw(in: newRect)
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      
      return newImage!.jpegData(compressionQuality: 0.8)!
    }
}
