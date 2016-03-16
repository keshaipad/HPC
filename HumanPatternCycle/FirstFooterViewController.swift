//
//  FirstFooterViewController.swift
//  HumanPatternCycle
//
//  Created by Admin on 08.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import RealmSwift

class FirstFooterViewController: UIViewController, TagListViewDelegate, YSKRecognizerDelegate {
    
    var recognizer: YSKRecognizer?
    var recognition: YSKRecognition?
    
    var recognizerLanguage: String = ""
    var recognizerModel: String = YSKRecognitionModelGeneral

    @IBOutlet weak var TagList: TagListView!
    var states : Results<State>!
    var stateLists : Results<StateList>!
    
    var moodForAddToState: String = ""
    
    var recognisetWordToSave: String = ""
    
    @IBOutlet weak var micStopButton: UIButton!
    
    
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TagList.textFont = UIFont.systemFontOfSize(18)
        TagList.delegate = self
         states = uiRealm.objects(State) // Считываем все записи состояний
        stateLists = uiRealm.objects(StateList)
        if states.count != 0 {
            print ("Okay")
            if stateLists.count < 3 { // Если записей пользователя меньше 3
                startMakingFirst()
            } else {
                startMakingTags()
            }
        }
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "startMakingFirstTimeTags:", name: "makingFirstTags", object: nil)
        
        textField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged) // Если текстовое поле изменяется
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidChange(textField: UITextField) { // Если текстовое поле изменено
        TagList.removeAllTags() // Удалим все теги
        let str = String("\(textField.text!)")
        let text2: String = str
        print("\(text2)")
        let aPredicate = NSPredicate(format: "name BEGINSWITH %@", text2)
       // let filterState = uiRealm.objects(State).filter("name BEGINSWITH '\(text)' " )
        //let filterState2 = uiRealm.objects(State)
        //print(filterState2)
        let filterState = uiRealm.objects(State).filter(aPredicate)
        var countTags = 0
        while countTags < filterState.count {
            let currentName = filterState[countTags].name
            TagList.addTag(currentName)
            ++countTags
        }
        print(filterState)
        print("\(text2)")
    }
    
    
    @IBAction func micStop(sender: AnyObject) {
        
        micStopButton.alpha = 0
        onRecognizerButtonTap()
        
    }
    
    @IBAction func micRec(sender: AnyObject) {
        recognizer?.cancel()
        micStopButton.alpha = 1
    }
    
    
    
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func startMakingFirst() {
       
        
        let sortedState = uiRealm.objects(State).sorted("useCount") // Сортируем состояния по количеству записей
        var sortedStateCount = sortedState.count - 1 // Определим индекс последней записи
        var countHere = 10 //Количество создаваемых тегов
        while countHere >= 0 { // Соберем в теги
            let nameCurrentState = sortedState[sortedStateCount].name // Берем тег по номеру индекса
            TagList.addTag(nameCurrentState) // Создадим новый тэг
            --sortedStateCount
            --countHere
        }
    }
    
    func startMakingFirstTimeTags(notification: NSNotification) {
        startMakingFirst()
    }
    
    func startMakingTags() {
        
    }
    
    func tagPressed(title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title)")
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            NSNotificationCenter.defaultCenter().postNotificationName("moveFooterContainer", object: nil) // Вызываем подьем футера
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            NSNotificationCenter.defaultCenter().postNotificationName("moveFooterContainer", object: nil) // Вызываем опускание футера
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startSaveCurrentMood(choosedMood: String) {
        print(choosedMood)
        let wordTouch = choosedMood.characters.last!
        var wordForCheck: String = ""
        if wordTouch == " " {
            let dropChar = String(choosedMood.characters.dropLast())
            wordForCheck = dropChar
        } else {
            wordForCheck = choosedMood
        }
        states = uiRealm.objects(State).filter("name = %@", wordForCheck )
        if states.count == 0 {
            moodForAddToState = wordForCheck
            quastionAboudAdd()
        } else {
        let currentObject = states[0]
        let currentKey = Int(currentObject.key)
        
        NSUserDefaults.standardUserDefaults().setObject("Yes", forKey: "withoutMoodParent")
        NSUserDefaults.standardUserDefaults().setObject(wordForCheck, forKey: "parentMood")
        
        AddNewRecord().addRecord(currentKey!)
        print(currentKey)
        }
    }
    
    func quastionAboudAdd() {
        
        let alertView = SCLAlertView()
        alertView.showCloseButton = true
        alertView.addButton("Add it", target:self, selector:Selector("addNewState"))
        alertView.showNotice(moodForAddToState, subTitle: "You don't have this state in Database. Add like new?")
        
    }
    
    func addNewState() {
        SCLAlertView().showNotice(moodForAddToState, subTitle: "You don't have this state in Database. Add like new?").close()
        AddNewRecord().addStateToDataBase(moodForAddToState)  // Добавляем новую запись в базу
        startSaveCurrentMood(moodForAddToState) // Добавляем новую запись в сегодняшний день
        moodForAddToState = ""
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */// Начинается распознавательные функции
    
    func updateTextField() {
        if let count: Int = recognition!.hypotheses.count {
            textField.text = "\(count)"
        }
    }
    
    func checkFirstLanguageRecognizer() {
        if let defaultLanguage = NSUserDefaults.standardUserDefaults().stringForKey("defaultLanguage") {
            takeLanguage()
            print(defaultLanguage)
        } else {
            let alertView = SCLAlertView()
            alertView.showCloseButton = false
            alertView.addButton("English", target:self, selector:Selector("englishLanguage"))
            alertView.addButton("Russian", target:self, selector:Selector("russianLanguage"))
            alertView.addButton("Turkish", target:self, selector:Selector("turkishLanguage"))
            alertView.addButton("Ukrainian", target:self, selector:Selector("ukrainianLanguage"))
            alertView.showNotice("Choose language", subTitle: "If you need more languages - just write to support")
        }
    }
    
    func takeLanguage() {
        print("takeLanguage")
        let takeDefaultLanguage: String = NSUserDefaults.standardUserDefaults().stringForKey("defaultLanguage")!
        switch takeDefaultLanguage {
        case "english":
        recognizerLanguage = YSKRecognitionLanguageEnglish
        let alertView = SCLAlertView()
            alertView.showNotice("Choose language", subTitle: "If you need more languages - just write to support").close()
        case "russian":
        recognizerLanguage = YSKRecognitionLanguageRussian
        case "turkish":
            recognizerLanguage = YSKRecognitionLanguageTurkish
        case "ukrainian":
            recognizerLanguage = YSKRecognitionLanguageUkrainian
        default: recognizerLanguage = YSKRecognitionLanguageEnglish
        }
    }
    
    func englishLanguage() {
        NSUserDefaults.standardUserDefaults().setObject("english", forKey: "defaultLanguage")
        takeLanguage()
    }
    func russianLanguage() {
        
        NSUserDefaults.standardUserDefaults().setObject("russian", forKey: "defaultLanguage")
        takeLanguage()
    }
    
    func turkishLanguage() {
        NSUserDefaults.standardUserDefaults().setObject("turkish", forKey: "defaultLanguage")
        takeLanguage()
    }
    func ukrainianLanguage() {
        NSUserDefaults.standardUserDefaults().setObject("ukrainian", forKey: "defaultLanguage")
        takeLanguage()
    }
    
    func onRecognizerButtonTap() {
        // Create new YSKRecognizer instance for every request.
        if recognizerLanguage == "" {
        checkFirstLanguageRecognizer()
        } else {
        recognizer = YSKRecognizer.init(language: recognizerLanguage, model: recognizerModel)
        recognizer?.delegate = self
        recognizer?.VADEnabled = true
        
        // Cleanup previouse result.
        recognition = nil;
        
        // Start recognition.
        recognizer?.start();
        }
    }
    
    
    func recognizerDidStartRecording(recognizer: YSKRecognizer!) {
        //
    }
    
    func recognizerDidFinishRecording(recognizer: YSKRecognizer!) {
        micStopButton.alpha = 1
        
    }
    
    func recognizer(recognizer: YSKRecognizer!, didReceivePartialResults results: YSKRecognition!, withEndOfUtterance endOfUtterance: Bool) {
        recognition = results
    }
    
    func recognizer(recognizer: YSKRecognizer!, didCompleteWithResults results: YSKRecognition!) {
        
            recognition = results
        
            startSaveCurrentMood((recognition?.bestResultText)!)
            self.recognizer = nil;
       
        
        micStopButton.alpha = 1
       
    }
    
    func errorAlert(errorText: String) {
        let alertViewSuc = SCLAlertView()
        alertViewSuc.showCloseButton = false
        alertViewSuc.showError("Error!", subTitle: errorText, closeButtonTitle: "closebuttonTitle", duration: 2, colorStyle: 0xC1272D, colorTextButton: 0xFFFFFF)
    }
    
    func recognizer(recognizer: YSKRecognizer!, didFailWithError error: NSError!) {
        
        errorAlert(error.localizedDescription)
        
        
        
        self.recognizer = nil;
        micStopButton.alpha = 1
        
    }

}
