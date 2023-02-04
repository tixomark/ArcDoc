//
//  3DSceneViewController.swift
//  ArchdocApp
//
//  Created by tixomark on 1/26/23.
//

import UIKit
import SceneKit
import SceneKit.ModelIO

class TriDSceneViewController: UIViewController {
    
    var presenter: TriDScenePresenterProtocol!
    
    var sceneView: SCNView!
    var mainNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpScene()
        addGestures()
        
    }
    
    func setUpUI() {
        view.backgroundColor = .systemBackground
        sceneView = SCNView()
        view.addSubview(sceneView)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    func setUpScene() {
//        guard let url = Bundle.main.url(forResource: "Gostilitsy3DModel", withExtension: "usdz") else { fatalError() }
//            let scene = try! SCNScene(url: url, options: [.checkConsistency: true])
        print(presenter.modelUrl)
        let modelAsset = MDLAsset(url: presenter.modelUrl)
        let scene = SCNScene(mdlAsset: modelAsset)
        sceneView.scene = scene
        mainNode = sceneView.scene?.rootNode.childNodes.first
        
        let spotLight = SCNNode()
        spotLight.light = SCNLight()
        spotLight.light?.type = .directional

        sceneView.scene?.rootNode.addChildNode(spotLight)
    }
    
    func addGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(gesture:)))
        sceneView.addGestureRecognizer(panGesture)
    }
    
    @objc func panGesture(gesture: UIPanGestureRecognizer) {
        let transition = gesture.translation(in: sceneView)
        gesture.setTranslation(CGPoint(), in: sceneView)
        let transitionVector = simd_float2(x: Float(transition.x), y: Float(transition.y))
        
        rotate(mainNode, accordingTo: transitionVector)
    }
    
    func rotate(_ node: SCNNode, accordingTo vector: simd_float2) {
        
        let yAngle = GLKMathDegreesToRadians(1) * vector.y * 0.5
        let xAngle = GLKMathDegreesToRadians(1) * vector.x
        
        let yRotation = simd_quatf(angle: xAngle, axis: simd_float3(x: 0, y: 1, z: 0))
        var xRotation = simd_quatf(angle: yAngle, axis: simd_float3(x: 1, y: 0, z: 0))
        
        let currentAngleToZero = acos(node.simdWorldUp.z)
        var correctionAngle: Float = 0
        
        if yAngle < 0 && abs(yAngle) > (3.14 - currentAngleToZero) {
            correctionAngle = -yAngle - 3.14 + currentAngleToZero
        }
        if yAngle > 0 && yAngle > (currentAngleToZero - GLKMathDegreesToRadians(1)) {
            correctionAngle = currentAngleToZero - yAngle - GLKMathDegreesToRadians(1)
        }
        
        xRotation = xRotation * simd_quatf(angle: correctionAngle, axis: simd_float3(x: 1, y: 0, z: 0))
        
        guard let parentNode = node.parent else {return}
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.1
        
        node.simdLocalRotate(by: yRotation)
        node.simdRotate(by: xRotation, aroundTarget: parentNode.simdPosition)
        
        SCNTransaction.commit()
        //        node.simdOrientation = node.simdOrientation * yRotation
        //        node.simdOrientation = xRotation * node.simdOrientation
    }
}

extension TriDSceneViewController: TriDSceneViewProtocol {
}

extension Float {
    mutating func clamp(min: Float, max: Float){
        if self > max {
            self = max
        } else if self < min {
            self = min
        }
    }
}
