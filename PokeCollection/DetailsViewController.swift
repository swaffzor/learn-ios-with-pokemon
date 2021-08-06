//
//  DetailsViewController.swift
//  PokeCollection
//
//  Created by Jeremy Swafford on 8/6/21.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var tvStats: UITextView!
    
    var name: String = ""
    var number: Int = 0
    var stats: [String] = []
    var pokemon: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblName.text = pokemon?.name
        lblNumber.text = String(pokemon?.id ?? 0)
        imgMain.image = UIImage(data: pokemon?.image ?? Data())
        let stats = pokemon?.stats
        tvStats.text = stats?.map{ stat in
            stat.stat.name + ": " + String(stat.base_stat) + "\n"
        }.joined()
    }
}
