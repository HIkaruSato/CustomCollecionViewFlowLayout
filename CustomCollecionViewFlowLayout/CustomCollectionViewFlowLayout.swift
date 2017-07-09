//
//  CustomCollectionViewFlowLayout.swift
//  CustomCollecionViewFlowLayout
//
//  Created by amitan on 2015/06/20.
//  Copyright (c) 2015年 amitan. All rights reserved.
//

import UIKit

open class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    fileprivate static let kMaxRow = 3
    
    var maxColumn = kMaxRow
    var cellPattern:[(sideLength: CGFloat, heightLength:CGFloat, column:CGFloat, row:CGFloat)] = []
    
    fileprivate var sectionCells = [[CGRect]]()
    fileprivate var contentSize = CGSize.zero
    
    override open func prepare() {
        super.prepare()
        sectionCells = [[CGRect]]()
        
        if let collectionView = self.collectionView {
            contentSize = CGSize(width: collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right, height: 0)
            let smallCellSideLength: CGFloat = (contentSize.width - super.sectionInset.left - super.sectionInset.right - (super.minimumInteritemSpacing * (CGFloat(maxColumn) - 1.0))) / CGFloat(maxColumn)
            
            for section in (0..<collectionView.numberOfSections) {
                var cells = [CGRect]()
                let numberOfCellsInSection = collectionView.numberOfItems(inSection: section);
                var height = contentSize.height
                
                for i in (0..<numberOfCellsInSection) {
                    let position = i  % (numberOfCellsInSection)
                    let cellPosition = position % cellPattern.count
                    let cell = cellPattern[cellPosition]
                    let x = (cell.column * (smallCellSideLength + super.minimumInteritemSpacing)) + super.sectionInset.left
                    let y = (cell.row * (smallCellSideLength + super.minimumLineSpacing)) + contentSize.height + super.sectionInset.top
                    let cellwidth = (cell.sideLength * smallCellSideLength) + ((cell.sideLength-1) * super.minimumInteritemSpacing)
                    let cellheight = (cell.heightLength * smallCellSideLength) + ((cell.heightLength-1) * super.minimumLineSpacing)
                    
                    let cellRect = CGRect(x: x, y: y, width: cellwidth, height: cellheight)
                    cells.append(cellRect)
                    
                    if (height < cellRect.origin.y + cellRect.height) {
                        height = cellRect.origin.y + cellRect.height
                    }
                }
                contentSize = CGSize(width: contentSize.width, height: height)
                sectionCells.append(cells)
            }
        }
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        if let collectionView = self.collectionView {
            for  i in 0  ..< collectionView.numberOfSections {
                //var sectionIndexPath = IndexPath(item: 0, section: i)
                
                let numberOfCellsInSection = collectionView.numberOfItems(inSection: i);
                for j in 0 ..< numberOfCellsInSection {
                    let indexPath = IndexPath(row:j, section:i)
                    if let attributes = layoutAttributesForItem(at: indexPath) {
                        if (rect.intersects(attributes.frame)) {
                            layoutAttributes.append(attributes)
                        }
                    }
                }
            }
        }
        return layoutAttributes
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)
        attributes?.frame = sectionCells[indexPath.section][indexPath.row]
        return attributes
    }
    
    override open var collectionViewContentSize : CGSize {
        return contentSize
    }
}
