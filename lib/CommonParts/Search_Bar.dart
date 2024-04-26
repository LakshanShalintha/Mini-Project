import 'package:flutter/material.dart';

class Search_Bar extends StatelessWidget {
  const Search_Bar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            children: [
              SizedBox(height: 70,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  width: 350,
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search,color: Colors.grey,),
                      SizedBox(
                        width: 20,
                      ),
                      Text('search in store',
                        style: Theme.of(context).textTheme.bodySmall,),
                    ],
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Search_Bar(),
  ));
}
