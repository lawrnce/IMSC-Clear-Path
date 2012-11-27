//
//  YKJSONRequest.h
//  YelpKit
//
//  Created by Gabriel Handford on 5/1/12.
//  Copyright (c) 2012 Yelp. All rights reserved.
//

#import "YKURLRequest.h"

/*!
 YKURLRequest for JSON HTTP requests.
 */
@interface YKJSONRequest : YKURLRequest 
@end


/*!
 JSON error from HTTP request.
 
 If JSON error response is of the form:
    
    {"error": {"id": "ERROR_ID", "description": "This is the localized error description"}}
 
 then the errorId will be set, and the localizedDescription for YKError will be set.
 */
@interface YKHTTPJSONError : YKHTTPError {
  NSDictionary *_JSONDictionary;
  NSString *_errorId; // Set if JSON error response
}

/*!
 Error identifier.
 Set if JSON error response is of the form, {"error": {"id": "ERROR_ID"}}.
 */
@property (readonly, nonatomic) NSString *errorId; 

/*!
 JSON dictionary for response data, or nil if the response data is not a JSON Dictionary.
 */
@property (readonly, nonatomic) NSDictionary *JSONDictionary;

@end
