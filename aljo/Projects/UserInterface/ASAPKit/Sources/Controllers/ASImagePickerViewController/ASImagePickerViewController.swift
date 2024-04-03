//
//  ASImagePickerViewController.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import Photos

import SnapKit

public protocol ASImagePickerDelegate: AnyObject {
  func imagePicker(_ picker: ASImagePickerViewController, didComplete images: [UIImage?])
}

public class ASImagePickerViewController: UIViewController {
  // MARK: View Properties
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(
      AssetImageGridCell.self,
      forCellWithReuseIdentifier: AssetImageGridCell.identifier
    )
    return collectionView
  }()
  
  // MARK: Properties
  public weak var delegate: ASImagePickerDelegate?
  private var photos: PHFetchResult<PHAsset>?
  private let scale = UITraitCollection.current.displayScale
  private var thumbnailSize = CGSize.zero
  private let selectedMaxCount: Int
  private var selectedColor: UIColor
  private var selectedItems: [PHAsset] = [] {
    willSet {
      updateNavigationRightButton(newValue.count)
    }
  }
  
  public init(max selectedMaxCount: Int, selectedColor: UIColor = .red01) {
    self.selectedMaxCount = selectedMaxCount
    self.selectedColor = selectedColor
    
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable, message: "스토리보드로 생성할 수 없습니다.")
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit { PHPhotoLibrary.shared().unregisterChangeObserver(self) }
  
  // MARK: Life Cycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    configureLibraryImages()
    configureUI()
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    let width = view.bounds.inset(by: view.safeAreaInsets).width
    
    let columnCount = (width / 90).rounded(.towardZero)
    let itemLength = (width - columnCount) / columnCount
    self.thumbnailSize = CGSize(width: itemLength * scale, height: itemLength * scale)
  }
  
  private func fetchSelectedImages(completionHandler: @escaping ([UIImage?]) -> Void) {
    var images: [UIImage?] = []
    let frame = view.frame
    let size = CGSize(width: frame.width, height: frame.height)
    let group = DispatchGroup()
    
    for asset in selectedItems {
      DispatchQueue.global().async(group: group) { [weak self] in
        group.enter()
        self?.fetchItem(to: asset, with: size) { image in
          images.append(image)
          group.leave()
        }
      }
    }
    
    group.notify(queue: .main) {
      completionHandler(images)
    }
  }
  
  private func fetchItem(
    to asset: PHAsset,
    with size: CGSize,
    completion: @escaping (UIImage?) -> Void
  ) {
    let manager = PHImageManager.default()
    let option = PHImageRequestOptions()
    option.deliveryMode = .highQualityFormat
    option.resizeMode = .fast
    
    manager.requestImage(
      for: asset, targetSize: size, contentMode: .aspectFit, options: option
    ) { image, _ in completion(image) }
  }
}

// MARK: UICollectionView DataSource Method
extension ASImagePickerViewController: UICollectionViewDataSource {
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return photos?.count ?? .zero
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: AssetImageGridCell.identifier,
      for: indexPath
    ) as? AssetImageGridCell else { return AssetImageGridCell() }
    
    cell.delegate = self
    let asset = photos?.object(at: indexPath.item) ?? PHAsset()
    fetchItem(to: asset, with: thumbnailSize) { cell.setImage(to: $0) }
    
    return cell
  }
}

extension ASImagePickerViewController: AssetImageGridCellDelegate {
  func assetImageGridCell(_ cell: AssetImageGridCell) {
    guard let indexPath = collectionView.indexPath(for: cell) else { return }
    
    let item = photos?.object(at: indexPath.item) ?? PHAsset()
    let isNotContains = updateSelectedItem(to: item)
    cell.setSelected(to: isNotContains, with: selectedColor)
  }
}

// MARK: UICollectionView Delegate Method
extension ASImagePickerViewController: UICollectionViewDelegate {
  public func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    guard let item = photos?[indexPath.row] else { return }
    let cell = collectionView.cellForItem(at: indexPath) as? AssetImageGridCell
    let isNotContains = updateSelectedItem(to: item)
    cell?.setSelected(to: isNotContains, with: selectedColor)
  }
}

// MARK: UICollectionView Flow Layout Delegate Method
extension ASImagePickerViewController: UICollectionViewDelegateFlowLayout {
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let length = self.view.frame.width / 3 - 1.5
    return CGSize(width: length, height: length)
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat { return 1.5 }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat { return 1.5 }
}

private extension ASImagePickerViewController {
  func configureLibraryImages() {
    checkPhotoAuthorization()
    
    PHPhotoLibrary.shared().register(self)
    
    let option = PHFetchOptions()
    option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    photos = PHAsset.fetchAssets(with: .image, options: option)
    
    collectionView.reloadData()
  }
  
  func checkPhotoAuthorization() {
    PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
      DispatchQueue.main.async {
        switch status {
          case .denied, .restricted:
            debugPrint("[에러] 사용자가 개인정보 처리 방침을 거부했습니다.")
          default:
            return
        }
      }
    }
  }
  
  func updateSelectedItem(to item: PHAsset) -> Bool {
    let isContainItem = selectedItems.contains(item)
    
    if selectedItems.count == selectedMaxCount && isContainItem == false { return false }
    
    if isContainItem == false {
      selectedItems.append(item)
    } else {
      selectedItems.removeAll(where: { $0.localIdentifier == item.localIdentifier })
    }
    
    return isContainItem == false
  }
}

// MARK: Photo Selected Changed Observer
extension ASImagePickerViewController: PHPhotoLibraryChangeObserver {
  public func photoLibraryDidChange(_ changeInstance: PHChange) {
    guard let photos = photos,
          let changes = changeInstance.changeDetails(for: photos) else { return }
    
    DispatchQueue.main.sync {
      self.photos = changes.fetchResultAfterChanges
      
      if changes.hasIncrementalChanges == false {
        collectionView.reloadData()
        return
      }
      
      collectionView.performBatchUpdates {
        if let removed = changes.removedIndexes, removed.isEmpty == false {
          let indexPaths = removed.map { IndexPath(item: $0, section: .zero) }
          collectionView.deleteItems(at: indexPaths)
        }
        
        if let inserted = changes.insertedIndexes, inserted.isEmpty == false {
          let indexPaths = inserted.map { IndexPath(item: $0, section: .zero) }
          collectionView.insertItems(at: indexPaths)
        }
        
        changes.enumerateMoves { [weak self] in
          let fromIndexPath = IndexPath(item: $0, section: .zero)
          let toIndexPath = IndexPath(item: $1, section: .zero)
          self?.collectionView.moveItem(at: fromIndexPath, to: toIndexPath)
        }
        
        if let changed = changes.changedIndexes, changed.isEmpty == false {
          let indexPaths = changed.map { IndexPath(item: $0, section: .zero) }
          collectionView.reloadItems(at: indexPaths)
        }
      }
    }
  }
}

// MARK: Configuration UI
private extension ASImagePickerViewController {
  func configureUI() {
    view.backgroundColor = .systemBackground
    configureNavigationBar()
    configureHierarchy()
    makeConstraints()
  }
  
  func updateNavigationRightButton(_ selectedCount: Int) {
    let isActive = selectedCount == selectedMaxCount
    navigationItem.rightBarButtonItem?.isEnabled = isActive
  }
  
  func configureNavigationBar() {
    navigationController?.setUpAppearance()
    let dismissAction = UIAction { [weak self] _ in
      self?.dismiss(animated: true)
    }
    
    let confirmAction = UIAction { [weak self] _ in
      guard let self = self else { return }
      fetchSelectedImages { images in
        self.delegate?.imagePicker(self, didComplete: images)
      }
      
      self.dismiss(animated: true)
    }
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: .Icon.xmark_black,
      primaryAction: dismissAction
    )
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", primaryAction: confirmAction)
    navigationItem.rightBarButtonItem?.isEnabled = false
    navigationItem.title = "앨범 선택"
  }
  
  func configureHierarchy() {
    view.addSubview(collectionView)
  }
  
  func makeConstraints() {
    collectionView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
      $0.bottom.equalToSuperview()
    }
  }
}

// TODO: - Extension으로 빼기
extension UINavigationController {
  func setUpAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithDefaultBackground()
    appearance.backgroundColor = .white
    
    appearance.titleTextAttributes = [
      .font: UIFont.pretendard(.body2) as Any,
      .foregroundColor: UIColor.black01 as Any
    ]
    
    navigationBar.standardAppearance = appearance
    navigationBar.compactAppearance = appearance
    navigationBar.scrollEdgeAppearance = appearance
    navigationBar.isTranslucent = false
    navigationBar.tintColor = .black01
    navigationBar.prefersLargeTitles = false
  }
}
