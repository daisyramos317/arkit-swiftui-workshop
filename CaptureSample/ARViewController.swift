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

class ARViewController: UIViewController, ARSessionDelegate, ARSCNViewDelegate {

    @ObservedObject var viewModel: CameraViewModel
    let session: ARSession

    lazy var arView: ARSCNView = {
        let sceneView = ARSCNView()
        sceneView.delegate = self
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
        arView.session = session
        arView.session.delegate = self
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
