bool _showLog = false;

void showLog() {
  _showLog = true;
}

void hideLog() {
  _showLog = false;
}

void log(Object message) {
  if (_showLog) {
    // ignore: avoid_print
    print(message);
  }
}
