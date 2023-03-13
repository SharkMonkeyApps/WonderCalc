# WonderCalc

A wonderful calculator for iOS.

WonderCalc is and easy to use calculator for iOS. It features cut, copy and paste functionality, unit conversion, and a loan calculator. It supports both light mode and dark mode. It is built in SwiftUI with Combine, and uses Xcode Cloud for CI. It is available on the [App Store](https://appstoreconnect.apple.com/apps/6444459924/appstore/ios/version/deliverable)

## Setup

After cloning down the repo, open WonderCalc.xccodeproj in Xcode. This project uses Swift Package Manager. After opening the project, go to File > Packages > Reset Package Caches

To run the app on the selected simulator, press command + R

To run the tests, press command + U

## Architecture

This project uses a modified MVC architecture with testable model objects handling calculations for the caclulator, units, and loan views. Services including pasteboard and analytics utilized by the app are in the AppConfig object created in the @main WonderCalcApp struct and passed into where they are needed.

## Analytics and Crash Reporting

This project is using Firebase Analytics and Crashlytics. To enable debugging, tap the WonderCalc target at the top, go to edit scheme, and add the following to arguments passed on launch:
```
-FIRDebugEnabled
```
This behavior persists until you explicitly disable debug mode by specifying the following command line argument:
```
-FIRDebugDisabled
```
See https://firebase.google.com/docs/analytics/debugview, https://firebase.google.com/docs/ios/setup for info on debug flags. See https://firebase.google.com/docs/projects/api-keys for information on API keys

When running the app outside of release mode, there is a button to simulate a crash on the about screen.

## Additional Info

For any questions of feedback, please contact [SharkMonkey Apps](https://www.sharkmonkeyapps.com/)
