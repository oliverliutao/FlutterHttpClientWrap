import 'package:http/http.dart' as http;
import 'dart:async';
import '../ConstantUtil.dart';

typedef HttpClientResponseCallback = void Function(
    bool timeout, http.Response value);



class HttpClientTool {

  static http.Client clientSingleton;

  static http.Client sharedClient() {

    if (clientSingleton == null) {

      clientSingleton = new http.Client();

      return clientSingleton;
    }
    
    return clientSingleton;

  }

  static Future getRequest(
      String url, HttpClientResponseCallback callback) async {

    var client = HttpClientTool.sharedClient();

    Future<http.Response> response = client.get(url);

    response.then((value) {
      callback(false, value);
    }).catchError((error) {
      print("error:$error");
      callback(false, null);
    }).timeout(new Duration(seconds: ConstantUtil.HttpTimeout), onTimeout: () {
      callback(true, null);
    });
  }

  static Future postRequest(
      String url, String body, HttpClientResponseCallback callback) async {

    var client = HttpClientTool.sharedClient();

    Future<http.Response> response = client.post(url, body: body);

    response.then((value) {
      callback(false, value);
    }).catchError((error) {
      print("error:$error");
      callback(false, null);
    }).timeout(new Duration(seconds: ConstantUtil.HttpTimeout), onTimeout: () {
      callback(true, null);
    });
  }

  static Future putRequest(
      String url, String body, HttpClientResponseCallback callback) async {

    var client = HttpClientTool.sharedClient();

    Future<http.Response> response = client.put(url, body: body);

    response.then((value) {
      callback(false, value);
    }).catchError((error) {
      print("error:$error");
      callback(false, null);
    }).timeout(new Duration(seconds: ConstantUtil.HttpTimeout), onTimeout: () {
      callback(true, null);
    });
  }

  static Future deleteRequest(
      String url, HttpClientResponseCallback callback) async {
        
    var client = HttpClientTool.sharedClient();

    Future<http.Response> response = client.delete(url);

    response.then((value) {
      callback(false, value);
    }).catchError((error) {
      print("error:$error");
      callback(false, null);
    }).timeout(new Duration(seconds: ConstantUtil.HttpTimeout), onTimeout: () {
      callback(true, null);
    });
  }


}


----------------------

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../ConstantUtil.dart';
import './HttpClientTool.dart';
import './User.dart';

//login callback
typedef LoginApiCallback = void Function(bool timeout, User user);

typedef PostAPICallback = void Function(bool timeout, bool succeed);

typedef PutAPICallback = void Function(bool timeout, bool succeed);

typedef DeleteAPICallback = void Function(bool timeout, bool succeed);

class APIHttpCall {
  
  static performGetApi(LoginApiCallback callback) {
    final url = "https://jsonplaceholder.typicode.com/posts/1";
    // final url = "https://192.168.0.0";

    // String jsontostring = {
    // "userId": 999,
    // }.toString();

    // print("jsontostring --- $jsontostring");


    // final result =  JSON.decode(jsontostring)["userId"];
    // print(" result = $result");


    HttpClientTool.getRequest(url, (bool timeout, http.Response value) {
      if (timeout) {
        callback(true, null);
      } else {
        if (value != null) {
          int statusCode = value.statusCode;

          if (statusCode >= 200 && statusCode < 300) {
            print("body = $value.body");
            print(JSON.decode(value.body)["body"]);
            User user = new User.fromJson(JSON.decode(value.body));
            print(user.userId);
            print(user.id);
            print(user.title);
            print(user.body);

            final resu = user.toString();
            print("test user = $resu");

            callback(false, user);
          } else {
            callback(false, null);
          }
        } else {
          callback(false, null);
        }
      }
    });
  }

  static performPOSTAPI(String para, PostAPICallback callback) {
    final url = "http://jsonplaceholder.typicode.com/posts";

    HttpClientTool.postRequest(url, para, (bool timeout, http.Response value) {
      if (timeout) {
        callback(true, false);
      } else {
        if (value != null) {
          int statusCode = value.statusCode;

          if (statusCode >= 200 && statusCode < 300) {
            callback(false, true);
          } else {
            print("statusCode: $statusCode");

            callback(false, false);
          }
        } else {
          callback(false, false);
        }
      }
    });
  }

  static performPUTAPI(String para, PutAPICallback callback) {
    final url = "http://jsonplaceholder.typicode.com/posts/1";

    HttpClientTool.putRequest(url, para, (bool timeout, http.Response value) {
      if (timeout) {
        callback(true, false);
      } else {
        if (value != null) {
          int statusCode = value.statusCode;

          if (statusCode >= 200 && statusCode < 300) {
            callback(false, true);
          } else {
            print("statusCode: $statusCode");

            callback(false, false);
          }
        } else {
          callback(false, false);
        }
      }
    });
  }

  static performDELETEAPI(DeleteAPICallback callback) {
    final url = "http://jsonplaceholder.typicode.com/posts/1";

    HttpClientTool.deleteRequest(url, (bool timeout, http.Response value) {
      if (timeout) {
        callback(true, false);
      } else {
        if (value != null) {
          int statusCode = value.statusCode;

          if (statusCode >= 200 && statusCode < 300) {
            callback(false, true);
          } else {
            print("statusCode: $statusCode");

            callback(false, false);
          }
        } else {
          callback(false, false);
        }
      }
    });
  }
}


-----------------
 how to use?
    
 APIHttpCall.performGetApi(_handleResponse);

 _handleResponse(bool timeout, User user) {
    if (mounted) {
      _dismissFloatingIndicator();

      if (timeout) {
        this._showSnackIndicator("Timeout,please try again");

        // _showDialog("timeout");

      } else {
        if (user != null) {
          //go to next page
          Navigator.of(context).pushReplacementNamed("/drawer");

          this._showSnackIndicator("succeed");

          // _showDialog("succeed");
        } else {
          this._showSnackIndicator("Something went wrong,please try again");

          // _showDialog("error");
        }
      }
    }
  }



    
    


