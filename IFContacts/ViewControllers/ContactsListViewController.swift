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
    @IBOutlet weak var mainContactsTV: UITableView!
    private var mainToolBarButton: UIBarButtonItem!
    private var mainContactsPresenter: ContactsPresenter!
    private var searchVC: UISearchController!
    private var isShowTV: Bool = false
    var contactIDSelected: Int!
    
    lazy var refreshCCV: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ContactsListViewController.getContactList),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = .white
        
        return refreshControl
    }()
    
    lazy var refreshCTV: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ContactsListViewController.getContactList),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = .white
        
        return refreshControl
    }()
    
    //MARK: View Animator Var
    let viewAnimatorRight = AnimationType.from(direction: .right, offset: 50.0)
    let viewAnimatorTop = AnimationType.from(direction: .top, offset: 50.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        
        buildButtonFromNB(delegateIn: self)
        
        mainContactsCV.register(UINib(nibName: "ContactListCell", bundle: nil), forCellWithReuseIdentifier: "ContactListCell")
        mainContactsTV.register(UINib(nibName: "ContactListTVCell", bundle: nil), forCellReuseIdentifier: "ContactListTVCell")
        mainContactsTV.rowHeight = 125
        mainContactsTV.separatorStyle = .none
        
        searchVC = UISearchController(searchResultsController: nil)
        searchVC.searchResultsUpdater = self
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.searchBar.placeholder = "Search Contacts"
        navigationItem.searchController = searchVC
        definesPresentationContext = true
        self.extendedLayoutIncludesOpaqueBars = true
        
        if #available(iOS 10.0, *) {
            mainContactsCV.refreshControl = refreshCCV
            mainContactsTV.refreshControl = refreshCTV
        }else{
            mainContactsCV.addSubview(refreshCCV)
            mainContactsTV.addSubview(mainContactsTV)
        }
    
        mainContactsPresenter = ContactsPresenter(mainViewIn: self)
        showLoading()
        getContactList()
    }
    
    @objc func showOrHideUI(_ sender: UIButton) {
        
        if isShowTV {
            isShowTV = false
            mainContactsTV.isHidden = true
            mainContactsCV.isHidden = false
            sender.setImage(#imageLiteral(resourceName: "list_IM"), for: .normal)
        }else {
            isShowTV = true
            mainContactsTV.isHidden = false
            mainContactsCV.isHidden = true
            sender.setImage(#imageLiteral(resourceName: "grill_IM"), for: .normal)
        }
    }
    
    @objc func getContactList() {
        refreshCCV.endRefreshing()
        refreshCTV.endRefreshing()
        mainContactsPresenter.getContactsList()
    }
    
    override func refreshUI() {
        removeLoading()
        if !isShowTV {
            mainContactsCV.reloadData()
            mainContactsCV.performBatchUpdates({
                UIView.animate(views: mainContactsCV.orderedVisibleCells,
                               animations: [viewAnimatorRight], completion: {
                                self.mainContactsTV.reloadData()
                })
            }, completion: nil)
        }else{
            mainContactsTV.reloadData()
            mainContactsTV.performBatchUpdates({
                UIView.animate(views: mainContactsTV.visibleCells,
                               animations: [viewAnimatorTop], completion: {
                                self.mainContactsCV.reloadData()
                })
            }, completion: nil)
        }
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

//MARK: Extentions For UICollection View Components
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

//MARK: Extentions For UITable View Components
extension ContactsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFilterNow() {
            return mainContactsPresenter.mainFilterContactsData.count
        }
        
        let contactKey = mainContactsPresenter.mainContactTitlesIndex[section]
        if let contactA = mainContactsPresenter.mainContactDic[contactKey] {
            return contactA.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tvCell = tableView.dequeueReusableCell(withIdentifier: "ContactListTVCell") as! ContactListTVCell
        
        var mainContact: Contact!
        if isFilterNow() {
            mainContact = mainContactsPresenter.mainFilterContactsData[indexPath.row]
        }else{
            let contactKey = mainContactsPresenter.mainContactTitlesIndex[indexPath.section]
            if let contactA = mainContactsPresenter.mainContactDic[contactKey] {
                mainContact = contactA[indexPath.row]
            }
        }
        
        tvCell.setupCell(contactIn: mainContact, indexIn: indexPath)
        
        tvCell.cCallButton.addTarget(self, action: #selector(makeContactCall(_:)), for: .touchUpInside   )
        tvCell.cProfileButton.addTarget(self, action: #selector(viewContactDetail(_:)), for: .touchUpInside   )
        
        tvCell.selectionStyle = .none
        return tvCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if isFilterNow() {
            return mainContactsPresenter.mainFilterHeaderTitle.count
        }
        
        return mainContactsPresenter.mainContactTitlesIndex.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if isFilterNow() {
            return mainContactsPresenter.mainFilterHeaderTitle[section]
        }
        
        return mainContactsPresenter.mainContactTitlesIndex[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        if isFilterNow() {
            return nil
        }
        
        return mainContactsPresenter.mainContactTitlesIndex
    }
}

