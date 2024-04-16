import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_webspark/presentation/view/result_list.dart';

import '../../data/http/service/api.dart';

class AppProvider with ChangeNotifier{
  String _url = '';
  bool _isValid = true;
  Map? _data;
  double _progressValue = 0;
  List _bodySend = [];
  String _message = 'Calculation of results, please wait';
  bool _calculationEnd = false;
  bool _sendResultStatus = false;
  List<String> _path = [];
  List _bodyAnswer = [];


  String get getURL => _url;
  bool get getValidStatus => _isValid;
  double get getProgressValue => _progressValue;
  String get getMessage => _message;
  bool get getCalculationStatus => _calculationEnd;
  bool get getSendResultStatus => _sendResultStatus;
  List<String> get getPath => _path;
  List get getBodyAnswer => _bodyAnswer;
  Map? get getData => _data;

  void changeURL(String newString) {
    _url = newString;
    if(Uri.parse(_url.trim()).isAbsolute) {
      _isValid = true;
    } else {
      _isValid = false;
    }
    notifyListeners();
  }

  Future<bool> getDataFromServer(BuildContext context) async{
    _data = await ApiService().getData(_url);
    if(_data == null){
      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid url')),
      );
      }
      return false;
    }
    return true;
  }

  void sendResult(BuildContext context) async{
    _bodyAnswer = [];
    _path = [];
    _sendResultStatus = true;
    notifyListeners();
    final sendData = await ApiService().sendData(_bodySend, _url);
    if(sendData!['error'] == false){
      for(int index = 0; index < _bodySend.length; index++) {_path.add(_bodySend[index]['result']['path']);}
      for(int index = 0; index < _bodySend.length; index++) {_bodyAnswer.add(_bodySend[index]['result']['steps']);}
      if(context.mounted) {
        Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ResultList(),
        ),
      );
      }
    } else{
      _message = sendData['message'];
    }
    _sendResultStatus = false;
    notifyListeners();
  }


  void calculation(){
    _bodySend = [];
    _calculationEnd = false;
    List result = [];
    List resultX = [];
    List resultY = [];
    List answer = [];
    if(_data != null){
      for(int index = 0; index < _data!['data'].length; index++){
        result.add([]);
        resultX.add([]);
        resultY.add([]);
        answer.add([]);
        for(int indexField = 0; indexField < _data!['data'][index]['field'].length; indexField++){
          for(int indexElement = 0; indexElement < _data!['data'][index]['field'][indexField].length; indexElement++){
            if(_data!['data'][index]['field'][indexField][indexElement] == '.'){
              result[index].add({'x': indexElement, 'y': indexField});
            }
          }

        }
        if(_data!['data'][index]['start']['x'] == _data!['data'][index]['end']['x']){
          resultX[index].add(_data!['data'][index]['start']['x']);
        } else if(_data!['data'][index]['start']['x'] > _data!['data'][index]['end']['x']){
          for(int indexX = _data!['data'][index]['start']['x']; indexX >= _data!['data'][index]['end']['x']; indexX--){
            resultX[index].add(indexX);
          }
        } else {
          for(int indexX = _data!['data'][index]['start']['x']; indexX <= _data!['data'][index]['end']['x']; indexX++){
            resultX[index].add(indexX);
          }
        }
        if(_data!['data'][index]['start']['y'] == _data!['data'][index]['end']['y']){
          resultY[index].add(_data!['data'][index]['start']['y']);
        } else if(_data!['data'][index]['start']['y'] > _data!['data'][index]['end']['y']){
          for(int indexX = _data!['data'][index]['start']['y']; indexX >= _data!['data'][index]['end']['y']; indexX--){
            resultY[index].add(indexX);
          }
        } else {
          for(int indexX = _data!['data'][index]['start']['y']; indexX <= _data!['data'][index]['end']['y']; indexX++){
            resultY[index].add(indexX);
          }
        }
        if(resultX[index].length == resultY[index].length){
          for(int indexAnswer = 0; indexAnswer < resultX[index].length; indexAnswer++){
            for(int indexResult = 0; indexResult < result[index].length; indexResult++){
              if(resultX[index][indexAnswer] == result[index][indexResult]['x'] && resultY[index][indexAnswer] == result[index][indexResult]['y']){
                answer[index].add({'x': resultX[index][indexAnswer], 'y': resultY[index][indexAnswer]});
              }
            }
          }
        } else if(resultX[index].length > resultY[index].length){
          for(int indexAnswer = 0; indexAnswer < resultX[index].length; indexAnswer++){
            for(int indexResult = 0; indexResult < result[index].length; indexResult++){
              if(indexAnswer == 0){
                if(resultX[index][indexAnswer] == result[index][indexResult]['x'] && resultY[index][indexAnswer] == result[index][indexResult]['y']){
                  answer[index].add({'x': result[index][indexResult]['x'], 'y': result[index][indexResult]['y']});
                }
              } else{
                if(resultX[index][indexAnswer] == result[index][indexResult]['x'] && resultY[index][indexAnswer-1] == result[index][indexResult]['y']){
                  answer[index].add({'x': result[index][indexResult]['x'], 'y': result[index][indexResult]['y']});
                } else if(resultX[index][indexAnswer] == result[index][indexResult]['x'] && resultY[index][indexAnswer-1]+1 == result[index][indexResult]['y']){
                  answer[index].add({'x': result[index][indexResult]['x'], 'y': result[index][indexResult]['y']});
                }
              }
            }
          }
        } else{
          for(int indexAnswer = 0; indexAnswer < resultY[index].length; indexAnswer++){
            for(int indexResult = 0; indexResult < result[index].length; indexResult++){
              if(indexAnswer == 0){
                if(resultX[index][indexAnswer] == result[index][indexResult]['x'] && resultY[index][indexAnswer] == result[index][indexResult]['y']){
                  answer[index].add({'x': result[index][indexResult]['x'], 'y': result[index][indexResult]['y']});
                }
              } else{
                if(resultX[index][indexAnswer - 1] == result[index][indexResult]['x'] && resultY[index][indexAnswer] == result[index][indexResult]['y']){
                  answer[index].add({'x': result[index][indexResult]['x'], 'y': result[index][indexResult]['y']});
                } else if(resultX[index][indexAnswer-1]+1 == result[index][indexResult]['x'] && resultY[index][indexAnswer] == result[index][indexResult]['y']){
                  answer[index].add({'x': result[index][indexResult]['x'], 'y': result[index][indexResult]['y']});
                }
              }
            }
          }
        }
        _progressValue = (1/_data!['data'].length)*(index+1);
        notifyListeners();
        String path = '';
        for(int i = 0; i < answer[index].length; i++){
          if(i == 0){
            path += '(${answer[index][i]['x']}.${answer[index][i]['y']})';
          } else{
            path += ' -> (${answer[index][i]['x']}.${answer[index][i]['y']})';
          }
        }
        _bodySend.add({'id': _data!['data'][index]['id'], 'result': {'steps': answer[index],'path': path}});
      }
    } else{
      if (kDebugMode) {
        print('error');
      }
    }
    _calculationEnd = true;
    _message = 'All calculations has finished, you can send your result to server';
    notifyListeners();
  }

}