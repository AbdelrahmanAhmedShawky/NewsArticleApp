# NewsArticleApp

## Requirements:
* iOS 13.0+
* Xcode 11.6
* Swift 5  

## Objective:
This sample app to demonstrate some aspect of clean architecture using SwiftUI ,MVVM pattern, Combine, **SOLID principles** , Dark mode support and some of the best practices used in modern iOS programming using `Swift`.

# App Goal:
* This project was intended to work as a News List demo projects for iOS using Swift. 
* The demo uses the [News API](https://newsapi.org) which returns information in a JSON format.
* Use of ListView to display News list information.
* Use of **Combine** for Reactive programming.

# Technical notes:
- MVVM - My preferred architecture.
    - MVVM stands for “Model View ViewModel”
    - It’s a software architecture often used by Apple developers to replace MVC. Model-View-ViewModel (MVVM) is a structural design pattern that separates objects into three distinct groups:
- Models hold application data. They’re usually structs or simple classes.
- Views display visual elements and controls on the screen. They’re typically - subclasses of UIView.
- View models transform model information into values that can be displayed on a view. They’re usually classes, so they can be passed around as references.


# License
Distributed under the MIT License. Copyright (c) 2020 Abdelrahman Ahmed Shawky
