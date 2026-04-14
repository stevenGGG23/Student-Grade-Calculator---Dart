// ============================================================
// Program:     grades.dart
// Course:      CSCI 3210 - Programming Languages
// Language:    Dart
// Name:        Steven Gobran
// Description: Reads student scores from a file, calculates
//              letter grades, supports two C# queries, then
//              prints the full roster with averages/highs.
// Input:       A .txt file with columns: C# CLA OLA Quiz Exam FinalExam
// Output:      Query results + full roster table to stdout
// ============================================================

import 'dart:io';

// ============================================================
// Class: Student
// Stores one student's id, scores, total, and letter grade.
// All fields are private; exposed only through getters.
// ============================================================

class Student {
  final String _id;
  final int _cla;
  final int _ola;
  final int _quiz;
  final int _exam;
  final int _finalExam;
  late final int _total;
  late final String _grade;

  // constructor — calculates total and grade on creation
  Student(this._id, this._cla, this._ola, this._quiz, this._exam, this._finalExam) {
    _total = _cla + _ola + _quiz + _exam + _finalExam;
    _grade = _calcGrade(_total);
  }

  // getters so Roster can read values without touching privates directly
  String get id       => _id;
  int    get cla      => _cla;
  int    get ola      => _ola;
  int    get quiz     => _quiz;
  int    get exam     => _exam;
  int    get finalExam => _finalExam;
  int    get total    => _total;
  String get grade    => _grade;

  // _calcGrade — maps total points to a letter grade per the rubric table
  // input:  total score (int)
  // output: letter grade string
  String _calcGrade(int pts) {
    if (pts >= 90) return 'A';
    if (pts >= 87) return 'B+';
    if (pts >= 83) return 'B';
    if (pts >= 80) return 'B-';
    if (pts >= 77) return 'C+';
    if (pts >= 73) return 'C';
    if (pts >= 70) return 'C-';
    if (pts >= 67) return 'D+';
    if (pts >= 63) return 'D';
    if (pts >= 60) return 'D-';
    return 'F';
  }

  // printInfo — prints one formatted row for this student
  void printInfo() {
    print('${_id.padRight(12)}'
        '${_cla.toString().padLeft(5)}'
        '${_ola.toString().padLeft(5)}'
        '${_quiz.toString().padLeft(6)}'
        '${_exam.toString().padLeft(6)}'
        '${_finalExam.toString().padLeft(10)}'
        '${_grade.padLeft(6)}');
  }
}

// ============================================================
// Class: Roster
// Uses a Map<String, Student> as the associative array.
// Handles loading the file, queries, and stats output.
// ============================================================

class Roster {
  // the main associative array — key is C# string
  final Map<String, Student> _students = {};

  // loadFile — reads scores from a whitespace-delimited file
  // input:  path to the scores file
  // output: populates _students map; returns false if file missing
  bool loadFile(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      print('Error: file "$path" not found.');
      return false;
    }

    final lines = file.readAsLinesSync();
    // skip header line (first line has column names)
    for (int i = 1; i < lines.length; i++) {
      final parts = lines[i].trim().split(RegExp(r'\s+'));
      if (parts.length < 6) continue; // skip blank/malformed lines

      final id  = parts[0];
      final cla = int.parse(parts[1]);
      final ola = int.parse(parts[2]);
      final quiz = int.parse(parts[3]);
      final exam = int.parse(parts[4]);
      final fin  = int.parse(parts[5]);

      _students[id] = Student(id, cla, ola, quiz, exam, fin);
    }
    return true;
  }

  // query — looks up a student by C# and prints their info
  // input:  C# string entered by the user
  // output: prints student row, or an error if not found
  
  void query(String id) {
    final s = _students[id];
    if (s == null) {
      print('Student "$id" not found.\n');
      return;
    }
    _printHeader();
    s.printInfo();
    print('');
  }

  // printAll — prints every student then the averages and highs
  void printAll() {
    _printHeader();
    for (final s in _students.values) {
      s.printInfo();
    }
    _printStats();
  }

  // _printHeader — column header row for the table
  void _printHeader() {
    print('\n${'C#'.padRight(12)}'
        '${'CLA'.padLeft(5)}'
        '${'OLA'.padLeft(5)}'
        '${'Quiz'.padLeft(6)}'
        '${'Exam'.padLeft(6)}'
        '${'FinalExam'.padLeft(10)}'
        '${'Grade'.padLeft(6)}');
    print('-' * 52);
  }

  // _printStats — calculates and prints average + highest per category
  void _printStats() {
    if (_students.isEmpty) return;

    // pull out each column into a list to avoid repeating logic
    final claVals  = _students.values.map((s) => s.cla).toList();
    final olaVals  = _students.values.map((s) => s.ola).toList();
    final quizVals = _students.values.map((s) => s.quiz).toList();
    final examVals = _students.values.map((s) => s.exam).toList();
    final finVals  = _students.values.map((s) => s.finalExam).toList();

    // avg helper — rounds to 1 decimal
    double avg(List<int> vals) => vals.reduce((a, b) => a + b) / vals.length;
    int    high(List<int> vals) => vals.reduce((a, b) => a > b ? a : b);

    print('-' * 52);
    print('${'Average'.padRight(12)}'
        '${avg(claVals).toStringAsFixed(1).padLeft(5)}'
        '${avg(olaVals).toStringAsFixed(1).padLeft(5)}'
        '${avg(quizVals).toStringAsFixed(1).padLeft(6)}'
        '${avg(examVals).toStringAsFixed(1).padLeft(6)}'
        '${avg(finVals).toStringAsFixed(1).padLeft(10)}');
    print('${'Highest'.padRight(12)}'
        '${high(claVals).toString().padLeft(5)}'
        '${high(olaVals).toString().padLeft(5)}'
        '${high(quizVals).toString().padLeft(6)}'
        '${high(examVals).toString().padLeft(6)}'
        '${high(finVals).toString().padLeft(10)}');
    print('');
  }
}

// ============================================================
// main — entry point
// Prompts for file name, runs 2 queries, then prints full roster
// ============================================================

void main() {
  final roster = Roster();
  final input  = stdin;

  // prompt for the data file
  stdout.write('Enter the name of the scores file: ');
  final filename = stdin.readLineSync()?.trim() ?? '';

  if (!roster.loadFile(filename)) return; // stops if file not found

  // two user queries by C#
  for (int i = 1; i <= 2; i++) {
    stdout.write('Query $i — enter a C#: ');
    final id = stdin.readLineSync()?.trim() ?? '';
    roster.query(id);
  }

  // print the full roster + stats
  print('===== Full Roster =====');
  roster.printAll();
}