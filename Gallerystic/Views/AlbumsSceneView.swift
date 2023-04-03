//
//  Created by Evhen Gruzinov on 31.03.2023.
//

import SwiftUI

struct AlbumsSceneView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var library: PhotosLibrary
    
    var albums: [String] = []
    
    let rows1 = [
        GridItem(.flexible(minimum: UIScreen.main.bounds.width / 1.7))
    ]
    let rows2 = [
        GridItem(.flexible(minimum: UIScreen.main.bounds.width / 1.7)),
        GridItem(.flexible(minimum: UIScreen.main.bounds.width / 1.7))
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    Text("Albums").font(.title).bold()
                    Spacer()
                }
                .padding(.horizontal, 15)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: albums.count > 1 ? rows2 : rows1, spacing: 10) {
                        NavigationLink(destination: {
                            GallerySceneView(library: $library, photosSelector: .normal)
                        }, label: {
                            AlbumBlockView(library: $library)
                        })
                        
                    }
                }
                .padding(.horizontal, 15)
                
                HStack {
                    Text("Other").font(.title2).bold()
                    Spacer()
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                VStack(spacing: 10) {
                    //                Button {
                    //                } label: {
                    //                    HStack {
                    //                        Label("Favorite", systemImage: "heart.fill")
                    //                        Spacer()
                    //                        Text("123").foregroundColor(Color.secondary)
                    //                        Image(systemName: "chevron.forward").foregroundColor(Color.secondary)
                    //                    }
                    //                    .font(.title3)
                    //                    .padding(.horizontal, 15)
                    //                }
                    Divider()
                    NavigationLink {
                        GallerySceneView(library: $library, photosSelector: .deleted)
                    } label: {
                        HStack {
                            Label("Recently Deleted", systemImage: "trash").font(.title3)
                            Spacer()
                            Image(systemName: "lock.fill").foregroundColor(Color.secondary)
                            Image(systemName: "chevron.forward").foregroundColor(Color.secondary)
                        }
                        .padding(.horizontal, 15)
                    }
                }
            }
        }
    }
}