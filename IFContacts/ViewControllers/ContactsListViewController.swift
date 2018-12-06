//
//  ContactsListViewController.swift
//  IFContacts
//
//  Created by Eduardo  Herrera Fagundez on 24/11/18.
//  Copyright © 2018 Eduardo  Herrera Fagundez. All rights reserved.
//

import UIKit
import ViewAnimator

class ContactsListViewController: MainBaseViewController {
    
    @IBOutlet weak var mainContactsCV: UICollectionView!
    var mainContactsPresenter: ContactsPresenter!
    var contactIDSelected: Int!
    var searchVC: UISearchController!
    
    //MARK: View Animator Var
    let viewAnimator = AnimationType.from(direction: .right, offset: 50.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        
        mainContactsCV.register(UINib(nibName: "ContactListCell", bundle: nil), forCellWithReuseIdentifier: "ContactListCell")
        
        searchVC = UISearchController(searchResultsController: nil)
        searchVC.searchResultsUpdater = self
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.searchBar.placeholder = "Search Contacts"
        navigationItem.searchController = searchVC
        definesPresentationContext = true
        
        showLoading()
        mainContactsPresenter = ContactsPresenter(mainViewIn: self)
        mainContactsPresenter.getContactsList()
    }
    
    override func refreshUI() {
        removeLoading()
        mainContactsCV.reloadData()
        mainContactsCV.performBatchUpdates({
            UIView.animate(views: self.mainContactsCV.orderedVisibleCells,
                           animations: [viewAnimator], completion: {
                            
            })
        }, completion: nil)
    }
    
    func isFilterNow() -> Bool {
        return searchVC.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchVC.searchBar.text?.isEmpty ?? true
    }
    
    @objc func makeContactCall(_ sender: UIButton) {
        
        if isFilterNow() {
            for contactPhone in mainContactsPresenter.mainFilterContactsData[sender.tag].contactPhones {
                if contactPhone.contactPhoneNumber != "Not Register" {
                    canMakePhoneCall(phoneNumIn: contactPhone.contactPhoneNumber)
                    return
                }
            }
            
        }else{
            for contactPhone in mainContactsPresenter.mainContactsData[sender.tag].contactPhones {
                if contactPhone.contactPhoneNumber != "Not Register" {
                    canMakePhoneCall(phoneNumIn: contactPhone.contactPhoneNumber)
                    return
                }
            }
        }
    }
    
    @objc func viewContactDetail(_ sender: UIButton) {
        if isFilterNow() {
            contactIDSelected = Int(mainContactsPresenter.mainFilterContactsData[sender.tag].contactID)
        }else{
            contactIDSelected = Int(mainContactsPresenter.mainContactsData[sender.tag].contactID)
        }
        self.performSegue(withIdentifier: "showContactDetail", sender: nil)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContactDetail" {
            let contactDetailView = segue.destination as! ContactDetailViewController
            contactDetailView.mainContactsPresenter = mainContactsPresenter
            contactDetailView.contactID = contactIDSelected
        }
    }
}

extension ContactsListViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        mainContactsPresenter.filterContactsForSB(searchTextIn: searchController.searchBar.text!)
    }
}

extension ContactsListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isFilterNow() {
            return mainContactsPresenter.mainFilterContactsData.count
        }
        
        return mainContactsPresenter.mainContactsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactListCell", for: indexPath) as! ContactListCell
        
        var mainContact: Contact
        if isFilterNow() {
            mainContact = mainContactsPresenter.mainFilterContactsData[indexPath.row]
        }else{
            mainContact = mainContactsPresenter.mainContactsData[indexPath.row]
        }
        
        cCell.setupCell(contactIn: mainContact, indexIn: indexPath)
        
        cCell.cCallButton.addTarget(self, action: #selector(makeContactCall(_:)), for: .touchUpInside   )
        cCell.cProfileButton.addTarget(self, action: #selector(viewContactDetail(_:)), for: .touchUpInside   )
        
        return cCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isFilterNow() {
   
            for (index, tempContact) in mainContactsPresenter.mainFilterContactsData.enumerated() {
                if tempContact.contactIsSelected == true {
                    mainContactsPresenter.mainFilterContactsData[index].contactIsSelected = false
                    mainContactsCV.reloadItems(at: [IndexPath(row: index, section: 0)])
                }
            }
            mainContactsPresenter.mainFilterContactsData[indexPath.row].contactIsSelected = true
            mainContactsCV.reloadItems(at: [indexPath])
            
        }else{
    
            for (index, tempContact) in mainContactsPresenter.mainContactsData.enumerated() {
                if tempContact.contactIsSelected == true {
                    mainContactsPresenter.mainContactsData[index].contactIsSelected = false
                    mainContactsCV.reloadItems(at: [IndexPath(row: index, section: 0)])
                }
            }
            mainContactsPresenter.mainContactsData[indexPath.row].contactIsSelected = true
            mainContactsCV.reloadItems(at: [indexPath])
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.iPad {
            return CGSize(width: 300, height: 326)
        }else{
            if UIDevice.current.iPhoneModel.rawValue == "iPhone5" {
                return CGSize(width: 130, height: 156)
            }else{
                return CGSize(width: 160, height: 186)
            }
        }
    }
}

