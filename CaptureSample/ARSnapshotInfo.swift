//
//  ARSnapshotInfo.swift
//  CaptureSample
//
//  Created by Daisy Ramos on 11/11/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import UIKit

struct ARSnapshotInfo {

    let timestamp: TimeInterval

    let capturedImage: UIImage

    let capturedImagePixelBuffer: CVPixelBuffer

    let confidenceMapImageData: Data?

}
