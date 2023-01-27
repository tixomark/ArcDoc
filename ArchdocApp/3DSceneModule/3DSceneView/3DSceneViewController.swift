//
//  3DSceneViewController.swift
//  ArchdocApp
//
//  Created by tixomark on 1/26/23.
//

import UIKit
import SceneKit

class TriDSceneViewController: UIViewController {
    
    var presenter: TriDScenePresenterProtocol?
    
//    var topInvisible
    
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
        let scene = SCNScene(named: "GirlsScene.scn")
        sceneView.scene = scene
        mainNode = sceneView.scene?.rootNode.childNode(withName: "Girls", recursively: false)
    }
    
    func addGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(gesture:)))
        sceneView.addGestureRecognizer(panGesture)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(gesture:)))
        swipeGesture.direction = .down
//        sceneView.addGestureRecognizer(swipeGesture)
        
//        panGesture.require(toFail: swipeGesture)
    }
    
    @objc func panGesture(gesture: UIPanGestureRecognizer) {
        
        
        let velocity = gesture.velocity(in: sceneView)
        let velocityVector = simd_float2(x: Float(velocity.x), y: Float(velocity.y))
        
        rotate(mainNode, by: velocityVector)
        
        
    }
    
    @objc func swipeGesture(gesture: UISwipeGestureRecognizer) {
        guard gesture.direction == .down else {return}
        presenter?.swipeDown()
    }
    
    func rotate(_ node: SCNNode, by vector: simd_float2) {
        
        let yAngle = GLKMathDegreesToRadians(1) * vector.y * 0.01
        let xAngle = GLKMathDegreesToRadians(1) * vector.x * 0.01
        
        let yOrigin = simd_float3(x: 0, y: 1, z: 0)
        let xOrigin = simd_float3(x: 1, y: 0, z: 0)
        
        let yRotation = simd_quatf(angle: xAngle, axis: yOrigin)
        let xRotation = simd_quatf(angle: yAngle, axis: xOrigin)
        
        let sinSign = asin(node.simdWorldUp.z).sign
        
        print(node.simdWorldUp)

        guard let parentNode = node.parent  else {return}
        
        node.simdLocalRotate(by: yRotation)
        switch sinSign {
        case .minus:
            if xRotation.vector.x.sign == .plus || node.simdWorldUp.y > 0{
                node.simdRotate(by: xRotation, aroundTarget: parentNode.simdPosition)
            }
        case .plus:
            if xRotation.vector.x.sign == .minus || node.simdWorldUp.y > 0 {
                node.simdRotate(by: xRotation, aroundTarget: parentNode.simdPosition)
            }
        }
        //            node.simdOrientation = node.simdOrientation * yRotation
        //            node.simdOrientation = xRotation * node.simdOrientation
    }
    
    deinit {
        print("3dview deinit")
    }
}



extension TriDSceneViewController: TriDSceneViewProtocol {
}

extension Float {
    func clamp(min: Float, max: Float) -> Float {
        var clampedX = self
        if self > max {
            clampedX = max
        } else if self < min {
            clampedX = min
        }
        return clampedX
    }
}
