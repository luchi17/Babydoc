//
//  InfoVaccinesViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 13/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import ICTextView
import QuartzCore


class InfoVaccinesViewController: UIViewController, UISearchBarDelegate, UITextViewDelegate{
    
    @IBOutlet weak var textView: ICTextView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchBarStyle = .minimal
        self.view.isOpaque = true
        self.view.backgroundColor = UIColor.init(hexString: "F8F9F9")?.withAlphaComponent(CGFloat(0.995))
        self.textView.backgroundColor = UIColor.init(hexString: "F8F9F9")?.withAlphaComponent(CGFloat(0.995))
        searchBar.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
        textView.scrollRectToVisible(CGRect.zero, animated: true, consideringInsets: true)
         textView.searchOptions = .caseInsensitive
        textView.secondaryHighlightColor = textView.primaryHighlightColor
        textView.tintColor = UIColor.flatBlue
        textView.animatedSearch = true
        textView.circularSearch = true
        

    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
  
        searchBar.resignFirstResponder()
        textView.scroll(toMatch: searchBar.text!)
        
      
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
          textView.scrollRectToVisible(CGRect.zero, animated: true, consideringInsets: true)
          textView.resetSearch()
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
       
        textView.scrollRectToVisible(CGRect.zero, animated: true, consideringInsets: true)
        textView.resetSearch()
        
    }
    
  
    
    
}

    

