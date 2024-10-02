//
//  CarouselView.swift
//  FS 70
//
//  Created by antoine fenouillot on 19/09/2024.
//
import UIKit

protocol CarouselViewDelegate: AnyObject {
    func currentPageDidChange(to page: Int)
    func openHomeSegue()
    func openLegalSegue()
}

class CarouselView: UIView {
    
    private var lastContentOffset: CGFloat = 100000000
    
    struct CarouselData {
        let image: UIImage?
        let text: String
    }
    
    // MARK: - Subviews
    
    private lazy var carouselCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.dataSource = self
        collection.delegate = self
        collection.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.cellId)
        collection.backgroundColor = .clear
        return collection
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .white
        return pageControl
    }()
    
    lazy var startButton: UIButton = {
        /*let startButton = UIButton(type: .custom)
        //button.addTarget(self, action: #selector(self.buttonClicked(_:)), for: .touchUpInside)
        
        
        startButton.setTitle("Commencer", for: .normal)
        startButton.setTitleColor(.blue, for: .normal)
        startButton.backgroundColor = UIColor.green
        startButton.frame = CGRect(x: 100, y: 200, width: 100, height: 30)
        
        startButton.addTarget(self, action: #selector(click), for: .touchUpInside)

        return startButton*/
        
        let btn = UIButton(type: .system)
                btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
                btn.setTitle("Commencer", for: .normal)
                btn.layer.cornerRadius = 8.0
                btn.layer.masksToBounds = true
                btn.tintColor = .white
                btn.backgroundColor = .red
                btn.addTarget(self, action: #selector(buttonTouched), for: .touchUpInside)
                return btn
    }()
    
    lazy var legalButton: UIButton = {
        
        let btn = UIButton(type: .system)
                btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
                btn.setTitle("Mentiosn légales", for: .normal)
                btn.layer.cornerRadius = 8.0
                btn.layer.masksToBounds = true
                btn.tintColor = .white
                btn.backgroundColor = .red
                btn.addTarget(self, action: #selector(legalTouched), for: .touchUpInside)
                return btn
    }()
    
    @objc func buttonTouched(sender: UIButton) {
        delegate?.openHomeSegue()
    }
    
    @objc func legalTouched(sender: UIButton) {
        delegate?.openLegalSegue()
    }
    
    // MARK: - Properties
    
    private var pages: Int
    private weak var delegate: CarouselViewDelegate?
    private var carouselData = [CarouselData]()
    private var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            delegate?.currentPageDidChange(to: currentPage)
        }
    }
    
    // MARK: - Initializers
    
    init(pages: Int, delegate: CarouselViewDelegate?) {
        self.pages = pages
        self.delegate = delegate
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setups

private extension CarouselView {
    func setupUI() {
        backgroundColor = .clear
        setupCollectionView()
        setupPageControl()
        setupStartButton()
        setupLegalButton()
    }
    
    func setupCollectionView() {
        
        let cellPadding = (frame.width - 300) / 2
        let carouselLayout = UICollectionViewFlowLayout()
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.itemSize = .init(width: 300, height: 680)
        carouselLayout.sectionInset = .init(top: 0, left: cellPadding, bottom: 0, right: cellPadding)
        carouselLayout.minimumLineSpacing = cellPadding * 2
        carouselCollectionView.collectionViewLayout = carouselLayout
        
        addSubview(carouselCollectionView)
        carouselCollectionView.translatesAutoresizingMaskIntoConstraints = false
        carouselCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        carouselCollectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        carouselCollectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        carouselCollectionView.heightAnchor.constraint(equalToConstant: 680).isActive = true
    }
    
    func setupPageControl() {
        addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.topAnchor.constraint(equalTo: carouselCollectionView.bottomAnchor, constant: 0).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pageControl.widthAnchor.constraint(equalToConstant: 150).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 10).isActive = true
        pageControl.numberOfPages = pages
    }
    
    func setupStartButton() {
        addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.topAnchor.constraint(equalTo: carouselCollectionView.bottomAnchor, constant: 16).isActive = true
        startButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        startButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupLegalButton() {
        addSubview(legalButton)
        legalButton.translatesAutoresizingMaskIntoConstraints = false
        legalButton.topAnchor.constraint(equalTo: carouselCollectionView.bottomAnchor, constant: 16).isActive = true
        legalButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        legalButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        legalButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

// MARK: - UICollectionViewDataSource

extension CarouselView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /*guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.cellId, for: indexPath) as? CarouselCell else {
            return UICollectionViewCell()
        }*/
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.cellId, for: indexPath) as? CarouselCell
        let image = carouselData[indexPath.row].image
        let text = carouselData[indexPath.row].text
        
        cell!.configure(image: image, text: text)
        
        return cell!
    }
}

// MARK: - UICollectionView Delegate

extension CarouselView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        currentPage = getCurrentPage()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
    }
    
}

// MARK: - Public

extension CarouselView {
    public func configureView(with data: [CarouselData]) {
        let cellPadding = (frame.width - 350) / 2
        let carouselLayout = UICollectionViewFlowLayout()
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.itemSize = .init(width: 350, height: 700)
        carouselLayout.sectionInset = .init(top: 0, left: cellPadding, bottom: 0, right: cellPadding)
        carouselLayout.minimumLineSpacing = cellPadding * 2
        carouselCollectionView.collectionViewLayout = carouselLayout
        
        carouselData = data
        
        //Needed to display cell data
        carouselCollectionView.layoutIfNeeded()
        carouselCollectionView.reloadData()
    }
}

// MARKK: - Helpers

private extension CarouselView {
    func getCurrentPage() -> Int {
        
        let visibleRect = CGRect(origin: carouselCollectionView.contentOffset, size: carouselCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = carouselCollectionView.indexPathForItem(at: visiblePoint) {
            return visibleIndexPath.row
        }
        
        return currentPage
    }
}
