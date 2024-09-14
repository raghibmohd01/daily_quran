import 'package:flutter/material.dart';

class FilterWidget extends StatelessWidget {
   const FilterWidget({super.key, required this.filters});

   final  List<String> filters;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (BuildContext context, int index){


      return  Container(
          width: 120,
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.purpleAccent),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            onTap: () {
              print('item clicked');
            },
            title:  Center(child: Text(filters[index])),
          ));


    });



  }
}
