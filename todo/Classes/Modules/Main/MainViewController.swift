//
//  MainViewController.swift
//  todo
//
//  Created by Юлия Тепаева on 31.10.2023.
//

import UIKit

final class MainViewController: ParentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        (view as? StatefullView)?.delegate = self
        navigationItem.backButtonDisplayMode = .minimal

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = L10n.Main.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: L10n.Main.profileButton, style: .plain, target: self, action: nil)
        newTaskButton.setTitle(L10n.Main.emptyButton, for: .normal)
        newTaskButton.setup(mode: PrimaryButton.Mode.large)

        collectionView.register(UINib(nibName: "MainItemCell", bundle: nil), forCellWithReuseIdentifier: MainItemCell.reuseID)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: {_, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(93))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        })

        getData()
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

    private var data = [TodosResponse]() //второй вариант записи
    //    private var data: [TodosResponse] = [TodosResponse(title: "sdfghj", deadline: Date(timeIntervalSince1970: 0)), MainDataItem(title: "324567", deadline: Date(timeIntervalSince1970: 10000000000000))]
    private var selectedItem: TodosResponse?

    @IBOutlet private var newTaskButton: PrimaryButton!

    @IBOutlet private var collectionView: UICollectionView!

    @IBAction private func didTapNewTaskButton() {
        switchToNewItem()
    }

    private func getData() {
        Task {
            do {
                (view as? StatefullView)?.state = .loading

                data = try await NetworkManagers.shared.request(urlPart: "todos", method: "GET")

                if data.isEmpty {
                    (view as? StatefullView)?.state = .empty()
                } else {
                    (view as? StatefullView)?.state = .data
                    collectionView.reloadData()
                }
            } catch {
                (view as? StatefullView)?.state = .empty(error: error)
            }
        }
    }

    private func switchToNewItem() {
        performSegue(withIdentifier: "new-item", sender: nil)
    }

    private func toggleToDo(id: String) {
        Task {
            do {
                _ = try await NetworkManagers.shared.request(urlPart: "todos/mark/\(id)", method: "PUT") as EmptyResponse
                getData()
            } catch {
                DispatchQueue.main.async {
                    self.showAlertVC(massage: error.localizedDescription)
                }
            }
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainItemCell.reuseID, for: indexPath) as? MainItemCell {
            let item = data[indexPath.row]
            cell.setup(item: item, action: { [weak self] in
                self?.toggleToDo(id: item.id)
            })
            return cell
        }
        fatalError("\(#function) error in cell creation")
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = data[indexPath.row]
        collectionView.deselectItem(at: indexPath, animated: true)

        switchToNewItem()
    }
}

extension MainViewController: NewItemViewControllerDelegate {
    func didSelect(_ vc: NewItemViewController) {
        getData()
    }
}

extension MainViewController: StatefullViewDelegate {
    func statefullViewReloadData(_: StatefullView) {
        getData()
    }

    func statefullViewDidTapEmptyButton(_: StatefullView) {
        switchToNewItem()
    }

    func statefullView(_: StatefullView, addChild controller: UIViewController) {
        addChild(controller)
    }

    func statefullView(_: StatefullView, didMoveToParent controller: UIViewController) {
        controller.didMove(toParent: self)
    }
}
