/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Custom app subclass.
*/

import SwiftUI
import ARKit

@main
struct CaptureSampleApp: App {
    @StateObject var model = CameraViewModel(sessionType: .arCaptureSession(CameraViewModel.arSession))
    
    var body: some Scene {
        WindowGroup {
            ContentView(model: model)
        }
    }
}
