import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_webspark/presentation/providers/app.dart';
import 'package:test_webspark/presentation/view/preview.dart';
import 'package:test_webspark/presentation/widgets/app_bar.dart';

class ResultList extends StatelessWidget{
  const ResultList({super.key});


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: myAppBar('Result list screen'),
          body: ListView.builder(
            itemCount: context.watch<AppProvider>().getPath.length,
            itemBuilder: (BuildContext context, int index){
              return Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                      child: TextButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Preview(index: index)),
                          );
                        },
                        child: Text(
                          context.watch<AppProvider>().getPath[index],
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black
                          ),
                        ),
                      )
                  ),
                  const Divider(color: Colors.grey),
                ],
              );
            },
          )
      ),
    );
  }
}