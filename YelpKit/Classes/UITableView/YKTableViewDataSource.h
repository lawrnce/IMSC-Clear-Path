//
//  YKTableViewDataSource.h
//  YelpKit
//
//  Created by Gabriel Handford on 5/13/12.
//  Copyright (c) 2012 Yelp. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "YKTableViewCellDataSource.h"

/*!
 Fail block. If error is nil, it means the request was cancelled.
 */
typedef UIView * (^YKTableViewSectionHeaderViewBlock)(NSInteger section, NSString *sectionTitle, NSInteger rowCount);
typedef UIView * (^YKTableViewSectionFooterViewBlock)(NSInteger section, NSInteger rowCount);

@class YKTableViewDataSource;

typedef void (^YKTableViewDidScrollToBottomBlock)(YKTableViewDataSource *dataSource);

@interface YKTableViewDataSource : NSObject <UITableViewDelegate, UITableViewDataSource> {  
  NSMutableDictionary */*Row -> NSMutableArray of id<YKTableViewCellDataSource>*/_cellDataSourceSections;
    
  NSMutableDictionary */*Row -> NSString*/_sectionHeaderTitles;
  NSArray *_sectionIndexTitles;
  
  NSInteger _sectionCount; // We need to keep section count stable since row animating requires tht we don't add or remove sections while animating.
  
  YKTableViewSectionHeaderViewBlock _sectionHeaderViewBlock;
  YKTableViewSectionFooterViewBlock _sectionFooterViewBlock;  
  YKTableViewDidScrollToBottomBlock _tableViewDidScrollToBottomBlock;
  
  BOOL _scrollDidNotify;
  
  id<UIScrollViewDelegate> _scrollViewDelegate;
}

@property (retain, nonatomic) NSArray *sectionIndexTitles;
@property (copy, nonatomic) YKTableViewSectionHeaderViewBlock sectionHeaderViewBlock;
@property (copy, nonatomic) YKTableViewSectionFooterViewBlock sectionFooterViewBlock;  
@property (copy, nonatomic) YKTableViewDidScrollToBottomBlock tableViewDidScrollToBottomBlock;
@property (assign, nonatomic) id<UIScrollViewDelegate> scrollViewDelegate;

/*!
 Create empty data source.
 */
+ (YKTableViewDataSource *)dataSource;

/*!
 Create data source with cell data sources.
 @param cellDataSources
 */
+ (YKTableViewDataSource *)dataSourceWithCellDataSources:(NSArray */*of id<YKTableViewCellDataSource>*/)cellDataSources;

/*!
 Clear section.
 @param section Section to clear
 @param indexPaths If set, adds the index paths we removed
 */
- (void)clearSection:(NSInteger)section indexPaths:(NSMutableArray **)indexPaths;

/*!
 Get index path for last row in the last section.
 @result Last index path
 */
- (NSIndexPath *)lastIndexPath;

/*!
 Number of sections.
 @result Number of sections
 */
- (NSInteger)sectionCount;

/*!
 Number of cells for a section.
 @param section Section to count
 @result Cell count in section
 */
- (NSInteger)countForSection:(NSInteger)section;

/*!
 Count for all sections.
 */
- (NSInteger)count;

- (void)setSectionHeaderTitle:(NSString *)title section:(NSInteger)section;

- (void)setSectionHeaderTitles:(NSArray *)titles;

/*! 
 Clear all cells.
 */
- (void)clearAll;

/*!
 Clear header views and titles.
 */
- (void)clearHeaders;

- (id<YKTableViewCellDataSource>)cellDataSourceAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)cellForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)addCellDataSource:(id<YKTableViewCellDataSource>)cellDataSource section:(NSInteger)section;

/*!
 Add cell data sources.
 @param array List of id<YKTableViewCellDataSource>
 @param section Section to append to
 @param indexPaths If specified, adds NSIndexPath's that were added (for help animating)
 */
- (void)addCellDataSources:(NSArray */*of id<YKTableViewCellDataSource>*/)array section:(NSInteger)section indexPaths:(NSMutableArray **)indexPaths;

/*!
 Truncate section to remove all cells after count.
 @param count
 @param section
 @param indexPaths Index paths we removed
 */
- (void)truncateCellDataSourcesToCount:(NSInteger)count section:(NSInteger)section indexPaths:(NSMutableArray **)indexPaths;

- (void)removeCellDataSourceAtIndexPaths:(NSArray *)indexPaths;
- (BOOL)removeCellDataSourceAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)removeCellDataSourceForRow:(NSInteger)row inSection:(NSInteger)section;

- (void)replaceCellDataSource:(id<YKTableViewCellDataSource>)cellDataSource indexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)indexPathForCellDataSource:(id<YKTableViewCellDataSource>)cellDataSource;

- (void)moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

- (void)insertCellDataSource:(id<YKTableViewCellDataSource>)cellDataSource atIndexPath:(NSIndexPath *)indexPath;

/*!
 Insert cell data sources.
 @param array List of id<YKUITableViewCellDataSource>
 @param section Section to insert to
 @param atIndex Index to insert at
 @param indexPaths If specified, adds NSIndexPath's that were added (for help animating)
 */
- (void)insertCellDataSources:(NSArray */*of id<YKTableViewCellDataSource>*/)array section:(NSInteger)section atIndex:(NSInteger)index indexPaths:(NSMutableArray **)indexPaths;

/*!
 Enumerator for cell data sources.
 */
- (NSEnumerator *)enumeratorForCellDataSources;

/*!
 Replace cell data sources.
 @param array List of id<YKUITableViewCellDataSource>
 @param section Section to append to
 */
- (void)setCellDataSources:(NSArray */*of id<YKTableViewCellDataSource>*/)array section:(NSInteger)section;

- (NSMutableArray *)cellDataSourcesForSection:(NSInteger)section;

@end


@interface YKTableViewDataSourceEnumerator : NSEnumerator { 
  YKTableViewDataSource *_dataSource;
  NSInteger _section;
  NSInteger _index;
}
@property (readonly, nonatomic) NSIndexPath *indexPath;

- (id)initWithDataSource:(YKTableViewDataSource *)dataSource;

@end