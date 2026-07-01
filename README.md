# 🥗 Daily Nutrition & Macros Tracker

A mobile nutrition tracking application developed using Flutter.

## 📖 Overview

The Daily Nutrition & Macros Tracker is a mobile application designed to help users monitor their daily caloric intake, track macronutrients, and manage personal nutrition goals in a simple and organized manner. The app addresses common complexities in nutrition tracking by providing a user-friendly interface that enables fast, effortless meal logging via an integrated barcode scanner.

## 🎯 Objectives

- **Develop a mobile nutrition tracking application.**
- **Allow users to log meals and track calories.**
- **Help users manage personal nutrition goals.**
- **Display user progress using charts and indicators.**
- **Create a simple and easy-to-use interface.**
- **Enable meal logging using a barcode scanner** integrated with an external global food database.

## 🛠️ Architecture & Technologies

The application uses a `Tracker-Provider` architecture to manage data flow between screens, models, and services.

- **Frontend:** Built with Flutter.
- **Backend/Services:** \* **Firebase:** Used for database operations (Firestore) and user authentication (Firebase Auth).
  - **External APIs:** Fetches food information via the OpenFoodFacts API.
- **Local Storage:** Employs Shared Preferences for persisting user goals and local data.

## 🏗️ Project Design (Class Structure)

The application is structured around the following models:

- `DailyLogModel`: Manages daily meal logs and aggregates total nutrition values (calories, protein, carbs, fats).
- `MealModel`: Tracks individual meals, calculating specific caloric and macronutrient values based on consumption.
- `FoodItemModel`: Stores baseline nutritional data, supporting barcode lookup and Firestore retrieval.
- `UserGoalModel`: Stores user-specific targets (calories, macros) and profile information (weight, height, age).

## 🏁 Conclusion

This project successfully developed a mobile nutrition tracking application that enables users to easily monitor calories and manage nutritional intake. The application provides a streamlined interface, effective progress tracking, and barcode scanning capabilities to support healthier and more consistent daily habits
