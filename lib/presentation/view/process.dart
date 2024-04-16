import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_webspark/presentation/providers/app.dart';
import 'package:test_webspark/presentation/widgets/app_bar.dart';

class Process extends StatefulWidget {
  const Process({super.key});

  @override
  State<StatefulWidget> createState() => ProcessState();

}

class ProcessState extends State<Process>{

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      context.read<AppProvider>().calculation();
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: myAppBar('Process screen'),
          body: SafeArea(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.only(left: 20, right: 12),
                      child: context.watch<AppProvider>().getSendResultStatus ? const CircularProgressIndicator() :
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.watch<AppProvider>().getMessage,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              '${(context.watch<AppProvider>().getProgressValue*100).toString()}%',
                              style: const TextStyle(
                                  fontSize: 25
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: 120,
                              height: 120,
                              child: CircularProgressIndicator(
                                value: context.watch<AppProvider>().getProgressValue,
                                strokeWidth: 5,
                              ),
                            ),
                          )
                        ],
                      )
                    ),
                  ),
                  if(context.watch<AppProvider>().getCalculationStatus)Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: context.watch<AppProvider>().getSendResultStatus == false ? (){
                                context.read<AppProvider>().sendResult(context);
                              } : null,
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(double.infinity, double.infinity),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  backgroundColor: context.watch<AppProvider>().getSendResultStatus ? Colors.grey : Colors.lightBlueAccent,
                                  side: BorderSide(width: 2, color: context.watch<AppProvider>().getSendResultStatus ? Colors.grey : Colors.blue)
                              ),
                              child: const Text("Send result to server",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black
                                ),
                              ),
                            )
                        ),
                      )
                  )
                ],
              )
          )
      ),
    );
  }
}
