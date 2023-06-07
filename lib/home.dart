import 'package:flutter/material.dart';
import 'package:quiz/answer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Icon> _scoreTracker = [];
  int _questionIndex = 0;
  int _totalScore = 0;
  bool answerWasSelected = false;
  bool endOfQuiz = false;
  bool correctAnswerSelected = false;

  void _questionAnswered(bool answerScore) {
    setState(() {
      // answer was selected
      answerWasSelected = true;
      // check if answer was correct
      if (answerScore) {
        _totalScore++;
        correctAnswerSelected = true;
      }
      // adding to the score tracker on top
      _scoreTracker.add(
        answerScore
            ? Icon(
                Icons.check_circle,
                color: Colors.green,
              )
            : Icon(
                Icons.clear,
                color: Colors.red,
              ),
      );
      //when the quiz ends
      if (_questionIndex + 1 == _questions.length) {
        endOfQuiz = true;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _questionIndex++;
      answerWasSelected = false;
      correctAnswerSelected = false;
    });
    // what happens at the end of the quiz
    if (_questionIndex >= _questions.length) {
      _resetQuiz();
    }
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
      _scoreTracker = [];
      endOfQuiz = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter Mentor Quiz App',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                if (_scoreTracker.length == 0)
                  SizedBox(
                    height: 25.0,
                  ),
                if (_scoreTracker.length > 0) ..._scoreTracker
              ],
            ),
            Container(
              width: double.infinity,
              height: 130.0,
              margin: EdgeInsets.only(bottom: 10.0, left: 30.0, right: 30.0),
              padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  _questions[_questionIndex]['question'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ...(_questions[_questionIndex]['answers']
                    as List<Map<String, Object>>)
                .map(
              (answer) => Answer(
                answerText: answer['answerText'],
                answerColor: answerWasSelected
                    ? answer['score']
                        ? Colors.green
                        : Colors.red
                    : null,
                answerTap: () {
                  // if answer was already selected then nothing happens onTap
                  if (answerWasSelected) {
                    return;
                  }
                  //answer is being selected
                  _questionAnswered(answer['score']);
                },
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40.0),
              ),
              onPressed: () {
                if (!answerWasSelected) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Please select an answer before going to the next question'),
                  ));
                  return;
                }
                _nextQuestion();
              },
              child: Text(endOfQuiz ? 'Restart Quiz' : 'Next Question'),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Text(
                '${_totalScore.toString()}/${_questions.length}',
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
              ),
            ),
            if (answerWasSelected && !endOfQuiz)
              Container(
                height: 100,
                width: double.infinity,
                color: correctAnswerSelected ? Colors.green : Colors.red,
                child: Center(
                  child: Text(
                    correctAnswerSelected
                        ? 'Well done, you got it right!'
                        : 'Wrong :/',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (endOfQuiz)
              Container(
                height: 100,
                width: double.infinity,
                color: Colors.black,
                child: Center(
                  child: Text(
                    _totalScore > 4
                        ? 'Congratulations! Your final score is: $_totalScore'
                        : 'Your final score is: $_totalScore. Better luck next time!',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: _totalScore > 4 ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final _questions = const [
  {
    'question': 'Who is known as the "Father of the Nation" in India?',
    'answers': [
      {'answerText': 'Mahatma Gandhi', 'score': true},
      {'answerText': 'Jawaharlal Nehru', 'score': false},
      {'answerText': 'Subhash Chandra Bose', 'score': false},
      {'answerText': 'Bhagat Singh', 'score': false},
    ],
  },
  {
    'question': 'Which city is the capital of India?',
    'answers': [
      {'answerText': 'Mumbai', 'score': false},
      {'answerText': 'Kolkata', 'score': false},
      {'answerText': 'Chennai', 'score': false},
      {'answerText': 'New Delhi', 'score': true},
    ],
  },
  {
    'question': 'Who composed the national anthem of India?',
    'answers': [
      {'answerText': 'Rabindranath Tagore', 'score': true},
      {'answerText': 'Bankim Chandra Chattopadhyay', 'score': false},
      {'answerText': 'Sarojini Naidu', 'score': false},
      {'answerText': 'Vande Mataram', 'score': false},
    ],
  },
  {
    'question': 'Which is the highest mountain peak in India?',
    'answers': [
      {'answerText': 'Kanchenjunga', 'score': true},
      {'answerText': 'Mount Everest', 'score': false},
      {'answerText': 'Nanda Devi', 'score': false},
      {'answerText': 'Annapurna', 'score': false},
    ],
  },
  {
    'question': 'Who is the President of India?',
    'answers': [
      {'answerText': 'Narendra Modi', 'score': false},
      {'answerText': 'Ram Nath Kovind', 'score': true},
      {'answerText': 'Rahul Gandhi', 'score': false},
      {'answerText': 'Amit Shah', 'score': false},
    ],
  },
  {
    'question': 'Which is the national animal of India?',
    'answers': [
      {'answerText': 'Lion', 'score': false},
      {'answerText': 'Tiger', 'score': true},
      {'answerText': 'Elephant', 'score': false},
      {'answerText': 'Peacock', 'score': false},
    ],
  },
  {
    'question': 'Who is the "Missile Man" of India?',
    'answers': [
      {'answerText': 'Jawaharlal Nehru', 'score': false},
      {'answerText': 'A.P.J. Abdul Kalam', 'score': true},
      {'answerText': 'Indira Gandhi', 'score': false},
      {'answerText': 'Sardar Vallabhbhai Patel', 'score': false},
    ],
  },
  {
    'question': 'Which is the national flower of India?',
    'answers': [
      {'answerText': 'Rose', 'score': false},
      {'answerText': 'Sunflower', 'score': false},
      {'answerText': 'Lotus', 'score': true},
      {'answerText': 'Jasmine', 'score': false},
    ],
  },
  {
    'question': 'Which is the national bird of India?',
    'answers': [
      {'answerText': 'Peacock', 'score': true},
      {'answerText': 'Sparrow', 'score': false},
      {'answerText': 'Crow', 'score': false},
      {'answerText': 'Pigeon', 'score': false},
    ],
  },
  {
    'question': 'Who is known as the "Nightingle of India"?',
    'answers': [
      {'answerText': 'Lata Mangeshkar', 'score': true},
      {'answerText': 'Asha Bhosle', 'score': false},
      {'answerText': 'Sunidhi Chauhan', 'score': false},
      {'answerText': 'Shreya Ghoshal', 'score': false},
    ],
  },
];
