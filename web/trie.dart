class Trie {
  Node root = new Node();
  int offset = 'a'.codeUnitAt(0);

  // Numbers on a phone -> The letter options, and back again
  List<int> lettersToNumbers = [
    2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 9, 9, 9, 9
  ];
  List<List<String>> numbersToLetters = [
    ['a', 'b', 'c'],
    ['d', 'e', 'f'],
    ['g', 'h', 'i'],
    ['j', 'k', 'l'],
    ['m', 'n', 'o'],
    ['p', 'q', 'r', 's'],
    ['t', 'u', 'v'],
    ['w', 'x', 'y', 'z']
  ];

  void add(String word) {
    Node parent = root;
    for (int letter in word.codeUnits) {
      letter -= offset;
      Node child = parent.nodes[letter];
      if (child == null) {
        child = new Node();
        parent.nodes[letter] = child;
      }
      parent = child;
    }
    parent.isEndOfWord = true;
  }

  // in = 323 out = dad, some other 3 letter one words
  List<String> getNumberBasedWords(String number) {
    print("getting number based words for $number");
    List<String> words = new List();
    _getWords(number, 0, "", words, root);
    return words;
  }

  // finds the letters corresponding to each number and creates more strings with the new letters at the end of each
  void _getWords(String indexes, int index, String currentString,
      List<String> words, Node currentNode) {
    if (currentNode == null) {
      return;
    } else if (index == indexes.length) {
      if (currentNode.isEndOfWord) {
        words.add(currentString);
      }
      return;
    }

    for (String letter in numbersToLetters[indexes.codeUnitAt(index) -
        '2'.codeUnitAt(0)]) {
      Node nextNode = currentNode.nodes[letter.codeUnitAt(0) - offset];
      _getWords(indexes, index + 1, currentString + letter, words, nextNode);
    }
  }

  String getWordAsIndexes(String word) {
    String indexes = "";
    for (int letter in word.codeUnits) {
      indexes += "${lettersToNumbers[letter - offset]}";
    }
    return indexes;
  }

  // in dad, convert to 323, then return the conversions of those numbers to strings
  List<String> getWordBasedWords(String word) {
    print("getting word based words for $word");
    String indexes = getWordAsIndexes(word);
    return getNumberBasedWords(indexes);
  }

  // starts recursive function _contains with default values
  bool contains(String word) {
    return _contains(word, 0, root);
  }

  // only returns true if the ending node IS the end of the word
  bool _contains(String word, int index, Node currentNode) {
    if (currentNode == null) {
      return false;
    } else if (index == word.length) {
      return currentNode.isEndOfWord;
    }
    return _contains(
        word, index + 1, currentNode.nodes[word.codeUnitAt(index) - offset]);
  }
}

class Node {
  List<Node> nodes = new List(26);
  bool isEndOfWord = false;
}