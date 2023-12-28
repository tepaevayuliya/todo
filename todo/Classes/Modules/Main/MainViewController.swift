//
//  MainViewController.swift
//  todo
//
//  Created by Юлия Тепаева on 31.10.2023.
//

import UIKit
import Dip

final class MainViewController: ParentViewController {
    @Injected private var networkManager: MainManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        (view as? StatefullView)?.delegate = self

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = L10n.Main.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: L10n.Main.profileButton, style: .plain, target: self, action: #selector(didTapProfileButton))
        newTaskButton.setTitle(L10n.Main.emptyButton, for: .normal)
        newTaskButton.setup(mode: PrimaryButton.Mode.large)

        collectionView.register(MainDateCell.self, forCellWithReuseIdentifier: MainDateCell.reuseID)
        collectionView.allowsMultipleSelection = true

        collectionView.register(UINib(nibName: "MainItemCell", bundle: nil), forCellWithReuseIdentifier: MainItemCell.reuseID)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { section, _ in
            switch section {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .absolute(32))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 8
                section.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
                return section
            default:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(93))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
        })

        (view as? StatefullView)?.state = .loading
        getData()
        configureRefreshControl()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        switch segue.destination {
        case let destination as NewItemViewController:
            destination.delegate = self
            destination.selectedItem = selectedItem
            destination.selectedDate = selectedDate
            selectedItem = nil
        default:
            break
        }
    }

    private func configureRefreshControl() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }

    @objc
    private func handleRefreshControl() {
        refreshСontrolIsDisplayed = true
        getData()
    }

    private var data = [TodosResponse]()
    private var sections: [(date: Date, items: [TodosResponse])] = []
    private var selectedItem: TodosResponse?
    private var selectedDate: Date? {
        didSet {
            collectionView.reloadSections(IndexSet(integer: 1))
        }
    }
    @IBOutlet private var newTaskButton: PrimaryButton!
    @IBOutlet private var collectionView: UICollectionView!

    private var refreshСontrolIsDisplayed = false

    @IBAction private func didTapNewTaskButton() {
        goToNewItem()
    }

    @objc
    private func didTapProfileButton() {
        performSegue(withIdentifier: "profile", sender: nil)
    }

    private func getData() {
        Task {
            do {
                data = try await networkManager.getTodoList()

                sections = data
                    .reduce(into: [(date: Date, items: [TodosResponse])](), { partialResult, item in
                        if let index = partialResult.firstIndex(where: { $0.date.withoutTimeStamp == item.date.withoutTimeStamp }) {
                            partialResult[index].items.append(item)
                        } else {
                            partialResult.append((date: item.date, items: [item]))
                        }
                    })
                    .sorted(by: { $0.date <= $1.date })
                collectionView.reloadData()

                if data.isEmpty {
                    (view as? StatefullView)?.state = .empty()
                } else {
                    (view as? StatefullView)?.state = .data
                    collectionView.reloadData()

                    if let selectedDate = selectedDate, let selectedDateIndex = sections.firstIndex(where: { $0.date == selectedDate }) {
                        let dateIndexPath = IndexPath(row: selectedDateIndex, section: 0)
                        collectionView.selectItem(at: dateIndexPath, animated: true, scrollPosition: [])
                    }
                }
            } catch {
                (view as? StatefullView)?.state = .empty(error: error)
            }

            if refreshСontrolIsDisplayed {
                DispatchQueue.main.async {
                    self.collectionView.refreshControl?.endRefreshing()
                    self.refreshСontrolIsDisplayed = false
                }
            }
        }
    }

    private func goToNewItem() {
        performSegue(withIdentifier: "new-item", sender: nil)
    }

    private func toggleTodo(id: String) {
        Task {
            do {
                _ = try await networkManager.toggleTodoMark(todoId: id)
                (view as? StatefullView)?.state = .loading
                getData()
            } catch {
                DispatchQueue.main.async {
                    self.snackBarView.showSnackbarVC(message: error.localizedDescription)
                }
            }
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sections.count
        default:
            if let selectedDate {
                return sections.first(where: { $0.date == selectedDate })?.items.count ?? 0
            }
            return data.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainDateCell.reuseID, for: indexPath) as? MainDateCell {
                let sectionsDate = sections[indexPath.row].date

                if Calendar.current.isDate(sectionsDate, equalTo: Date(), toGranularity: .year) {
                    cell.setup(title: DateFormatter.dMMM.string(from: sectionsDate))
                } else {
                    cell.setup(title: DateFormatter.dMMMyyyy.string(from: sectionsDate))
                }

                return cell
            }
        default:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainItemCell.reuseID, for: indexPath) as? MainItemCell {
                let item: TodosResponse?
                if let selectedDate {
                    item = sections.first(where: { $0.date == selectedDate })?.items[indexPath.row]
                } else {
                    item = data[indexPath.row]
                }
                if let item {
                    cell.setup(item: item, action: { [weak self] in
                        self?.toggleTodo(id: item.id)
                    })
                }

                return cell
            }
        }
        fatalError("\(#function) error in cell creation")
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let pathes = (0 ..< collectionView.numberOfItems(inSection: 0)).map { IndexPath(row: $0, section: 0) }
            pathes.forEach { path in
                if path != indexPath {
                    collectionView.deselectItem(at: path, animated: true)
                }
            }
            selectedDate = sections[indexPath.row].date
        default:
            collectionView.deselectItem(at: indexPath, animated: true)
            if let selectedDate {
                selectedItem = sections.first(where: { $0.date == selectedDate })?.items[indexPath.row]
            } else {
                selectedItem = data[indexPath.row]
            }
            goToNewItem()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            selectedDate = nil
        default:
            break
        }
    }
}

extension MainViewController: NewItemViewControllerDelegate {
    func didSelect(_: NewItemViewController, action: ItemAction, date: Date?) {
        getData()

        switch action {
        case .create:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                if let newDate = date, let selectedDate, !Calendar.current.isDate(selectedDate, inSameDayAs: newDate) {
                    return
                } else {
                    collectionView.scrollToItem(at: IndexPath(item: collectionView.numberOfItems(inSection: 1) - 1, section: 1), at: .bottom, animated: false)
                }
            }
        case .delete:
            break
        }
    }
}

extension MainViewController: StatefullViewDelegate {
    func statefullViewReloadData(_: StatefullView) {
        getData()
    }

    func statefullViewDidTapEmptyButton(_: StatefullView) {
        goToNewItem()
    }

    func statefullView(_: StatefullView, addChild controller: UIViewController) {
        addChild(controller)
    }

    func statefullView(_: StatefullView, didMoveToParent controller: UIViewController) {
        controller.didMove(toParent: self)
    }
}
