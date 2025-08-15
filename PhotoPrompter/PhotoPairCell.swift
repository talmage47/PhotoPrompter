import SwiftUI

struct PhotoPairCell: View {
    let pair: PhotoPair
    var frontImage: UIImage {
        if let frontData = pair.frontImage, let img2 = UIImage(data: frontData){
            return img2
        } else{
            return UIImage(systemName: "photo")!
        }
    }
    var backImage: UIImage{
        if let backData = pair.backImage, let img1 = UIImage(data: backData){
            return img1
        } else{
            return UIImage(systemName: "photo")!
        }
    }

    var body: some View {
        HStack(spacing: 2) {
            Image(uiImage: frontImage)
                .resizable()
                .scaledToFit()
            Image(uiImage: backImage)
                .resizable()
                .scaledToFit()
        }
    }
}
