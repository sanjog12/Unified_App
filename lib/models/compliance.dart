class Compliance {
  final String title;
  final String value;
  bool checked;
  String userEmail;

  Compliance({this.userEmail, this.title, this.value, this.checked});

//  static complianceToMap(_compliances, List mails) {
//    var clientsContainer = {};
//    for (int i = 0; i < _compliances.length; i++) {
//      clientsContainer[mails[i]] = {};
//      for (int j = 0; j < _compliances[i].length; j++) {
//        clientsContainer[mails[i]][_compliances[i][j].value] = {
//          "title": _compliances[i][j].title,
//          "value": _compliances[i][j].value,
//        };
//      }
//    }
//
//    return clientsContainer;
//  }
}
