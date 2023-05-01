import 'package:cardsapp/shared/app_colors/app_colors_dark.dart';
import 'package:flutter/material.dart';

import '../../layout/cubit/cubit.dart';


class InternetErrorWidget extends StatelessWidget {
  const InternetErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaleFactor: .85
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('It Seems There\'s No Connection To Internet!',style: const TextStyle(fontSize: 18,color: Colors.black),),
            const Text('Check Your WIFI Or Mobile Data Connection',style: TextStyle(fontSize: 15,color: Colors.grey),),
            const SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                  color: AppDarkModeColors.kYellowColorShade200,
                  borderRadius: BorderRadius.circular(15)
              ),
              child: MaterialButton(
                onPressed: ()async{
                  await AppCubit.get(context).checkInternet();
                   AppCubit.get(context).getUserData();

                },
                child: FittedBox(
                  child: Row(
                    children: [
                      Icon(Icons.refresh_outlined),
                      SizedBox(width: 5,),
                      const Text('Reload',style: TextStyle(color: Colors.white,fontSize: 20),),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Image.asset('assets/images/NoConnection1.png')),
            ),
          ],
        ),
      ),
    );
  }
}
