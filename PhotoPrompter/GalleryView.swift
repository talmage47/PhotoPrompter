import SwiftUI
import CoreData

struct GalleryView: View {
    @FetchRequest(
        entity: PhotoPair.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \PhotoPair.date, ascending: false)]
    ) var photoPairs: FetchedResults<PhotoPair>

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(photoPairs, id: \.id) { pair in
                        VStack {
                            if let backData = pair.backImage, let frontData = pair.frontImage,
                               let backImg = UIImage(data: backData), let frontImg = UIImage(data: frontData) {
                                HStack(spacing: 8) {
                                    Image(uiImage: backImg)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 80, maxHeight: 100)
                                    Image(uiImage: frontImg)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 80, maxHeight: 100)
                                }
                            } else {
                                Text("Corrupt photo data")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                            Text((pair.date ?? Date(timeIntervalSince1970: 946684800)), style: .date)
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.secondarySystemBackground)))
                    }
                }
                .padding(16)
            }
            .navigationTitle("Gallery")
        }
    }
}

#Preview {
    GalleryView()
}
