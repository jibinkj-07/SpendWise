# SpendWise - Finance Management App

[SpendWise App](https://spend-wise-budget.web.app/)  
SpendWise is a finance management app built with Flutter, designed to help users track expenses, set financial goals, monitor budgets, and visualize spending patterns through interactive charts. It also includes a guest-adding feature for tracking shared expenses.

---

## Features

- **Expense Tracking:** Add, categorize, and manage your daily, weekly, and monthly expenses.
- **Guest Management:** Add and track expenses involving guests.
- **Goal Setting & Monitoring:** Set financial goals, monitor progress, and manage goal-related finances.
- **Dashboard:** Visualize monthly and yearly expense data using charts to understand spending trends.
- **User Authentication:** Secure login functionality for personalized experiences.

---

## Folder Structure

Here's an overview of the project's folder organization:

```plaintext
lib
├── core
│   ├── config               # App-wide configuration and settings
│   ├── constants            # App constants (e.g., strings, keys)
│   └── util                 # Utility functions used across the app
├── features                 # App's primary feature modules
│   ├── common               # Shared widgets and components
│   ├── mobile_view          # Main mobile UI components
│   │   ├── account
│   │   │   ├── presentation # UI logic for the account section
│   │   │   ├── view         # Screens related to account management
│   │   │   ├── view_model   # View models for account management
│   │   │   └── widget       # Reusable account-specific widgets
│   │   ├── auth
│   │   │   ├── data         # Data models and repositories for authentication
│   │   │   ├── domain       # Domain logic for authentication
│   │   │   └── presentation # UI logic for authentication
│   │   ├── dashboard
│   │   │   ├── presentation # UI logic for the dashboard
│   │   │   ├── view         # Dashboard screens
│   │   │   ├── view_model   # View models for dashboard
│   │   │   └── widget       # Reusable widgets for dashboard
│   │   ├── goal
│   │   │   ├── data         # Data handling for goal setting
│   │   │   └── presentation # UI logic for goal section
│   │   └── home
│   │       ├── presentation # UI logic for home
│   │       ├── view         # Home screen views
│   │       ├── widget       # Home-specific reusable widgets
│   │       └── util         # Utilities specific to home
└── root.dart                # Main entry point of the app
```
## Getting Started

### Prerequisites
- **Flutter**: Ensure you have Flutter installed. [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
- **Dart**: This project is built using Dart.
- **Firebase**: Used for Authentication and Storage.

### Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/jibinkj-07/SpendWise.git
   cd SpendWise
   ```
2. **Install Dependencies::**
   ```bash
    flutter pub get
   ```

### Contributing
Contributions are welcome! If you find a bug or have a feature request, feel free to open an issue or create a pull request.

1. Fork the repository.
2. Create a feature branch:**` git checkout -b feature/YourFeature  `**
3. Commit your changes:**` git commit -m 'Add some feature' `**
4. Push to the branch:**` git push origin feature/YourFeature `**
5. Open a pull request.

### Development Guidelines

- Follow clean architecture with SOLID principle.
- Use meaningful names for variables, functions and classes.
- Don\'t change core functionalities may lead to project break
- Utilize git with clear commit message

### Version History and Releases

- Web : 1.0.0+1 (29/10/24) - Deployed first version via Firebase hosting
