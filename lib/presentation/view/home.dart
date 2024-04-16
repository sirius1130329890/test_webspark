import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_webspark/presentation/view/process.dart';
import 'package:test_webspark/presentation/widgets/app_bar.dart';

import '../providers/app.dart';

class Home extends StatelessWidget{
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: myAppBar('Home screen'),
          body: Padding(
              padding: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Set valid API base URL in order to continue'),
                  const SizedBox(height: 20,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Icon(Icons.compare_arrows, size: 30, color: Colors.grey,),
                      ),
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                                  hintText: 'Enter your URL',
                                  errorText: context.watch<AppProvider>().getValidStatus ? null : 'Invalid URL'
                              ),
                              onChanged: (newData) => context.read<AppProvider>().changeURL(newData),
                            ),
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: context.watch<AppProvider>().getValidStatus ? () async{
                          if(await context.read<AppProvider>().getDataFromServer(context)){
                            if(context.mounted) {
                              Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const Process(),
                              ),
                            );
                            }
                          }
                        } : null,
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(double.infinity, double.infinity),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            backgroundColor: context.watch<AppProvider>().getValidStatus ? Colors.lightBlueAccent : Colors.grey,
                            side: BorderSide(width: 2, color: context.watch<AppProvider>().getValidStatus ? Colors.blue : Colors.grey)
                        ),
                        child: const Text("Start counting process",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black
                          ),
                        ),
                      )
                  ),
                  const SizedBox(height: 10,)
                ],
              )
          )
      ),
    );
  }
}