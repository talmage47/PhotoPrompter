import SwiftUI

struct PhotoPairCell: View {
    let pair: PhotoPair

    var body: some View {
        HStack(spacing: 2) {
            if let img1 = UIImage(data: pair.backImage), let img2 = UIImage(data: pair.frontImage) {
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
