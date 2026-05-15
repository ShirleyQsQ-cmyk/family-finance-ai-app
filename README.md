# FamilyFin AI

FamilyFin AI is a Flutter app for AI-assisted family financial health diagnosis and parent-child financial literacy tasks.

The app helps families understand their financial status, identify key risks, plan education savings, and guide children to build basic money awareness through weekly tasks.

---

## Features

- Family information input
- Financial health score prediction
- Cashflow, education fund, and protection diagnosis
- AI-assisted planning report
- Education savings estimation
- Parent-child financial literacy tasks
- Task completion points and level progress
- Mobile-friendly UI built with Flutter

---

## AI Approach

FamilyFin AI uses a controlled and explainable AI workflow:

```text
Family Input
    ↓
Feature Extraction
    ↓
Linear Regression Model
    ↓
Financial Health Score
    ↓
Rule-based Diagnosis
    ↓
Planning Report and Tasks
```

The app does not rely on a large language model for free-form financial advice.  
Instead, it uses a trained linear regression model and rule-based recommendation logic to keep the output stable and explainable.

---

## Model

The financial health score is predicted using a linear regression model trained in Python.

Model features include:

- Child age
- Monthly income
- Monthly expenses
- Education expenses
- Saving rate
- Education spending ratio
- Emergency fund status
- Education fund status
- Basic insurance status

The trained model is exported as JSON and loaded locally by the Flutter app.

---

## Tech Stack

| Part | Technology |
|---|---|
| App | Flutter |
| Language | Dart |
| Model Training | Python |
| ML Model | Linear Regression |
| Model Format | JSON |

---

## Project Structure

```text
family_app_ai/
├── assets/
│   ├── family_finance_model.json
│   └── icon/
│       └── app_icon.png
│
├── lib/
│   ├── main.dart
│   ├── models/
│   ├── pages/
│   ├── services/
│   ├── widgets/
│   └── utils/
│
├── ml/
│   ├── train_family_model.py
│   ├── family_finance_training_data.csv
│   └── family_finance_model.json
│
├── pubspec.yaml
└── README.md
```

---

## App Flow

```text
Welcome Page
    ↓
Family Information Input
    ↓
Financial Health Diagnosis
    ↓
AI Planning Report
    ↓
Parent-Child Financial Literacy Tasks
```

---

## How to Run

Install dependencies:

```bash
flutter pub get
```

Run on Chrome:

```bash
flutter run -d chrome
```

Run on Android device:

```bash
flutter devices
flutter run
```

Run on Windows desktop:

```bash
flutter run -d windows
```

---

## Model Training

Train the model:

```bash
python ml/train_family_model.py
```

The generated model file is:

```text
ml/family_finance_model.json
```

Copy it to:

```text
assets/family_finance_model.json
```

Then run the Flutter app again.

---

## Disclaimer

FamilyFin AI is designed for learning, product design, and demonstration purposes.

It does not provide professional financial advice, investment advice, insurance advice, or legal advice.  
The financial health score and suggestions are based on simplified model assumptions and rule-based logic.

---

## Author

Developed by **ShirleyQsQ-cmyk**.
