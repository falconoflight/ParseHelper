//
//  ParseLogic.swift
//  One
//
//  Created by Jatinder Kumar on 7/2/15.
//  Copyright © 2015 Vasu Laroiya. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class ParseLogic: NSObject {
    static let sharedInstance = ParseLogic()
    
    /**
    Logs the user in
    */
    
    func loginUser(email:String, password:String, completion:((success:Bool, errorMesssage:String?)->Void)?) {
        PFUser.logInWithUsernameInBackground(email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()), password: password, block: { (user:PFUser?, error:NSError?) -> Void in
            if error == nil {
                if completion != nil {
                    completion!(success: true, errorMesssage: nil)
                }
            } else {
                if completion != nil {
                    completion!(success: false, errorMesssage: getErrorMessage(error!))
                }
            }
        })
    }
    
    /**
    Creates a new user
    */
    
    func createUser(fullName:String?, email:String, password:String, confirmPassword:String?, completion:((success:Bool, error:String?)->Void)?) {
        let user = PFUser()
        user.email = email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        user.username = user.email
        
        if confirmPassword != nil {
            
            if password.length > 0 && confirmPassword!.length > 0 {
                
                if password == confirmPassword {
                    user.password = password
                    
                    user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                        if error == nil {
                            if completion != nil {
                                completion!(success: true, error: nil)
                            }
                        } else {
                            if completion != nil {
                                var errorMessage = getErrorMessage(error!)
                                let email = email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                                errorMessage = errorMessage.stringByReplacingOccurrencesOfString(" \(email)", withString: "")
                                completion!(success: false, error: errorMessage)
                            }
                        }
                    })
                } else {
                    if completion != nil {
                        completion!(success: false, error: "Passwords do not match")
                    }
                }
            } else {
                if completion != nil {
                    completion!(success: false, error: "Enter a valid password")
                }
            }
        } else {
            user.password = password
            
            user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    if completion != nil {
                        completion!(success: true, error: nil)
                    }
                } else {
                    if completion != nil {
                        var errorMessage = getErrorMessage(error!)
                        let email = email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                        errorMessage = errorMessage.stringByReplacingOccurrencesOfString(" \(email)", withString: "")
                        completion!(success: false, error: errorMessage)
                    }
                }
            })
        }
    }
    
    /**
    Sends password reset email
    */
    
    func userForgotPassword(var email:String, completion:((success:Bool, error:String?)->Void)?) {
        email = email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        PFUser.requestPasswordResetForEmailInBackground(email) { (success, error) -> Void in
            if error == nil {
                if completion != nil {
                    completion!(success: true, error: nil)
                }
            } else {
                if completion != nil {
                    completion!(success: false, error: getErrorMessage(error!).stringByReplacingOccurrencesOfString("with email \(email)", withString: "with this email"))
                }
            }
        }
    }
    
    /**
    Login user using Facebook with read permissions
    */
    
    func loginUserUsingFacebookReadPermissions(permissions:[AnyObject]?, completion:((success:Bool, error:String?)->Void)?) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if error == nil {
                if completion != nil {
                    completion!(success: true, error: nil)
                }
            } else {
                if completion != nil {
                    completion!(success: false, error: getErrorMessage(error!))
                }
            }
        }
    }
    
    /**
    Login user using Facebook with publish permissions
    */
    
    func loginUserUsingFacebookPublishPermissions(permissions:[AnyObject]?, completion:((success:Bool, error:String?)->Void)?) {
        PFFacebookUtils.logInInBackgroundWithPublishPermissions(permissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if error == nil {
                if completion != nil {
                    completion!(success: true, error: nil)
                }
            } else {
                if completion != nil {
                    completion!(success: false, error: getErrorMessage(error!))
                }
            }
        }
    }
    
    /**
    Link user to Facebook with read permissions
    */
    
    func linkFacebookToUserUsingReadPermissions(permissions:[AnyObject]?, completion:((success:Bool, error:String?)->Void)?) {
        if let user = PFUser.currentUser() {
            if !PFFacebookUtils.isLinkedWithUser(user) {
                PFFacebookUtils.linkUserInBackground(user, withReadPermissions: permissions, block: { (success, error) -> Void in
                    if error == nil {
                        if completion != nil {
                            completion!(success: true, error: nil)
                        }
                    } else {
                        if completion != nil {
                            completion!(success: false, error: getErrorMessage(error!))
                        }
                    }
                })
            }
        }
    }

    /**
    Link user to Facebook with publish permissions
    */
    
    func linkFacebookToUserUsingPublishPermissions(permissions:[AnyObject], completion:((success:Bool, error:String?)->Void)?) {
        if let user = PFUser.currentUser() {
            if !PFFacebookUtils.isLinkedWithUser(user) {
                PFFacebookUtils.linkUserInBackground(user, withPublishPermissions: permissions, block: { (success, error) -> Void in
                    if error == nil {
                        if completion != nil {
                            completion!(success: true, error: nil)
                        }
                    } else {
                        if completion != nil {
                            completion!(success: false, error: getErrorMessage(error!))
                        }
                    }
                })
            }
        }
    }
    
    /**
    Login user using Twitter
    */
    
    func loginUserUsingTwitter(completion:((success:Bool, error:String?)->Void)?) {
        PFTwitterUtils.logInWithBlock { (user, error) -> Void in
            if error == nil {
                if completion != nil {
                    completion!(success: true, error: nil)
                }
            } else {
                if completion != nil {
                    completion!(success: false, error: getErrorMessage(error!))
                }
            }
        }
    }
    
    /**
    Link user using Twitter
    */
    
    func linkTwitterToUser(completion:((success:Bool, error:String?)->Void)?) {
        if let user = PFUser.currentUser() {
            PFTwitterUtils.linkUser(user, block: { (success, error) -> Void in
                if error == nil {
                    if completion != nil {
                        completion!(success: true, error: nil)
                    }
                } else {
                    if completion != nil {
                        completion!(success: false, error: getErrorMessage(error!))
                    }
                }
            })
        }
    }

    /**
    Saves object to a specific class on Parse server
    */
    
    func saveObject(className:String, parameters:[String:AnyObject]?, completion:((success:Bool, error:String?)->Void)?) {
        let objectClass = PFObject(className: className)

        if parameters != nil {
            for parameter in parameters! {
                objectClass[parameter.0] = parameter.1
            }
        }

        objectClass.saveInBackgroundWithBlock({ (success, error) -> Void in
            if error == nil {
                if completion != nil {
                    completion!(success: true, error: nil)
                }
            } else {
                if completion != nil {
                    completion!(success: false, error: getErrorMessage(error))
                }
            }
        })
    }
    
    /**
    Retrieves objects from a specific class on Parse server
    */
    
    func retrievesObject(className:String, objectID:String?, parameters:[String:AnyObject]?, completion:(success:Bool, error:String?, object:[AnyObject]?)->Void) {
        let query = PFQuery(className:className)
        
        if parameters != nil {
            for parameter in parameters! {
                query.whereKey(parameter.0, equalTo: parameter.1)
            }
        }
        
        if objectID != nil {
            query.getObjectInBackgroundWithId(objectID!, block: { (object, error) -> Void in
                if error == nil {
                    completion(success: true, error: nil, object: [object as! AnyObject])
                } else {
                    completion(success: false, error: getErrorMessage(error), object: nil)
                }
            })
        } else {
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil {
                    completion(success: true, error: nil, object: objects)
                } else {
                    completion(success: false, error: getErrorMessage(error), object: nil)
                }

            })
        }
    }
    
    /**
    Saves a object to local data storage
    */
    
    func saveObjectToLocalDataStorage(className:String, parameters:[String:AnyObject], pinName:String, completion:((success:Bool, error:String?)->Void)?) {
        let objectClass = PFObject(className: className)

        for parameter in parameters {
            objectClass[parameter.0] = parameter.1
        }
        

        objectClass.pinInBackgroundWithName(pinName, block: { (success, error) -> Void in
            if error == nil {
                if completion != nil {
                    completion!(success: true, error: nil)
                }
            } else {
                if completion != nil {
                    completion!(success: false, error: getErrorMessage(error))
                }
            }
        })
    }
    
    /**
    Retrieves objects from local data storage
    */
    
    func retrieveObjectsFromLocalDataStorage(className:String, pinName:String, completion:(success:Bool, error:String?, result:[AnyObject]?)->Void) {
        let query = PFQuery(className: className)
        query.fromPinWithName(pinName)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                completion(success: true, error: nil, result: objects)
            } else {
                completion(success: false, error: getErrorMessage(error), result: nil)
            }
        }
    }
    
    /**
    Deletes object from local data storage
    */
    
    func unpinObject(pinName:String, completion:((success:Bool, error:String?)->Void)?) {
        PFObject.unpinAllObjectsInBackgroundWithName(pinName, block: { (success, error) -> Void in
            if error == nil {
                if completion != nil {
                    completion!(success: true, error: nil)
                }
            } else {
                if completion != nil {
                    completion!(success: false, error: getErrorMessage(error))
                }
            }
        })
    }
    
    /**
    Deletes object from Parse server
    */
    
    func deleteObject(object:PFObject, parameters:[String]?, completion:((success:Bool, error:String?)->Void)?) {
        if parameters == nil {
            object.deleteInBackgroundWithBlock { (success, error) -> Void in
                if error == nil {
                    if completion != nil {
                        completion!(success: true, error: nil)
                    }
                } else {
                    if completion != nil {
                        completion!(success: false, error: getErrorMessage(error))
                    }
                }
            }
        } else {
            for key in parameters! {
                object.removeObjectForKey(key)
            }
            
            object.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    if completion != nil {
                        completion!(success: true, error: nil)
                    }
                } else {
                    if completion != nil {
                        completion!(success: false, error: getErrorMessage(error))
                    }
                }
            })
        }
    }
}

extension String {
    var length: Int {
        return count(self)
    }
}

public func getErrorMessage(error:NSError?) -> String {
    var errorMessage = ""
    if error != nil {
        errorMessage = error!.localizedDescription
        errorMessage.replaceRange(errorMessage.startIndex...errorMessage.startIndex, with: String(errorMessage[errorMessage.startIndex]).capitalizedString)
    } else {
        errorMessage = "Unexpected error occured. Please try again"
    }
    return errorMessage
}