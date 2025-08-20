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
            ZStack {
                Color("Background").ignoresSafeArea()
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(photoPairs, id: \.id) { pair in
                            VStack {
                                PhotoPairCell(pair: pair)
                                    .frame(maxWidth: .infinity, minHeight: 140)
                            }
                        }
                    }
                    .padding(8)
                }
                //.navigationTitle("Gallery")
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Gallery")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("MainText"))
                }
            }
        }
    }
}

#Preview {
    GalleryView()
}
