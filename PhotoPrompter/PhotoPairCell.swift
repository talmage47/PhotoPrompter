import SwiftUI

struct PhotoPairCell: View {
    let pair: PhotoPair

    var body: some View {
        HStack(spacing: 2) {
            if let backData = pair.backImage, let frontData = pair.frontImage,
               let img1 = UIImage(data: backData), let img2 = UIImage(data: frontData) {
                Image(uiImage: img1)
                    .resizable()
                    .scaledToFit()
                Image(uiImage: img2)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}
