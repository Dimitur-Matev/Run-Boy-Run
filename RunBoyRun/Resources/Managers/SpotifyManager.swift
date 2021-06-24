//
//  SpotifyManager.swift
//  NowPlayingView
//
//  Created by Olaf Janssen on 11/09/2019.
//  Copyright © 2019 Spotify. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let SpotifyConnected = Notification.Name("SpotifyConnected")
    static let SpotifyConnecting = Notification.Name("SpotifyConnecting")
    static let SpotifyDisconnected = Notification.Name("SpotifyDisconnected")
    static let SpotifyConnectRequested = Notification.Name("SpotifyConnectRequested")
    static let SpotifyDisconnectRequested = Notification.Name("SpotifyDisconnectRequested")
}

extension SPTAppRemotePlaybackOptionsRepeatMode: CustomStringConvertible {
    public var description: String {
        switch (rawValue) {
        case 0:
            return "off"
        case 1:
            return "track"
        case 2:
            return "context"
        default:
            return "invalid"
        }
    }
}

/**
 Manages the connection to the Spotify app/SDK/player
 */
class SpotifyManager: NSObject, SPTAppRemotePlayerStateDelegate, SPTAppRemoteDelegate, SPTSessionManagerDelegate {
    
    /// Singleton instance so that  Spotify can be controlled from anywhere in the app
    static let sharedInstance: SpotifyManager = { SpotifyManager() }()
    
    private let SpotifyClientID = "ccf7e3805d5e4e27b6dc9f4a9beb4b17"
    private let SpotifyRedirectURL = URL(string: "RunBoyRun://spotify-login-callback")!
    //    static private let kAccessTokenKey = "access-token-key"
    static private let kSessionKey = "cFJLyifeUJUBFWdHzVbykfDmPHtLKLGzViHW9aHGmyTLD8hGXC"
    
    private var isRecording = false
    public var isPlaying = false
    public var shouldBeConnected = false
    public var reconnectCounter = 0
    private let reconnectLimit = 3
    
    private let keepAliveInterval = 60.0
    private var keepAliveTimer : Timer?
    
    /// A queue of Spotify remote commands that needs to be handled subsequently, each time awaiting a response.
    private var queue : [() -> ()] = []
    private var isQueueBusy  = false
    
    override init() {
        super.init()
        print(SpotifyClientID)
        print(SpotifyRedirectURL)
        print(appRemote.connectionParameters.authenticationMethods)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    /**
     Start recording the Spotify player events. Should be called when a run session has started.
     */
    public func startRecording() {
        print("start recording spotify events")
        isRecording = true
        getPlayerState()
        
        keepAliveTimer = Timer.scheduledTimer(withTimeInterval: keepAliveInterval, repeats: true, block: { timer in
            self.getPlayerState()
        })

    }
    
    
    /**
     Stop recording the Spotify player events. Should be called at the end of the run session.
     */
    public func stopRecording() {
        isRecording = false
        keepAliveTimer?.invalidate()
    }
    
    /**
     Returns whether there is a valid connection with the Spotify app.
     */
    public func isConnected() -> Bool {
        return self.appRemote.isConnected
    }
    
    /**
     Connect to the Spotify app by authorizing. You need to do this to ensure that the Spotify app is playing, otherwise it will not connect
     */
    public func authorize() {
        print("Authorizing Spotify")
        sendLog(message: "Authorizing")
        
        self.appRemote.authorizeAndPlayURI("")
        self.isPlaying = true
    }
    
    /**
     Method to be called when you intentially want to disconnect the Spotfy connection.
     */
    public func disconnect() {
        print("MANUALLY DISCONNECT SPOTIFY")
        self.shouldBeConnected = false
        appRemoteDisconnect()
    }
    
    /**
     Set the playhead of the Spotify player to the given position in millis
     */
    public func playerSeek(seek : Int) {
        queue.append {
            self.appRemote.playerAPI?.seek(toPosition: seek, callback: self.defaultCallback)
        }
    }
    
    /**
     Set shuffle mode of the player
     */
    public func setShuffle(shuffle : Bool) {
        queue.append {
            self.appRemote.playerAPI?.setShuffle(shuffle, callback: self.defaultCallback)
        }
        
        queue.append {
            self.getPlayerState()
        }
    }
    
    /**
     Set repeat mode of the player
     */
    public func setRepeatMode(repeatMode : SPTAppRemotePlaybackOptionsRepeatMode) {
        queue.append {
            self.appRemote.playerAPI?.setRepeatMode(repeatMode, callback: self.defaultCallback)
        }
        
        queue.append {
            self.getPlayerState()
        }
    }
    
    /**
     Play a Spotify track based on its uri and seek position in millis.
     */
    public func playerPlayTrack(uri : String, seek : Int) {
        self.isPlaying = true
        
        queue.append {
            self.appRemote.playerAPI?.play(uri, callback: self.defaultCallback)
        }
        
        queue.append {
            self.appRemote.playerAPI?.seek(toPosition: seek, callback: self.defaultCallback)
        }
        
        queue.append {
            self.getPlayerState()
        }
        
        handleQueue()
    }
    
    /**
     Play the next Spotify track in a playlist
     */
    public func playerSkipNext() {
        self.isPlaying = true
        
        queue.append {
            self.appRemote.playerAPI?.skip(toNext: self.defaultCallback)
        }
        
        queue.append {
            self.getPlayerState()
        }
        
        handleQueue()
    }
    
    /**
     Play the previous Spotify track in a playlist
     */
    public func playerSkipPrevious() {
        self.isPlaying = true
        
        queue.append {
            self.appRemote.playerAPI?.skip(toPrevious: self.defaultCallback)
        }
        
        queue.append {
            self.getPlayerState()
        }
        
        handleQueue()
    }
    
    /**
     Pause the Spotify player
     */
    public func playerPause() {
        isPlaying = false
        queue.append {
            self.appRemote.playerAPI?.pause(self.defaultCallback)
        }
        
        handleQueue()
    }
    
    /**
     Resume the Spotify player
     */
    public func playerResume() {
        isPlaying = true
        queue.append {
            self.appRemote.playerAPI?.resume(self.defaultCallback)
        }
        
        handleQueue()
    }
    
    /**
     Fetches the album art of a track (using its image identifier)
     */
    public func fetchAlbumArt(_ imgUri: String, callback: @escaping (UIImage) -> Void ) {
        class ImageRepresentable : NSObject, SPTAppRemoteImageRepresentable {
            var imageIdentifier: String
            
            init(imgUri : String) {
                self.imageIdentifier = imgUri
            }
        }
        
        appRemote.imageAPI?.fetchImage(forItem: ImageRepresentable(imgUri: imgUri), with:CGSize(width: 512, height: 512), callback: { (image, error) -> Void in
            guard error == nil else { return }
            
            let image = image as! UIImage
            callback(image)
        })
    }
    
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURL)
        // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect
        // otherwise another app switch will be required
        configuration.playURI = ""
        
        // Set these url's to your backend which contains the secret to exchange for an access token
        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
        configuration.tokenSwapURL = URL(string: "localhost:9292/api/token")
        configuration.tokenRefreshURL = URL(string: "localhost:9292/api/refresh_token")
        return configuration
    }()
    
    
    func storeSession(){
        if (self.session != nil) {
            let encodedData: Data = try! NSKeyedArchiver.archivedData(withRootObject: session!, requiringSecureCoding: false)
            UserDefaults.standard.set(encodedData, forKey: SpotifyManager.kSessionKey)
        } else {
            UserDefaults.standard.set( nil, forKey: SpotifyManager.kSessionKey)
        }
    }
    
    func fetchSession() {
        let data = UserDefaults.standard.data(forKey: SpotifyManager.kSessionKey)
        if (data != nil){
            self.session = try! NSKeyedUnarchiver.unarchivedObject(ofClass: SPTSession.self, from: UserDefaults.standard.data(forKey: SpotifyManager.kSessionKey)!)
        } else {
            self.session = nil
        }
    }
    
    var session : SPTSession?
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: self.configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    lazy var spotifySessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("SPOTIFY SESSION MANAGER: ", session.accessToken, session.expirationDate, session.refreshToken)
        self.session = session
        storeSession()
        self.appRemote.connectionParameters.accessToken = session.accessToken
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("SPOTIFY SESSION MANAGER, RENEWED: ", session.accessToken, session.expirationDate, session.refreshToken)
        self.session = session
        storeSession()
        self.appRemote.connectionParameters.accessToken = session.accessToken
        }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("SPOTIFY SESSION ERROR:", error.localizedDescription)
    }
    
    public func startSession() {
        spotifySessionManager.alwaysShowAuthorizationDialog = false
        let scopes : SPTScope = [SPTScope.appRemoteControl, SPTScope.userReadPlaybackState, SPTScope.userModifyPlaybackState]
        spotifySessionManager.initiateSession(with: scopes, options: .clientOnly)
    }
    
    // MARK: AppRemoteDelegate
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        self.appRemote = appRemote
        self.appRemoteConnected()
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("didFailConnectionAttemptWithError")
        print((error! as NSError).description)
        self.sendLog(message: "didFailConnectionAttempt: " + (error as! NSError).description)
        self.appRemoteDisconnect()
        
        // when Spotify should be connected, then reconnect on a disconnect
        if (isPlaying && shouldBeConnected && reconnectCounter < reconnectLimit) {
            self.connect()
            self.reconnectCounter += 1
        }
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("didDisconnectWithError")
        print((error! as NSError).description)
        self.sendLog(message: "didDisconnectWithError: " + (error as! NSError).description)
        self.appRemoteDisconnect()
        
        // when Spotify should be connected, then reconnect on a disconnect
        if (isPlaying && shouldBeConnected && reconnectCounter < reconnectLimit) {
            self.reconnectCounter += 1
            self.appRemote.connect()
        }
    }
    
    /// default callback for all Spotify appRemote calls, automatically calls next action in the queue
    private var defaultCallback: SPTAppRemoteCallback {
        get {
            isQueueBusy = false
            return {[weak self] _, error in
                if let error = error {
                    print((error as NSError).description)
                    self!.sendLog(message: "Callback error: " + (error as NSError).description)
                }
                self!.handleQueue()
            }
        }
    }
    
    /// handle next Spotify action in the queue
    private func handleQueue() {
        if (!queue.isEmpty && !isQueueBusy) {
            // first check if app is connected
            if (!self.appRemote.isConnected) {
                print("CANNOT PERFORM ACTION, CONNECTING TO APPREMOTE FIRST")
                self.authorize()
            } else {
                let action  = queue.removeFirst()
                isQueueBusy = true
                action()
            }
        }
    }
    
    @objc func applicationWillEnterForeground(notification: Notification) {
        print("APPREMOTE CONNECTD: ", appRemote.isConnected)
        if (!appRemote.isConnected) {
            appRemote.connect()
        }
    }

    private func onPlayerState(_ playerState: SPTAppRemotePlayerState) {
        isPlaying = !playerState.isPaused
        
        DispatchQueue.main.async {
            let dataDict = ["type": "Spotify",
                            "playstate": ["uri": playerState.track.uri, "imgUri": playerState.track.imageIdentifier, "paused": playerState.isPaused,
                                          "speed": playerState.playbackSpeed,
                                          "position": playerState.playbackPosition,
                                          "artist": playerState.track.artist.name,
                                          "track": playerState.track.name,
                                          "contextTitle": playerState.contextTitle,
                                          "contextUri": playerState.contextURI.absoluteString,
                                          "shuffle": playerState.playbackOptions.isShuffling,
                                          "repeatMode": playerState.playbackOptions.repeatMode.description]
                ] as [String : Any]
            
            print(dataDict)
            
            // Always send Spotify player state data, independent of isRecording state (messages outside sessions are ignored anyway)
//            ComManager.sharedInstance.sendSensorData(data: dataDict)
        }
    }
    
    private var playerState: SPTAppRemotePlayerState?
    private var subscribedToPlayerState: Bool = false
    
    private func getPlayerState() {
        appRemote.playerAPI?.getPlayerState { (result, error) -> Void in
            self.isQueueBusy = false
            guard error == nil else {
                print((error! as NSError).description)
                self.sendLog(message: "PlayerState error: " + (error! as NSError).description)
                return
                
            }
            let playerState = result as! SPTAppRemotePlayerState
            self.onPlayerState(playerState)
            self.handleQueue()
        }
    }
    
    private func subscribeToPlayerState() {
        guard (!subscribedToPlayerState) else { return }

        appRemote.playerAPI!.delegate = self
        appRemote.playerAPI?.subscribe { (_, error) -> Void in
            self.isQueueBusy = false
            guard error == nil else {
                print((error! as NSError).description)
                self.sendLog(message: "Subscribe error: " + (error! as NSError).description)
                return
            }
            self.subscribedToPlayerState = true
            self.handleQueue()
        }
    }
    
    private func unsubscribeFromPlayerState() {
        guard (subscribedToPlayerState) else { return }

        appRemote.playerAPI?.unsubscribe { (_, error) -> Void in
            self.isQueueBusy = false
            guard error == nil else {
                print((error! as NSError).description)
                self.sendLog(message: "Unsubscribe error: " + (error! as NSError).description)
                return
            }
            self.subscribedToPlayerState = false
            self.handleQueue()
        }
    }
    
    // MARK: - <SPTAppRemotePlayerStateDelegate>
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        self.playerState = playerState
        onPlayerState(playerState)
    }
    
    // MARK: - <SPTAppRemoteUserAPIDelegate>
    
    func appRemoteConnecting() {
        NotificationCenter.default.post(name: NSNotification.Name.SpotifyConnecting, object: nil)
        sendLog(message: "Connecting")
    }
    
    func appRemoteConnected() {
        reconnectCounter = 0
        
        print("APP REMOTE CONNECTED")
        queue.append {
            self.subscribeToPlayerState()
        }
        queue.append {
            self.getPlayerState()
        }
        handleQueue()
        
        NotificationCenter.default.post(name: NSNotification.Name.SpotifyConnected, object: nil)
        sendLog(message: "Connected")
    }
    
    private func sendLog(message : String) {
//        ComManager.sharedInstance.sendLogData(data: ["type": "Spotify",
//                                                     "message": message])
    }
    
    internal func appRemoteConnect() {
        if (self.appRemote.isConnected) {
            print ("ALREADY CONNECTED, NOT RECONNECTING")
            return
        }
        self.shouldBeConnected = true
        self.appRemoteConnecting()
    }
    
    /// Connect to the Spotify app. Requires authorization.
    internal func connect() {
        print("CONNECT TO A SPOTIFY SESSION")
        
        DispatchQueue.main.async {
            self.fetchSession()
            self.spotifySessionManager.session = self.session
            if (self.spotifySessionManager.session == nil){
                self.startSession()
            } else {
                self.spotifySessionManager.renewSession()
            }
        }
    }
    
    /**
     Method used to forcefully disconnect the Sportify connect (when the app changes).
     */
    internal func appRemoteDisconnect() {
        print("DISCONNECTING SPOTIFY")
        self.appRemote.disconnect()
        self.subscribedToPlayerState = false
        NotificationCenter.default.post(name: NSNotification.Name.SpotifyDisconnected, object: nil)
        sendLog(message: "Disconnected")
    }
}
