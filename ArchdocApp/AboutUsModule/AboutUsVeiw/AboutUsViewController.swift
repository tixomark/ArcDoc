//
//  AboutUsViewController.swift
//  ArchdocApp
//
//  Created by tixomark on 1/23/23.
//

import UIKit

class AboutUsViewController: UIViewController {

    var presenter: AboutUsPresenterProtocol!
    
//    @IBOutlet weak var tastingView: CustomTabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.addSubview(tastingView)
//
//        tastingView.dataSource = self
//        tastingView.delegate = self
//        tastingView.backgroundColor = .white
        

    }

}

extension AboutUsViewController: CustomTabBarDataSource {
    func tabBar(numberOfElementsIn tabBar: CustomTabBar) -> Int {
        return 3
    }
    
    func tabBar(_ tabBar: CustomTabBar, elementFoRowAt index: Int) -> UIView {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }
    
    
}

extension AboutUsViewController: CustomTabBarDelegate {
    func tabBar(_ tabBar: CustomTabBar, didSelectElementAt index: Int) {
        print(index)
    }
    
    
}

extension AboutUsViewController: AboutUsViewProtocol {
    
}
