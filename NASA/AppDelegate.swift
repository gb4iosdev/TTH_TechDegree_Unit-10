//
//  AppDelegate.swift
//  NASA
//
//  Created by Gavin Butler on 25-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

//  Performance Testing:
//
//  See Unit test: Networking/testJSONFetch which test that NASAAPIClient.fetchJSON() meets 2.0 second expectation for rover photo fetch.
//
//  In Instruments:
//
//  Conducted Allocation tests with at least 4 generations for the following User navigations & with the associated findings:
/*      1.  From main Screen to Mars Rover photos and back.  First 2 generations showed grow ranging from 2.7-3.6MB (8-38,000 persistent objects) but this dropped drastically to 16-46KB (49-161 persistent objects) by the 3rd and 4th generations.  No leak checks detected during run (all green) and could not find any objects from my code persisting.
        2.  From Mars Rover photos screen to Post Card screen and back.  Similar behaviour noticed above except a large number of recognizable elements from my code appearing in the first generation.  Eg. UILabels indicative of the labels used in each collection view cell.  However no elements from my code were persisting in the 3rd-5th generations where growth was again very low; as low as 13KB.
        3.  From main Screen to Eye in the sky initial screen and back.  No leaks detected but more substantial growth noticed (starting at 8MB) and taking longer to settle into the KB's.
        4.  From Eye in the sky initial screen to search controller, execute search then back to Eye in the sky initial screen.  No leaks detected.  Largest contributors to growth were <non-object>, and then image related objects.  Checked MapController for code that would retain either earthImage or imageView but there was none.
        5.  From Main Screen to Astronomy Photos initial screen, and back.  Similar results to step 1 above.  No leaks and no recognizable objects from my code being retained.
        6.  In Astronomy Photos initial screen, scroll collection view select a photo, repeat.  Similar results to step 1 above.

 //  Conducted user navigation with Time Profiler running (Call Tree parameters "Separate by Thread" and "Hide System Libraries" set to on) and made the following observations & changes:
        1.  In the Mars Rover part of the app, the main contributors to time were in the cellForItemAt and layoutSizeForItemAt methods.  In cellForItemAt the instantiation of the RoverCell was a contributor but I thought the dequeingReusable code there was standed.  In layoutSizeForItemAt however, I noticed that all the measures in there could be pre-calculated so I moved them to viewDidLoad and re-ran the Time Profiler.  This reduced the % weight attributed to layoutSizeForItemAt to 0.0%.
        2.  In the Eye in the sky part of the app, a contributor to the time was in the Results Controller cellForRowAt method, specifically with the MapItem address getter.  Noticed that this had a nil coalescing check for each address component, so removed this and used String(describing:) instead.  Re-ran but this made the delay worse so restored the code.
        3.  In the Astronomy Photos section of the app, per slack advice from @theDan84, I confirmed that the network call to the high res image was indeed occupying time on the main thread with the "try? Data(contentsOf: url)" call.  Replaced the code with a URL session based fetch and re-ran the Time Profiler to confirm the time on the main thread was reduced.
 
 
*/

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

