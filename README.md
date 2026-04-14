# Student Grade Calculator
**Language:** Dart

---

## Description
Reads student scores from a text file and calculates final letter grades based on total points. Supports two individual student queries by C#, then prints the full class roster along with average and highest scores per category.

---

## Files
| File | Description |
|------|-------------|
| `main.dart` | Main source code |
| `scores.txt` | Input file with student scores |

---

## How to Run

### Option 1 – Local (Dart SDK installed)
```bash
dart main.dart
```

### Option 2 – Online (no install needed)
1. Go to [https://onlinegdb.com](https://onlinegdb.com)
2. Select **Dart** as the language
3. Paste the contents of `main.dart`
4. Click **Run**

---

## Input Format
When prompted, type the name of the scores file:
```
Enter the name of the scores file: scores.txt
```
Then enter two C# values for queries:
```
Query 1 — enter a C#: c1234501
Query 2 — enter a C#: c1234502
```

---

## Grading Scale
| Total Points | Grade | Total Points | Grade |
|---|---|---|---|
| >= 90 | A | >= 70, < 73 | C- |
| >= 87, < 90 | B+ | >= 67, < 70 | D+ |
| >= 83, < 87 | B | >= 63, < 67 | D |
| >= 80, < 83 | B- | >= 60, < 63 | D- |
| >= 77, < 80 | C+ | < 60 | F |
| >= 73, < 77 | C | | |
