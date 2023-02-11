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
    var sceneView: TriDSceneView!
    
    var initialButton: UIButton!
    var zoomInButton: UIButton!
    var zoomOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let modelAsset = MDLAsset(url: presenter.modelUrl)
        sceneView.setUpScene(usingAsset: modelAsset)
        
        setUpUI()
        addTargets()
    }
    
    func setUpUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(sceneView)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
        initialButton = UIButton()
        view.addSubview(initialButton)
        initialButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            initialButton.heightAnchor.constraint(equalToConstant: 100),
            initialButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            initialButton.widthAnchor.constraint(equalTo: initialButton.heightAnchor),
            initialButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        initialButton.backgroundColor = .yellow
        
        zoomOutButton = UIButton()
        view.addSubview(zoomOutButton)
        zoomOutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            zoomOutButton.heightAnchor.constraint(equalToConstant: 100),
            zoomOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            zoomOutButton.widthAnchor.constraint(equalTo: zoomOutButton.heightAnchor),
            zoomOutButton.bottomAnchor.constraint(equalTo: initialButton.topAnchor)])
        zoomOutButton.backgroundColor = .red
        
        zoomInButton = UIButton()
        view.addSubview(zoomInButton)
        zoomInButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            zoomInButton.heightAnchor.constraint(equalToConstant: 100),
            zoomInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            zoomInButton.widthAnchor.constraint(equalTo: zoomInButton.heightAnchor),
            zoomInButton.bottomAnchor.constraint(equalTo: zoomOutButton.topAnchor)])
        zoomInButton.backgroundColor = .green
    }
    
    func addTargets() {
        initialButton.addTarget(self, action: #selector(touchedUpControlPanelButton(sender:)), for: .touchUpInside)
        zoomInButton.addTarget(self, action: #selector(touchedUpControlPanelButton(sender:)), for: .touchUpInside)
        zoomOutButton.addTarget(self, action: #selector(touchedUpControlPanelButton(sender:)), for: .touchUpInside)
        
        initialButton.tag = 0
        zoomInButton.tag = 1
        zoomOutButton.tag = 2
    }
    
    @objc private func touchedUpControlPanelButton(sender: UIButton) {
        switch sender.tag {
        case 0:
            presenter.initialStateButtonTaped()
        case 1:
            presenter.zoomButtonTapped(isZooming: true)
        case 2:
            presenter.zoomButtonTapped(isZooming: false)
        default:
            print("None of state buttons vere tapped, but seems one was")
        }
    }
    
    deinit {
        print("deinit TriDSceneViewController")
    }
}

extension TriDSceneViewController: TriDSceneViewProtocol {
}
