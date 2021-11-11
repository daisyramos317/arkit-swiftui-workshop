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
        return sceneView
    }()

    init(session: ARSession, model: CameraViewModel) {
        self.session = session
        self.viewModel = model
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}