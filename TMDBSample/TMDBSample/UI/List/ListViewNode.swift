import CoreData
import AsyncDisplayKit

// MARK: - Delegate

protocol ListViewNodeDelegate: AnyObject {
    func didSelectMovie()
}

// MARK: - Class implementation

final class ListViewNode: ASDisplayNode, CoreDataManageable {
    weak var delegate: ListViewNodeDelegate?
    /*
    private lazy var fetchRequest: NSFetchRequest<Product> = {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        let categorySort = NSSortDescriptor(key: #keyPath(Product.category), ascending: true)
        let nameSort = NSSortDescriptor(key: #keyPath(Product.name), ascending: true)
        let quantitySort = NSSortDescriptor(key: #keyPath(Product.quantityInCurrentStore), ascending: false)
        request.sortDescriptors = [categorySort, nameSort, quantitySort]
        return request
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Product> = {
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.mainContext, sectionNameKeyPath: #keyPath(Product.category), cacheName: nil)
        controller.delegate = self
        return controller
    }()
    
    // MARK: Nodes
    
    private let tableNode: ASTableNode = ASTableNode()
    
    // MARK: Lifecycle
    
    override init() {
        super.init()
        
        tableNode.delegate = self
        tableNode.dataSource = self
        searchNode.delegate = self
        automaticallyManagesSubnodes = true
        defaultLayoutTransitionDuration = 0.1
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = UIColor.deepKoamaru
        tableNode.view.separatorStyle = .none
        tableNode.backgroundColor = UIColor.deepKoamaru
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
    }
    
    // MARK: Methods
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        // Search
        searchNode.cornerRadius = 5.0
        searchNode.style.width = ASDimensionMake(constrainedSize.max.width)
        let searchInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 20.0, left: 20.0, bottom: 0.0, right: 20.0), child: searchNode)
        
        // Table
        tableNode.style.flexGrow = 1.0
        
        // General
        if let node = detailsViewNode {
            return ASInsetLayoutSpec(insets: UIEdgeInsets.zero, child: node)
        } else {
            let stackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 20.0, justifyContent: .start, alignItems: .center, children: [searchInsetSpec, tableNode])
            stackSpec.style.preferredSize = constrainedSize.max
            return stackSpec
        }
    }
     */
}


/*
// MARK: - Internal

extension TMainLeftViewNode {
    func didScanBarcode(_ code: String) -> Bool {
        guard let selectedProducts = selectedDataSourceProvider?.selectedDataSource else { return false }
        do {
            fetchRequest.predicate = scannedProductTypePredicate(code: code)
            let products = try coreDataStack.mainContext.fetch(fetchRequest)
            guard let scannedProduct = products.first else { return false }
            
            if let addedProduct = selectedProducts.first(where: { $0.product.barcode == scannedProduct.barcode }) {
                    addedProduct.quantity += 1.0
                } else {
                    selectedDataSourceProvider?.selectedDataSource.append(SelectedProduct(product: scannedProduct, quantity: 1.0))
                }
            delegate?.didUpdateSelectedDataSource()
            let successSoundId: SystemSoundID = 1394
            AudioServicesPlaySystemSound(successSoundId)
            return true
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
            return false
        }
    }
    
    func resetNode() {
        tableNode.reloadData()
        detailsViewNode = nil
        transitionLayout(withAnimation: false, shouldMeasureAsync: false, measurementCompletion: nil)
    }
}

// MARK: - Private

private extension TMainLeftViewNode {
    func scannedProductTypePredicate(code: String) -> NSPredicate {
        return NSCompoundPredicate(type: .or, subpredicates: [
            NSPredicate(format: "%K contains[c] %@", #keyPath(Product.name), code),
            NSPredicate(format: "%K contains[c] %@", #keyPath(Product.article), code),
            NSPredicate(format: "%K contains[c] %@", #keyPath(Product.manufacturer), code),
            NSPredicate(format: "%K contains[c] %@", #keyPath(Product.barcode), code),
            NSPredicate(format: "%K contains[c] %@", #keyPath(Product.category), code)])
    }

    func processSelectedProduct(_ product: Product) {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %d", #keyPath(Product.templateId), product.templateId)
        do {
            let results = try coreDataStack.mainContext.fetch(request)
            transitionToDetailsView(selectedProduct: product, products: results)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func transitionToDetailsView(selectedProduct: Product, products: [Product]) {
        detailsViewNode = TMainLeftDetailsViewNode(selectedProduct: selectedProduct, products: products)
        detailsViewNode?.delegate = self

        transitionLayout(withAnimation: true, shouldMeasureAsync: false, measurementCompletion: nil)
    }
}

// MARK: - TMainLeftDetailsViewNodeDelegate

extension TMainLeftViewNode: TMainLeftDetailsViewNodeDelegate {
    func didClose() {
        detailsViewNode = nil
        transitionLayout(withAnimation: true, shouldMeasureAsync: false, measurementCompletion: nil)
    }
    
    func didAddProduct(_ selectedProduct: SelectedProduct) {
        guard let selectedProducts = selectedDataSourceProvider?.selectedDataSource else { return }
        
        if let addedProduct = selectedProducts.first(where: { $0 == selectedProduct }) {
            addedProduct.quantity += 1.0
            delegate?.reloadRightNode()
        } else {
            selectedDataSourceProvider?.selectedDataSource.append(selectedProduct)
        }
    }
}

// MARK: - ASTableDataSource

extension TMainLeftViewNode: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let product = fetchedResultsController.object(at: indexPath)
        
        let cellNodeBlock = { () -> ASCellNode in
            return TMainLeftCellNode(product: product)
        }
        
        return cellNodeBlock
    }
}

// MARK: - ASTableDelegate

extension TMainLeftViewNode: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let product = fetchedResultsController.object(at: indexPath)
        processSelectedProduct(product)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionInfo = fetchedResultsController.sections?[section]
        
        // 40 is for container inset from left edge(20) + contentHorizontal inset from left edge(20)
        let headerView = UIView(frame: CGRect(x: 40.0, y: 0.0, width: tableView.frame.size.width - 40.0, height: 60.0))
        headerView.backgroundColor = UIColor.deepKoamaru
        
        let label = UILabel(frame: headerView.frame)
        label.attributedText = sectionInfo?.name.attributed(with: Attributes.section)
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
}

// MARK: - SearchNodeDelegate

extension TMainLeftViewNode: TSearchTextNodeDelegate {
    func didUpdateText(_ text: String) {
        searchedText = text
    }
    
    func didTapScanButton() {
        delegate?.didTapScanButton()
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TMainLeftViewNode: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableNode.reloadData()
    }
    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch (type) {
//            case .insert:
//                if let indexPath = newIndexPath {
//                    tableNode.insertRows(at: [indexPath], with: .fade)
//                }
//            case .delete:
//                if let indexPath = indexPath {
//                    tableNode.deleteRows(at: [indexPath], with: .fade)
//                }
//            case .update:
//                if let indexPath = indexPath, let node = tableNode.nodeForRow(at: indexPath) as? TMainLeftCellNode {
//                    let product = fetchedResultsController.object(at: indexPath)
//                    node.reloadNode(with: product)
//                }
//        default:
//            break
//        }
//    }
}
*/
