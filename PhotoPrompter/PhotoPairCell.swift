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
    
    var dateText: Text {
        if let date = pair.date {
            return Text(date, style: .date)
        } else {
            return Text("No Date")
        }
    }

    var body: some View {
        VStack {
            HStack(spacing: 2) {
                Image(uiImage: frontImage)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Image(uiImage: backImage)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            dateText
                .font(.caption2)
                .foregroundColor(Color("MainText"))
                .padding(.top, 2)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("Foreground"))
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
