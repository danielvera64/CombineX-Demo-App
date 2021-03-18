//
//  ViewController.swift
//  ReactiveApp
//
//  Created by Daniel Vera on 3/17/21.
//

import UIKit
import CombineX

class ViewController: UIViewController {

  @IBOutlet weak var testUISwitch: UISwitch!
  @IBOutlet weak var switchStateLabel: UILabel!
  @IBOutlet weak var getStoresButton: UIButton!
  
  private let viewModel = ViewModel()
  private var disposeBag = Set<AnyCancellable>()

  override func viewDidLoad() {
    super.viewDidLoad()
    bindViews()
    bindViewModel()
  }

  override func viewDidAppear(_ animated: Bool) {
    testSubjects()
    testCombineLatest()
    testMerge()
    testZip()
  }

  private func bindViews() {
    testUISwitch.reactive.isOn
      .sink { [weak self] isOn in
        self?.switchStateLabel.text =  "Switch is: \(isOn)"
      }
      .store(in: &disposeBag)

    getStoresButton.reactive.tap
      .sink(receiveValue: { [weak self] _ in
        print("GetStores pressed")
        self?.viewModel.getStores()
      })
      .store(in: &disposeBag)
  }

  private func bindViewModel() {
    viewModel.storeListSubject
      .sink(receiveValue: {print("\n\n Stores: \n\($0)\n\n") })
      .store(in: &disposeBag)
  }

  func testSubjects() {
    print("\n* Demonstrating Subjects")
    let relay = PassthroughSubject<String, Never>()
    relay
      .sink(receiveValue: { print("subscription1 received value: \($0)") })
      .store(in: &disposeBag)

    relay.send("Hello")
    relay.send("World!")

    let publisher = Publishers.Sequence<[String], Never>(sequence: ["Here","we","go!"])
    publisher
      .subscribe(relay)
      .store(in: &disposeBag)
  }

  func testCombineLatest() {
    print("\n\n* Demonstrating CombineLatest")

    //: **simulate** input from text fields with subjects
    let usernamePublisher = PassthroughSubject<String, Never>()
    let passwordPublisher = PassthroughSubject<String, Never>()

    //: **combine** the latest value of each input to compute a validation
    Publishers
      .CombineLatest(usernamePublisher, passwordPublisher)
      .map ({ (username, password) -> Bool in
        !username.isEmpty && !password.isEmpty && password.count > 12
      })
      .sink { print("CombineLatest: are the credentials valid? \($0)") }
      .store(in: &disposeBag)

    //: Example: simulate typing a username and the password twice
    usernamePublisher.send("avanderlee")
    passwordPublisher.send("weakpass")
    passwordPublisher.send("verystrongpassword")
  }

  func testMerge() {
    print("\n\n* Demonstrating Merge")
    let publisher1 = Publishers.Sequence<[Int], Never>(sequence: [1,2,3,4,5])
    let publisher2 = Publishers.Sequence<[Int], Never>(sequence: [300,400,500])

    Publishers
      .Merge(publisher1, publisher2)
      .sink { print("Merge: subscription received value \($0)") }
      .store(in: &disposeBag)
  }

  func testZip() {
    print("\n\n* Demonstrating Zip")
    let numbersPub = PassthroughSubject<Int, Never>()
    let lettersPub = PassthroughSubject<String, Never>()
    let emojiPub = PassthroughSubject<String, Never>()

    numbersPub
      .zip(lettersPub, emojiPub)
      .sink { print("Zip: received value\($0)") }
      .store(in: &disposeBag)

    numbersPub.send(1)
    numbersPub.send(2)
    numbersPub.send(3)
    lettersPub.send("A")
    emojiPub.send("😀")
    lettersPub.send("B")
    emojiPub.send("🥰")
  }

}

