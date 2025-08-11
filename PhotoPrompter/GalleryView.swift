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
                            if let backImg = UIImage(data: pair.backImage),
                               let frontImg = UIImage(data: pair.frontImage) {
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
                            Text(pair.date, style: .date)
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
