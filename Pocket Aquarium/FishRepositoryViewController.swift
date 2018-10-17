//
//  FishRepositoryViewController.swift
//  Pocket Aquarium
//
//  Created by Sze Yan Kwok on 16/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import Firebase

class FishRepositoryViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
   

    @IBOutlet weak var fishTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterSegment: UISegmentedControl!
    
    //data source
    var searchList : NSMutableArray
    var filterList : NSMutableArray
    var searchText: String?
    
    //DB Reference
    lazy var fishRef = Database.database().reference().child("fished")
    
    //DB reference handler
    private var fishesRefHandler : DatabaseHandle?
    
    //initializer
    required init?(coder aDecoder: NSCoder) {
        self.filterList = NSMutableArray()
        self.searchList = NSMutableArray()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fishTableView.delegate = self
        fishTableView.dataSource = self
        
        //observe fish update in the firebase
        observeFish()
    }
    
    //MARK: - Firebase observation: Retrieve fish data
    private func observeFish(){
        fishesRefHandler = self.fishRef.observe(.childAdded, with: {(snapshot)-> Void in
            let fishData = snapshot.value as! Dictionary<String,AnyObject>
            let fishId = snapshot.key
            
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    

}
