//
//  Created by Evhen Gruzinov on 12.03.2023.
//

import SwiftUI

@main
struct ImagistoreApp: App {
    @State var imageHolder: UIImageHolder = UIImageHolder()

    var body: some Scene {
        WindowGroup {
            AppNavigator()
                .environmentObject(SceneSettings())
        }
    }
}
