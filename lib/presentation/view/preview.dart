import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_webspark/presentation/providers/app.dart';
import 'package:test_webspark/presentation/widgets/app_bar.dart';

class Preview extends StatefulWidget {
  const Preview({super.key, required this.index});

  final int index;

  @override
  State<StatefulWidget> createState() => PreviewState();

}

class PreviewState extends State<Preview>{
  int lenY = 0;
  int lenX = 0;
  late Map data;
  late List bodyAnswer;
  late List<String> path;

  @override
  void initState() {
    super.initState();
    data = context.read<AppProvider>().getData!;
    bodyAnswer = context.read<AppProvider>().getBodyAnswer;
    path = context.read<AppProvider>().getPath;
    lenY = data['data'][widget.index]['field'].length;
    lenX = data['data'][widget.index]['field'][0].length;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: myAppBar('Preview screen'),
          body: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: lenY,
                  itemBuilder: (BuildContext context, int indexY){
                    return SizedBox(
                      height: MediaQuery.of(context).size.width/lenX,
                      width: MediaQuery.of(context).size.width/lenX,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: lenX,
                        itemBuilder: (BuildContext context, int indexX){
                          Color color = data['data'][widget.index]['field'][indexY][indexX] == 'X'? const Color(0xFF000000) : (bodyAnswer[widget.index].first['y'] == indexY && bodyAnswer[widget.index].first['x'] == indexX) ? const Color(0xFF64FFDA) : (bodyAnswer[widget.index].last['y'] == indexY && bodyAnswer[widget.index].last['x'] == indexX) ? const Color(0xFF009688) : (bodyAnswer[widget.index][indexX]['y'] == indexY && bodyAnswer[widget.index][indexX]['x'] == indexX) ? const Color(0xFF4CAF50) : Colors.white;
                          return Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black
                                ),
                                color: color
                            ),
                            height: MediaQuery.of(context).size.width/lenX,
                            width: MediaQuery.of(context).size.width/lenX,
                            child: Center(
                              child: Text('(${indexX.toString()}.${indexY.toString()})',
                                style: TextStyle(
                                    color: data['data'][widget.index]['field'][indexY][indexX] == 'X'? Colors.white.withOpacity(0.3) : Colors.black
                                ),),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Text(path[widget.index])
            ],
          )
      ),
    );
  }
}
