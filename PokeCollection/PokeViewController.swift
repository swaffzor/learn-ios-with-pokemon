//
//  PokeViewController.swift
//  PokeCollection
//
//  Created by Jeremy Swafford on 8/5/21.
//

import UIKit

final class PokeViewController: UICollectionViewController {

    private let reuseIdentifier = "PokeCell"
    private let sectionInsets = UIEdgeInsets(
      top: 50.0,
      left: 20.0,
      bottom: 50.0,
      right: 20.0
    )
    private var searches: [PokemonPaginated] = [] {
        willSet {
//            newValue.last?.results.map{poke in
            guard let pokemons = newValue.last?.results else {return}
            for poke in pokemons {
                fetchPokemonCells(url: poke.url, completionHandler: {pokeData in
                    self.pokemonList.append(pokeData)
                    self.pokemonList.sort{ $0.id < $1.id }
                })
            }
        }
    }
    private var pokemonList: [Pokemon] = [] {
        willSet {
            for poke in newValue {
                if (!poke.imageLoaded) {
                    guard let url = URL(string: poke.sprite) else {return}
                    fetchImage(url: url, completionHandler: { data in
                        poke.image = data
                        poke.imageLoaded = true
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    })
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    @IBAction func fetch(_ sender: UIButton) {
        let baseUrl = searches.last?.next ?? URL(string: "https://www.pokeapi.co/api/v2/pokemon")
        guard let baseUrl = baseUrl else {
            return
        }
        fetchPaginatedData(url: baseUrl, completionHandler: {paginatedData in
            self.searches.append(paginatedData)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PokeCollectionCell
        
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
