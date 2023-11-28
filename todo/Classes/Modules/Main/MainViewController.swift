//
//  MainViewController.swift
//  todo
//
//  Created by Юлия Тепаева on 31.10.2023.
//

import UIKit

private var isLoading = false

final class MainViewController: ParentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = L10n.Main.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: L10n.Main.profileButton, style: .plain, target: self, action: nil)
        newTaskButton.setTitle(L10n.Main.emptyButton, for: .normal)
        newTaskButton.setup(mode: PrimaryButton.Mode.large)

        collectionView.register(UINib(nibName: "MainItemCell", bundle: nil), forCellWithReuseIdentifier: MainItemCell.reuseID)
        collectionView.allowsMultipleSelection = true
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
        reloadData()
        switch segue.destination {
        case let destination as EmptyViewController:
            self.destination = destination
        case let destination as NewItemViewController:
            destination.delegate = self
        default:
            break
        }
    }

    private var data = [TodosResponse]()
    private var state: EmptyViewController.State?
    private var isLoading = true

    private weak var destination: EmptyViewController?

    @IBOutlet private var newTaskButton: PrimaryButton!

    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var emptyView: UIView!

    @IBAction private func didTabNewTaskButton(_ sender: PrimaryButton) {
        performSegue(withIdentifier: "new-item", sender: nil)
    }

    private func reloadData() {
        guard !isLoading else {
            emptyView.isHidden = true
            collectionView.isHidden = true
            newTaskButton.isHidden = true
            return
        }
        
        if data.isEmpty {
            collectionView.isHidden = true
            emptyView.isHidden = !data.isEmpty
            destination?.state = state ?? .empty
            destination?.action = { [weak self] in
                self?.performSegue(withIdentifier: "new-item", sender: nil)
            }
        } else {
            collectionView.isHidden = false
            newTaskButton.isHidden = false
            collectionView.reloadData()
        }
    }

    private func getData() {
        Task {
            do {
                isLoading = true
                data = try await NetworkManagers.shared.request(url: "todos", metod: "GET", requestBody: GetAllTasks(), response: data, isDateExpected: true, isRequestNil: true)
                isLoading = false
                reloadData()
            } catch {
                isLoading = false
                data = []
                state = .error(.otherError)//error)
                reloadData()
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
            cell.setup(item: data[indexPath.row])
            return cell
        }
        fatalError("\(#function) error in cell creation")
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = data[indexPath.row]
        Task {
            do {
                _ = try await NetworkManagers.shared.request(url: "todos/mark/\(selectedItem.id)", metod: "PUT", requestBody: GetAllTasks(), response: EmptyResponse(), isDateExpected: false, isRequestNil: true)
                getData()
            } catch {
                DispatchQueue.main.async {
                    let alertVC = UIAlertController(title: "Ошибка!", message: error.localizedDescription, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
                    self.present(alertVC, animated: true)
                }
            }
        }
    }
}

extension MainViewController: NewItemViewControllerDelegate {
    func didSelect(_ vc: NewItemViewController) {}
}
