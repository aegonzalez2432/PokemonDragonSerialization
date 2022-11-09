//
//  ViewController.swift
//  DragonSerialization
//
//  Created by Consultant on 11/8/22.
//

import UIKit

class ViewController: UIViewController {
    
    
    lazy var manualDecodeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Manual Decode", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20.0
        button.addTarget(self, action: #selector(self.manualDecodeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        // Do any additional setup after loading the view.
    }
    
    func createUI() {
        self.view.addSubview(self.manualDecodeButton)
        
        self.manualDecodeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        self.manualDecodeButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 8).isActive = true
        self.manualDecodeButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        self.manualDecodeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    //TODO: prop wrapper
    //TODO: combine sdk
    
    @objc
    func manualDecodeButtonPressed() {
        print("Button Pressed")
        let dragon = NetworkManager.shared.getPokemonManually()
        self.presentPokemonAlert(dragon: dragon)
    }
    
    func presentPokemonAlert(dragon: Dragon?) {
        guard let dragon = dragon else { return }
        
        let moveNames = dragon.pokemons.compactMap {
            return $0.pokemon.name
        }
        
        let alert = UIAlertController(title: "Dragon", message: "\(moveNames)", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(okayAction)
        
        self.present(alert, animated: true)
        
        
    }
    
}
