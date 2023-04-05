import 'package:flutter/material.dart';

import 'mainmenu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHome());
  }
}

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade800,
      body: Center(child: Stack(
        children: [

          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              Image.asset('assets/images/Dr.Preferenec-removebg-preview.png',),
              SizedBox(height: 50,),
              ElevatedButton(onPressed: (){}, 
              child: Text('Login', style: TextStyle(fontSize: 24),), style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.purple.shade500),
                foregroundColor: MaterialStateProperty.all(Colors.grey.shade400),
                minimumSize: MaterialStateProperty.all(Size(200,75))

              ),),
              SizedBox(height: 10,),
              Text('Or...',style: TextStyle(fontSize: 25, color: Colors.grey.shade400),),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: (){}, 
              child: Text('Register', style: TextStyle(fontSize: 24),), style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.purple.shade500),
                foregroundColor: MaterialStateProperty.all(Colors.grey.shade400),
                minimumSize: MaterialStateProperty.all(Size(200,75))

              ),),
                            SizedBox(height: 60,),

            ]),
            
          )
        ],
      )
      ,)
    );

  }
}
   /*  return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.green.shade800,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 300),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey.shade400),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.green.shade800),
                    minimumSize: MaterialStateProperty.all(Size(200, 100))),
                child: Text(
                  "Go!",
                  style: TextStyle(fontSize: 40),
                ),
                onPressed: () => MyCustomClass.openNewScreen(context)),
          ),
        ),
      ),
    );*/