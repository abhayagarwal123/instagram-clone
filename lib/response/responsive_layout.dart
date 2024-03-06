import 'package:flutter/material.dart';
import 'package:igclone/provider/userprovider.dart';
import 'package:igclone/util/dimension.dart';
import 'package:provider/provider.dart';

class Responsivelayout extends StatefulWidget{
  Widget weblayout;
  Widget mobilelayout;
   Responsivelayout({super.key,required this.mobilelayout,required this.weblayout});

  @override
  State<Responsivelayout> createState() => _ResponsivelayoutState();
}

class _ResponsivelayoutState extends State<Responsivelayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }
  addData() async {
    UserProvider userProvider =
    Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if(constraints.maxWidth>websize){
        return widget.weblayout;
      }
      return widget.mobilelayout;
    },);
  }
}