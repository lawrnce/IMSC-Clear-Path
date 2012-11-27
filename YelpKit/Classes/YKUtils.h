//
//  YKUtils.h
//  YelpKit
//
//  Created by Gabriel Handford on 12/11/09.
//  Copyright 2009 Yelp. All rights reserved.
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

id YKRandomChoice(id object, ...);

id YKRandomChoiceFromArray(NSArray *array);

NSMutableArray *YKCreateNonRetainingArray();

// Returns the current memory usage in bytes
NSUInteger YKReportMemory(void);

NSString *YKNSStringFromNSTimeInterval(NSTimeInterval timeInterval);

/*!
 String formatted from cents and currency code.
 @param cents Cents, 1200 == 12.00
 @param currentCode Currency code, used to show the correct currency symbol before or after
 
 For example,

    YKNSStringFromCurrencyAmountInCentsAndCode(1200, @"USD") => "$12"
    YKNSStringFromCurrencyAmountInCentsAndCode(5099, @"EUR") => "€50.99"

 */
NSString *YKNSStringFromCurrencyAmountInCentsAndCode(NSInteger cents, NSString *currencyCode);

/*!
 Dispatch block after current run loop.
 @param block Block
 */
void YKDispatch(dispatch_block_t block);

/*!
 Dispatch block after delay.
 @param seconds Seconds delay
 @param block Block
 */
void YKDispatchAfter(NSTimeInterval seconds, dispatch_block_t block);