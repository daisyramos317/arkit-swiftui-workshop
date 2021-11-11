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

enum SessionType {

    case avCaptureSession(_ session: AVCaptureSession)

    case arCaptureSession(_ session: ARSession)
}
