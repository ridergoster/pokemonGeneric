//
//  ViewController.swift
//  PokemonGeneric
//
//  Created by Vincent Kocupyr on 18/11/2016.
//  Copyright © 2016 Vincent Kocupyr. All rights reserved.
//

import UIKit
import AVFoundation
import FWJoystick
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var joystick: FWJoystick!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private var player: AVAudioPlayer?
    var dataSource : [String]?
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var label: UILabel!
    
    var selectedSong: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label?.text = ""
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.dataSource = ["Pokemon 1", "Pokemon 2", "Pokemon 3", "Pokemon 4", "Pokemon 5", "Pokemon 6"]
        // Do any additional setup after loading the view, typically from a nib.
        
        joystick.actionHandler = { data in
            self.joystick.isInAction = true
            switch data {
            case 0:
                self.playOrPause()
                break
            case 1:
                self.prevSong()
                break;
            case 2:
                self.upVolume()
                break;
            case 3:
                self.nextSong()
                break;
            case 4:
                self.downVolume()
                break;
            default:
                break
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                self.joystick.isInAction = false
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let nb = self.dataSource?.count {
            return nb
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "celling"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: "celling")
        cell.textLabel?.text = self.dataSource?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        launchMusic(index: indexPath.row + 1)
    }
    
    func launchMusic(index: Int) {
        selectedSong = index
        if let musicURL = Bundle.main.url(forResource: "pokemon_" + String(index), withExtension: "mp3") {
            if let player = try? AVAudioPlayer(contentsOf: musicURL) {
                self.player = player;
                self.player?.play();
                self.label.text = "playing"
                self.labelName.text = (dataSource?[index - 1])!
            }
        }
    }
    
    
    func upVolume() {
        if let player = self.player {
            if (player.volume >= 0.9) {
                player.volume = 1
            } else {
                player.volume += 0.1
            }
            print("VOLUME: \(player.volume)")

        }
        let oldlabel = self.label.text
        self.label.text = "volume up"
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
            self.label.text = oldlabel
            
        })

    }
    
    func downVolume() {
        if let player = self.player {
            if (player.volume <= 0.1) {
                player.volume = 0
            } else {
                player.volume -= 0.1

            }
            print("VOLUME: \(player.volume)")
        }
        let oldlabel = self.label.text
        self.label.text = "volume down"
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
            self.label.text = oldlabel
        })
    }
    
    func prevSong() {
        if(selectedSong == 1){return}
        launchMusic(index: selectedSong - 1)
    }

    func nextSong() {
        if(selectedSong == 6){return}
        launchMusic(index: selectedSong + 1)
    }

    func playOrPause() {
        if(selectedSong == 0 || self.label.text == "") {
            launchMusic(index: 1)
            return
        }
        if let player = self.player {
            if player.isPlaying {
                player.pause()
                self.label.text = "pause"
            } else {
                player.play()
                self.label.text = "playing"
            }
        }
    }
}

