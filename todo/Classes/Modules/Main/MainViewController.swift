//
//  MainViewController.swift
//  todo
//
//  Created by Юлия Тепаева on 31.10.2023.
//

import UIKit
struct MainDataItem {
    let title: String
    let deadline: Date
    let isCompleted: Bool = true
}

final class MainViewController: ParentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        (view as? StatefullView)?.delegate = self
        navigationItem.backButtonDisplayMode = .minimal

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = L10n.Main.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: L10n.Main.profileButton, style: .plain, target: self, action: nil)

//        collectionView.register(MainItemCell.self, forCellWithReuseIdentifier: MainItemCell.reuseID)
        collectionView.register(UINib(nibName: "MainItemCell", bundle: nil), forCellWithReuseIdentifier: MainItemCell.reuseID)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: {_, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(93))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        })
        reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.destination {
        case let destination as NewItemViewController:
            destination.delegate = self
            destination.selectedItem = selectedItem
            selectedItem = nil
        default:
            break
        }
    }

    private var data: [MainDataItem] = [MainDataItem(title: "sdfghj", deadline: Date(timeIntervalSince1970: 0)), MainDataItem(title: "324567", deadline: Date(timeIntervalSince1970: 10000000000000))]
//    private var data = [MainDataItem]() //второй вариант записи

    private var selectedItem: MainDataItem?

    @IBOutlet private var collectionView: UICollectionView!

    private func reloadData() {
        (view as? StatefullView)?.state = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            (self?.view as? StatefullView)?.state = .empty()
        }
//        emptyView.isHidden = !data.isEmpty
        if !data.isEmpty {
            collectionView.reloadData()
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainItemCell.reuseID, for: indexPath) as? MainItemCell {
            cell.setup(item: data[indexPath.row])
            return cell
        }
        fatalError("\(#function) error in cell creation")
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = data[indexPath.row]
        collectionView.deselectItem(at: indexPath, animated: true)

        performSegue(withIdentifier: "new-item", sender: nil)
    }
}

extension MainViewController: NewItemViewControllerDelegate {
    func didSelect(_ vc: NewItemViewController, data: NewItemData) {
        self.data.append(.init(title: data.title, deadline: data.deadline))
        reloadData()
    }
}

extension MainViewController: StatefullViewDelegate {
    func statefullViewReloadData(_: StatefullView) {}

    func statefullViewDidTapEmptyButton(_: StatefullView) {}

    func statefullView(_: StatefullView, addChild controller: UIViewController) {
        addChild(controller)
    }

    func statefullView(_: StatefullView, didMoveToParent controller: UIViewController) {
        controller.didMove(toParent: self)
    }
}
