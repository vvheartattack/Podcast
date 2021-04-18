//
//  AppDelegate.swift
//  Podcast
//
//  Created by Mika on 2021/2/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GRDBHelper.shared.createSubscribedPodcastTable()
//        let podcast = Podcast(trackId: 1472032462, trackName: "Nice Try", artistName: "Nice Try Podcast", artworkUrl600: "https://is4-ssl.mzstatic.com/image/thumb/Podcasts124/v4/5a/c2/73/5ac2732b-39c1-7ca1-d8b4-f780aeaded23/mza_1074270643340895275.jpg/600x600bb.jpg", trackCount: 71, feedUrl: "https://nicetrypod.com/episodes/feed.xml")
//        let podcast2 = Podcast(trackId: 1512341530, trackName: "郭德纲于谦助眠相声集", artistName: "酸奶酒鬼", artworkUrl600: "https://is2-ssl.mzstatic.com/image/thumb/Podcasts123/v4/0c/71/97/0c71972e-d8e6-aa1b-e2ba-da5fed83e013/mza_1869713097538247862.jpg/600x600bb.jpg", trackCount: 11, feedUrl: "http://www.ximalaya.com/album/37742509.xml")
//        GRDBHelper.shared.save(podcast)
//        GRDBHelper.shared.save(podcast2)
        
//        print(GRDBHelper.shared.fetchAll(Podcast.self))
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

