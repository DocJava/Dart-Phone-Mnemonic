import 'dart:html';

import 'NumberToWord.dart';

final NodeValidatorBuilder _validateHtml = new NodeValidatorBuilder.common()
  ..allowElement('br');

NumberToWordDart numberToWordDart;

Element app = querySelector('#app');
Element submit = querySelector('#submit');
TextInputElement input = querySelector('#text_input');
Element output = querySelector('#output');
Element startDisplay = querySelector('#start-display');
Element messageDisplay = querySelector('#message-display');

void main() {
  numberToWordDart = new NumberToWordDart();

  //words have been loaded
  startDisplay.text = "";
  app.setAttribute("style", "");
  submit.onClick.listen(runWithText);
  input.onKeyUp.listen(runWithTextOnEnter);
}

void runWithTextOnEnter(KeyboardEvent event) {
  if (event.keyCode == KeyCode.ENTER) {
    runWithText(null);
  }
}

void runWithText(MouseEvent event) {
  String text = input.value;
  print("running with text: $text");
  List<String> words;
  String numberVersion;
  try {
    words = numberToWordDart.getWords(text);
    numberVersion = numberToWordDart.convertToNumber(text);
  } catch (e) {
    messageDisplay.text =
    "Bad format, trie again. Text should be All letters or all numbers";
    print(e);
    return;
  }

  messageDisplay.text = "";
  output.text = "";
  updateGroupDisplay(words, numberVersion);
  input.select();
}

void updateGroupDisplay(List<String> words, String numberVersion) {
  if (words.isEmpty) {
    messageDisplay.text = "No words to display";
    return;
  }

  messageDisplay.append(new Element.p()
    ..text = "Getting other words that coorespond with the number $numberVersion");

  Element createGroupForLetter(String letter) {
    Element group = new Element.div();
    group.setAttribute("id", "words");

    Element letterElement = new Element.header();
    letterElement.setAttribute("id", "grouped-letter");
    letterElement.setAttribute("unselectable", "");
    letterElement.text = letter;

    group.append(letterElement);

    output.append(group);

    return group;
  }

  int index = 0;
  String currentLetter = "";
  Element currentGroup;

  do {
    if (words[index][0] != currentLetter) {
      currentLetter = words[index][0];
      currentGroup = createGroupForLetter(currentLetter);
    }

    Element span = new Element.span();
    span.text = words[index];

    currentGroup.append(span);
    currentGroup.append(new Element.br());


    index += 1;
  } while (index < words.length);
}
