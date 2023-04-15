//
//  Created by Evhen Gruzinov on 14.03.2023.
//

import SwiftUI

struct GalleryView: View {
    @ObservedObject var library: PhotosLibrary
    var photos: [Binding<Photo>] {
        $library.photos
            .filter({ $ph in
                ph.status == photosSelector
            })
            .sorted(by: { ph1, ph2 in
                if photosSelector == .deleted {
                    return ph1.deletionDate.wrappedValue! < ph2.deletionDate.wrappedValue!
                } else {
                    switch sortingSelector {
                    case .importDate:
                        return ph1.importDate.wrappedValue < ph2.importDate.wrappedValue
                    case .creationDate:
                        return ph1.creationDate.wrappedValue < ph2.creationDate.wrappedValue
                    }
                }
            })
    }
    
    @State var photosSelector: PhotoStatus
    @Binding var sortingSelector: PhotosSortArgument
    @Binding var scrollTo: UUID?
    @Binding var selectingMode: Bool
    @Binding var selectedImagesArray: [Photo]
    
    @State var openedImage: UUID = UUID()
    @State var goToDetailedView: Bool = false
    
    let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        ScrollViewReader { scroll in
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center, spacing: 1) {
                    ForEach(photos) { $item in
                        if item.uiImage != nil {
                            GeometryReader { gr in
                                let size = gr.size
                                VStack {
                                    Button {
                                        if selectingMode {
                                            if let index = selectedImagesArray.firstIndex(of: item) {
                                                selectedImagesArray.remove(at: index)
                                            } else {
                                                selectedImagesArray.append(item)
                                            }
                                        } else {
                                            goToDetailedView.toggle()
                                            openedImage = item.id
                                        }
                                    } label: {
                                        Image(uiImage: item.uiImage!)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: size.height, height: size.width, alignment: .center)
                                            .id(item.id)
                                            .overlay(
                                                ZStack {
                                                    if let deletionDate = item.deletionDate {
                                                        LinearGradient(colors: [.black.opacity(0), .black], startPoint: .center, endPoint: .bottom)
                                                        VStack(alignment: .center) {
                                                            Spacer()
                                                            Text(TimeFunctions.daysLeftString(deletionDate))
                                                                .font(.caption)
                                                                .padding(5)
                                                                .foregroundColor(TimeFunctions.daysLeft(deletionDate) < 3 ? .red : .white)
                                                        }
                                                    }
                                                }
                                            )
                                            .overlay(alignment: .bottomTrailing, content: {
                                                if selectedImagesArray.contains(item) {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .font(.title2)
                                                        .foregroundColor(Color.accentColor)
                                                        .padding(1)
                                                        .background(Circle().fill(.white))
                                                        .padding(5)
                                                }
                                            })
                                    }
                                    
                                }
                                .navigationDestination(isPresented: $goToDetailedView) {
                                    ImageDetailedView(library: library, photosSelector: photosSelector, sortingSelector: $sortingSelector, selectedImage: openedImage, scrollTo: $scrollTo)
                                }
                            }
                            .clipped()
                            .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
                Rectangle()
                    .frame(height: 50)
                    .opacity(0)
                    .id("bottomRectangle")
            }
            .onChange(of: scrollTo) { _ in
                if let scrollTo {
                    if sortingSelector == .importDate {
                        scroll.scrollTo("bottomRectangle", anchor: .bottom)
                    } else {
                        scroll.scrollTo(scrollTo, anchor: .center)
                    }
                }
            }
        }
    }
}