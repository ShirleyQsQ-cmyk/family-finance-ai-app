import json
import random
from pathlib import Path

import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_absolute_error, r2_score
from sklearn.model_selection import train_test_split


BASE_DIR = Path(__file__).resolve().parent


def clamp(value, min_value=0, max_value=100):
    return max(min_value, min(max_value, value))


def generate_sample():
    # -----------------------------
    # 1. Generate basic family data
    # -----------------------------
    child_age = random.randint(3, 15)

    monthly_income = random.randint(8000, 60000)

    min_expense = int(monthly_income * 0.45)
    max_expense = int(monthly_income * 1.05)
    monthly_expense = random.randint(min_expense, max_expense)

    education_expense = random.randint(500, int(monthly_income * 0.45))

    has_emergency_fund = random.choice([0, 1])
    has_education_fund = random.choice([0, 1])
    has_basic_insurance = random.choice([0, 1])

    # -----------------------------
    # 2. Feature engineering
    # -----------------------------
    saving_rate = (monthly_income - monthly_expense) / monthly_income
    education_rate = education_expense / monthly_income

    # -----------------------------
    # 3. Generate three sub-scores
    # These are expert-rule labels for prototype training
    # -----------------------------

    # Cashflow health score
    cashflow_score = (
        55
        + saving_rate * 85
        - education_rate * 35
        + has_emergency_fund * 8
        + has_basic_insurance * 4
        + random.normalvariate(0, 5)
    )

    # Education fund readiness score
    education_score = (
        45
        + has_education_fund * 28
        + saving_rate * 25
        - education_rate * 18
        - max(child_age - 10, 0) * 1.5
        + random.normalvariate(0, 5)
    )

    # Family protection score
    protection_score = (
        35
        + has_emergency_fund * 32
        + has_basic_insurance * 30
        + saving_rate * 15
        + random.normalvariate(0, 5)
    )

    cashflow_score = clamp(cashflow_score)
    education_score = clamp(education_score)
    protection_score = clamp(protection_score)

    # -----------------------------
    # 4. Integrated financial health score
    # One final score, but built from three dimensions
    # -----------------------------
    financial_health_score = (
        cashflow_score * 0.4
        + education_score * 0.3
        + protection_score * 0.3
    )

    return {
        "child_age": child_age,
        "monthly_income": monthly_income,
        "monthly_expense": monthly_expense,
        "education_expense": education_expense,
        "saving_rate": saving_rate,
        "education_rate": education_rate,
        "has_emergency_fund": has_emergency_fund,
        "has_education_fund": has_education_fund,
        "has_basic_insurance": has_basic_insurance,

        # Keep these three for explanation and report
        "cashflow_score": round(cashflow_score),
        "education_score": round(education_score),
        "protection_score": round(protection_score),

        # The only target used to train the model
        "financial_health_score": round(clamp(financial_health_score)),
    }


def train_model(df, target_name, feature_names):
    X = df[feature_names]
    y = df[target_name]

    X_train, X_test, y_train, y_test = train_test_split(
        X,
        y,
        test_size=0.2,
        random_state=42,
    )

    model = LinearRegression()
    model.fit(X_train, y_train)

    predictions = model.predict(X_test)

    mae = mean_absolute_error(y_test, predictions)
    r2 = r2_score(y_test, predictions)

    print("=" * 60)
    print(f"Model: {target_name}")
    print(f"MAE: {mae:.2f}")
    print(f"R2: {r2:.3f}")
    print(f"Intercept: {model.intercept_:.6f}")
    print("Coefficients:")

    for name, coef in zip(feature_names, model.coef_):
        print(f"  {name}: {coef:.6f}")

    return {
        "intercept": float(model.intercept_),
        "coefficients": {
            name: float(coef)
            for name, coef in zip(feature_names, model.coef_)
        },
        "mae": float(mae),
        "r2": float(r2),
    }


def main():
    random.seed(42)

    # Generate simulated training samples
    samples = [generate_sample() for _ in range(1000)]
    df = pd.DataFrame(samples)

    training_data_path = BASE_DIR / "family_finance_training_data.csv"
    model_path = BASE_DIR / "family_finance_model.json"

    # Save training data
    df.to_csv(training_data_path, index=False)
    print(f"Training data saved to: {training_data_path}")

    feature_names = [
        "child_age",
        "monthly_income",
        "monthly_expense",
        "education_expense",
        "saving_rate",
        "education_rate",
        "has_emergency_fund",
        "has_education_fund",
        "has_basic_insurance",
    ]

    trained_model = train_model(
        df,
        "financial_health_score",
        feature_names,
    )

    model_package = {
        "model_type": "LinearRegression",
        "target": "financial_health_score",
        "description": "A single integrated linear regression model for family financial health scoring.",
        "score_design": {
            "cashflow_score_weight": 0.4,
            "education_score_weight": 0.3,
            "protection_score_weight": 0.3,
        },
        "feature_names": feature_names,
        "model": trained_model,
    }

    with open(model_path, "w", encoding="utf-8") as f:
        json.dump(model_package, f, indent=2, ensure_ascii=False)

    print("=" * 60)
    print(f"Model exported to: {model_path}")
    print("Done.")


if __name__ == "__main__":
    main()