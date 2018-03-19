import 'dart:html';

import 'mnemonic_word_list.dart';

final NodeValidatorBuilder _validateHtml = new NodeValidatorBuilder.common()
  ..allowElement('br');

MnemonicWordList numberToWordDart;

Element app = querySelector('#app');
Element submit = querySelector('#submit');
TextInputElement input = querySelector('#text_input');
Element output = querySelector('#output');
Element startDisplay = querySelector('#start-display');
Element messageDisplay = querySelector('#message-display');

void main() {
  numberToWordDart = new MnemonicWordList();

  //words have been loaded
  startDisplay.text = "";
  app.setAttribute("style", "");
  submit.onClick.listen(runWithText);
  input.onKeyUp.listen(runWithTextOnEnter);
}

void runWithTextOnEnter(KeyboardEvent event) {
  if (event.keyCode == KeyCode.ENTER) {
    input.select();
  }

  if (input.value.isEmpty) {
    clearOutputAreas();
  } else {
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
    updateMessageText(
        "Bad format, trie again. Text should be ALL letters or ALL numbers");
    print(e);
    return;
  }

  clearOutputAreas();
  updateGroupDisplay(words, numberVersion);
}

void updateMessageText([String message = null]) {
  if (message == null) {
    messageDisplay.text = "";
    return;
  }

  messageDisplay.append(new Element.p()..text = message);
}

void clearOutputAreas() {
  output.text = "";
  updateMessageText();
}

void updateGroupDisplay(List<String> words, String numberVersion) {
  if (words.isEmpty) {
    updateMessageText("No words to display");
    return;
  }

  updateMessageText(
      "Getting other words that correspond with the number $numberVersion");

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

  String currentLetter = "";
  Element currentGroup;

  for(String word in words){
    String firstLetter = word[0];

    if (firstLetter != currentLetter) {
      currentLetter = firstLetter;
      currentGroup = createGroupForLetter(currentLetter);
    }

    Element span = new Element.span();
    span.text = word;

    currentGroup.append(span);
    currentGroup.append(new Element.br());
  }
}
