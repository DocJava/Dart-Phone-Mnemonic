import 'dart:async';
import 'dart:html';
import 'trie.dart';

class MnemonicWordList {
  Trie trie = new Trie();
  RegExp isAllNumbersMatcher = new RegExp(r"[0-9]+");
  RegExp isAllLettersMatcher = new RegExp(r"[a-zA-z]+");


  MnemonicWordList() {
    _downloadAllToTrie();
  }

  //returns a sorted list of words
  List<String> getWords(String text) {
    text = text.toLowerCase();

    if (isAllNumbersMatcher.hasMatch(text)) {
      return trie.getNumberBasedWords(text);
    } else if (isAllLettersMatcher.hasMatch(text)) {
      return trie.getWordBasedWords(text);
    } else {
      throw new Exception("Bad format, trie again.");
    }
  }

  String convertToNumber(String text) {
    text = text.toLowerCase();

    if (isAllNumbersMatcher.hasMatch(text)) {
      return text;
    } else if (isAllLettersMatcher.hasMatch(text)) {
      return trie.getWordAsIndexes(text);
    } else {
      throw new Exception("Bad format, trie again.");
    }
  }

  void _addWordToString(String word) {
    trie.add(word.toLowerCase());
  }

  void _putWordsInTrie(String batch) {
    batch.split("\n").forEach(_addWordToString);
  }

  Future _downloadAllToTrie() async {
    var path = 'https://raw.githubusercontent.com/DocJava/Phone-Mnemonic/master/all-words.txt';
    try {
      _putWordsInTrie(await HttpRequest.getString(path));
    }
    catch (e) {
      print('Couldn\'t open $path');
      print(e);
    }
  }
}
