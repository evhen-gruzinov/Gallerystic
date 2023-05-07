//
//  Created by Evhen Gruzinov on 07.05.2023.
//

import Foundation
import CoreData

@objc(PhotosLibrary)
public class PhotosLibrary: NSManagedObject {
    static var actualLibraryVersion = 1
}

enum PhotosSortArgument: String {
    case importDate, creationDate
}

enum RemovingDirection: String {
    case bin
    case recover
    case permanent
}
