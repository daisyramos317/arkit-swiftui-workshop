//
//  SessionType.swift
//  CaptureSample
//
//  Created by Daisy Ramos on 11/11/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import AVFoundation
import ARKit

enum SessionType: Hashable {

    case avCaptureSession(_ session: AVCaptureSession)

    case arCaptureSession(_ session: ARSession)

    var isARSession: Bool {
        switch self {
        case .avCaptureSession:
            return false
        case .arCaptureSession:
            return true
        }
    }
}
