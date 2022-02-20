//
//  MainViewController.swift
//  FiftyHabits
//
//  Created by Khalid Kamil on 9/9/20.
//

import UIKit

class HabitsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    private var persistence = PersistenceLayer()
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
        tableView.register(
                    HabitTableViewCell.nib,
                    forCellReuseIdentifier: HabitTableViewCell.identifier
        )
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(HabitsTableViewController.longPressGestureRecognized(_:)))
        tableView.addGestureRecognizer(longpress)
        
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Habits"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        persistence.setNeedsToReloadHabits()
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        searchController.isActive = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return persistence.filteredHabits.count
        }
        return persistence.habits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HabitTableViewCell.identifier, for: indexPath) as! HabitTableViewCell
        var habit: Habit
        if isFiltering {
            habit = persistence.filteredHabits[indexPath.row]
        } else {
            habit = persistence.habits[indexPath.row]
        }
        cell.configure(habit)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedHabit: Habit
        if isFiltering {
            let selectedIndex = persistence.filteredHabits[indexPath.row]
            let index = persistence.habits.firstIndex(of: selectedIndex)
            selectedHabit = persistence.habits[index!]
        } else {
            selectedHabit = persistence.habits[indexPath.row]
        }
        let habitDetailVC = HabitDetailViewController.instantiate()
        habitDetailVC.habit = selectedHabit
        habitDetailVC.habitIndex = persistence.habits.firstIndex(of: selectedHabit)
        navigationController?.pushViewController(habitDetailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      switch editingStyle {
        case .delete:

            let habitToDelete = persistence.habits[indexPath.row]
            let habitIndexToDelete = indexPath.row

            let deleteAlert = UIAlertController(habitTitle: habitToDelete.title) {
                self.persistence.delete(habitIndexToDelete)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }

            self.present(deleteAlert, animated: true)

       default:
          break
       }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
      persistence.swapHabits(habitIndex: sourceIndexPath.row, destinationIndex: destinationIndexPath.row)
    }
    
    @objc func longPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: locationInView)
        struct My {
        static var cellSnapshot : UIView? = nil
        static var cellIsAnimating : Bool = false
        static var cellNeedToShow : Bool = false
        }
        struct Path {
        static var initialIndexPath : IndexPath? = nil
        }
        switch state {
        case UIGestureRecognizerState.began:
        if indexPath != nil {
            Path.initialIndexPath = indexPath
            let cell = tableView.cellForRow(at: indexPath!) as UITableViewCell?
            My.cellSnapshot  = snapshotOfCell(cell!)
            var center = cell?.center
            My.cellSnapshot!.center = center!
            My.cellSnapshot!.alpha = 0.0
            tableView.addSubview(My.cellSnapshot!)
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                center?.y = locationInView.y
                My.cellIsAnimating = true
                My.cellSnapshot!.center = center!
                My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                My.cellSnapshot!.alpha = 0.98
                cell?.alpha = 0.0
        }, completion: { (finished) -> Void in
        if finished {
        My.cellIsAnimating = false
        if My.cellNeedToShow {
        My.cellNeedToShow = false
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
        cell?.alpha = 1
        })
        } else {
        cell?.isHidden = true
        }
        }
        })
        }
        case UIGestureRecognizerState.changed:
        if My.cellSnapshot != nil {
        var center = My.cellSnapshot!.center
        center.y = locationInView.y
        My.cellSnapshot!.center = center
        if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
            persistence.habits.insert(persistence.habits.remove(at: Path.initialIndexPath!.row), at: indexPath!.row)
        tableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
        Path.initialIndexPath = indexPath
        }
        }
        default:
        if Path.initialIndexPath != nil {
            let cell = tableView.cellForRow(at: Path.initialIndexPath!) as UITableViewCell?
        if My.cellIsAnimating {
        My.cellNeedToShow = true
        } else {
        cell?.isHidden = false
        cell?.alpha = 0.0
        }
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
        My.cellSnapshot!.center = (cell?.center)!
        My.cellSnapshot!.transform = CGAffineTransform.identity
        My.cellSnapshot!.alpha = 0.0
        cell?.alpha = 1.0
        }, completion: { (finished) -> Void in
        if finished {
        Path.initialIndexPath = nil
        My.cellSnapshot!.removeFromSuperview()
        My.cellSnapshot = nil
               }
            })
          }
        }
        persistence.saveHabits()
    }
    
    func snapshotOfCell(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
    func filterContentForSearchText(_ searchText: String) {
        persistence.filteredHabits = persistence.habits.filter { (habit: Habit) -> Bool in
        return habit.title.lowercased().contains(searchText.lowercased())
      }
      
      tableView.reloadData()
    }

}

extension HabitsTableViewController {
    
    func setupNavBar() {
        title = "FiftyHabits"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pressAddHabit(_:)))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    @objc func pressAddHabit(_ sender: UIBarButtonItem) {
        let addHabitVC = AddHabitViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: addHabitVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

extension UIAlertController {
    convenience init(habitTitle: String, comfirmHandler: @escaping () -> Void) {
        self.init(title: "Delete Habit", message: "Are you sure you want to delete \(habitTitle)?", preferredStyle: .actionSheet)

        let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { _ in
            comfirmHandler()
        }
        self.addAction(confirmAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        self.addAction(cancelAction)
    }
}
