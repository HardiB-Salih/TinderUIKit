//
//  MatchHeader.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/23/24.
//

import UIKit

protocol MatchHeaderDelegate: AnyObject {
    func matchHeader(_ header: MatchHeader, wantToStartChatWith uid: String)
}

let MatchCellIdentifire = "MatchCell"

class MatchHeader: UICollectionReusableView {
    
    weak var delegate: MatchHeaderDelegate?
    var matches = [Match]() {
        didSet { collectionView.reloadData() }
    }

    //MARK: - Properties
    private let newMatchesLabel: UILabel = {
        let lable = UILabel()
        lable.text = "New Matches"
        lable.font = .systemFont(of: .headline, weight: .bold)
        lable.textColor = .systemPink
        return lable
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(MatchCell.self, forCellWithReuseIdentifier: MatchCellIdentifire)
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    
    //MARK: - Life cycle

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        addSubview(newMatchesLabel)
        newMatchesLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        addSubview(collectionView)
        collectionView.anchor(top: newMatchesLabel.bottomAnchor, left: leftAnchor,bottom: bottomAnchor, right: rightAnchor,
                              paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDataSource
extension MatchHeader : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchCellIdentifire, for: indexPath) as? MatchCell else {
            return UICollectionViewCell()
        }
        
        let match = matches[indexPath.row]
        cell.configureCell(forMatch: match)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MatchHeader : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let match = matches[indexPath.row]
        // Send User To Chat View and Creat Dirrect Chat For this user and the Current User
        delegate?.matchHeader(self, wantToStartChatWith: match.uid)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension MatchHeader : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 108)
    }
}
