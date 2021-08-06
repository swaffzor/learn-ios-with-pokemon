//
//  PokeViewController.swift
//  PokeCollection
//
//  Created by Jeremy Swafford on 8/5/21.
//

import UIKit

final class PokeViewController: UICollectionViewController {

    private let reuseIdentifier = "PokeCell"
    private let itemsPerRow: CGFloat = 3
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
        getPokemon()
    }
    
    @IBAction func fetch(_ sender: UIButton) {
        getPokemon()
    }
    
    func getPokemon() {
        let baseUrl = searches.last?.next ?? URL(string: "https://www.pokeapi.co/api/v2/pokemon?limit=50")
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
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            let vc = segue.destination as? DetailsViewController
            if let cell = sender as? PokeCollectionCell, let indexPath = self.collectionView.indexPath(for: cell) {
                vc?.pokemon = pokemonList[indexPath.row]
            }
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PokeCollectionCell
        
            cell.imageView.image = UIImage(data: pokemonList[indexPath.row].image ?? Data())
        
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

// MARK: - Collection View Flow Layout Delegate
extension PokeViewController: UICollectionViewDelegateFlowLayout {
  // 1
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    // 2
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  // 3
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return sectionInsets
  }
  
  // 4
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return sectionInsets.left
  }
}
