//
//  ARViewController.swift
//  CaptureSample
//
//  Created by Daisy Ramos on 11/11/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import ARKit
import SwiftUI
import CoreImage

class ARViewController: UIViewController, ARSessionDelegate {

    @ObservedObject var viewModel: CameraViewModel
    let session: ARSession
    private var imageContext = CIContext()

    lazy var arView: ARSCNView = {
        let sceneView = ARSCNView()
        sceneView.session = session
        sceneView.session.delegate = self
        sceneView.showsStatistics = true
        return sceneView
    }()

    init(session: ARSession, model: CameraViewModel) {
        self.session = session
        self.viewModel = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSceneView()
    }

    private func addSceneView() {
        view.addSubview(arView)

        arView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arView.topAnchor.constraint(equalTo: view.topAnchor),
            arView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            arView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard let currentFrame = session.currentFrame else {
            return
        }

        if let snapshotCompletion = viewModel.snapshotCompletionHandler {
            var confidenceMapData: Data?

            if let confidenceMap = currentFrame.sceneDepth?.confidenceMap {
                let confidenceMapCIImage = confidenceMapToCIImage(pixelBuffer: confidenceMap)!

                let colorSpace = CGColorSpace(name: CGColorSpace.linearGray)!
                confidenceMapData = imageContext.tiffRepresentation(of: confidenceMapCIImage,
                                                                    format: .L8,
                                                                    colorSpace: colorSpace,
                                                                    options: [.disparityImage: confidenceMapCIImage])

            }

            let capturedImageCoreImage = CIImage(cvPixelBuffer: currentFrame.capturedImage).oriented(.right)
            let cgImage = imageContext.createCGImage(capturedImageCoreImage, from: capturedImageCoreImage.extent)!

            let capturedImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: .up)

            let info = ARSnapshotInfo(timestamp: currentFrame.timestamp, capturedImage: capturedImage, capturedImagePixelBuffer: currentFrame.capturedImage,  confidenceMapImageData: confidenceMapData)
            snapshotCompletion(info)
            viewModel.snapshotCompletionHandler = nil
        }
    }

    private func confidenceMapToCIImage(pixelBuffer: CVPixelBuffer) -> CIImage? {
            func confienceValueToPixcelValue(confidenceValue: UInt8) -> UInt8 {
                guard confidenceValue <= ARConfidenceLevel.high.rawValue else {
                    return 0
                }
                return UInt8(floor(Float(confidenceValue) / Float(ARConfidenceLevel.high.rawValue) * 255))
            }

            CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
            guard let base = CVPixelBufferGetBaseAddress(pixelBuffer) else {
                return nil
            }
            let height = CVPixelBufferGetHeight(pixelBuffer)
            let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)

            for offset in stride(from: 0, to: bytesPerRow * height, by: MemoryLayout<UInt8>.stride) {
                let data = base.load(fromByteOffset: offset, as: UInt8.self)
                let pixcelValue = confienceValueToPixcelValue(confidenceValue: data)
                base.storeBytes(of: pixcelValue, toByteOffset: offset, as: UInt8.self)
            }

            CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))

            return CIImage(cvPixelBuffer: pixelBuffer).oriented(.right)
        }
}

struct ARViewRepresentable: UIViewControllerRepresentable {
    let session: ARSession
    @ObservedObject var model : CameraViewModel

    typealias UIViewControllerType = ARViewController

    func makeUIViewController(context: Context) -> ARViewController {
        return ARViewController(session: session, model: model)
    }
    func updateUIViewController(_ uiViewController:
                                ARViewRepresentable.UIViewControllerType, context:
                                UIViewControllerRepresentableContext<ARViewRepresentable>) { }
}
