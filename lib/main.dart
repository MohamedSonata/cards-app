import 'package:cardsapp/layout/app_layout.dart';
import 'package:cardsapp/shared/app_colors/app_colors.dart';
import 'package:cardsapp/shared/components/reuseable_components.dart';
import 'package:cardsapp/shared/custom_widgets/app_maintenance_screen.dart';
import 'package:cardsapp/shared/local/cache_helper.dart';
import 'package:cardsapp/shared/remote/bloc_observer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_screens/app_register/app_register_screen.dart';
import 'app_screens/internet_error_widget/internet_error_widget.dart';
import 'layout/cubit/cubit.dart';
import 'layout/cubit/states.dart';
import 'login_screen/social_login_screen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown
    ]
  );
  await Firebase.initializeApp();
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();


   uId = CacheHelper.getData(key: 'uId');
  isAdmin = CacheHelper.getData(key: 'isAdmin');
  relatedBranchID = CacheHelper.getData(key: 'relatedBranchID');

   print(relatedBranchID);
   print(uId);
   print("isAdmin:$isAdmin");

  // Query priceQuery = FirebaseFirestore.instance.collection('users').equalTo(uId);



  Widget widget;
  if (uId !=null) {
    widget = const AppLayout();
  } else {
    widget = AppLoginScreen();
  }
  runApp( MyApp(
      startWidget: widget,
          uId: uId,
    isAdmin: isAdmin,
    relatedBranchID:relatedBranchID ,
  ));




}
// id 'com.google.gms.google-services'
class MyApp extends StatelessWidget {
   MyApp({Key? key,required this.startWidget,this.uId,this.isAdmin,this.relatedBranchID}) : super(key: key);
  final Widget startWidget;
   final String? uId;
   final String? relatedBranchID;
   final bool? isAdmin;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: true,
          create: (context) => AppCubit()..checkInternet()..enableDisableApp(),
        ),
      ],
      child:  BlocConsumer<AppCubit,AppCubitStates>(
        listener: (context,state){},
        builder: (context,state){
          return StreamBuilder(
            stream: Stream.periodic(Duration(seconds: 2)).asyncMap((event) => AppCubit.get(context)..checkInternet()..enableDisableApp()),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
              return MaterialApp(



                title: 'ChargeCards',


                theme: ThemeData(


                  textTheme: TextTheme(


                  ),
                  scaffoldBackgroundColor: Colors.white,
                  primaryColor: AppColors.kTextDarkColor,
                  appBarTheme: AppBarTheme(
                      elevation: 0.4,

                      color: Colors.white,
                      foregroundColor: AppColors.kTextDarkColor
                  ),
                  // This is the theme of your application.
                  //
                  // Try running your application with "flutter run". You'll see the
                  // application has a blue toolbar. Then, without quitting the app, try
                  // changing the primarySwatch below to Colors.green and then invoke
                  // "hot reload" (press "r" in the console where you ran "flutter run",
                  // or simply save your changes to "hot reload" in a Flutter IDE).
                  // Notice that the counter didn't reset back to zero; the application
                  // is not restarted.
                  primarySwatch: Colors.blue,
                ),
                themeMode: ThemeMode.light,
                home: Builder(
                  builder: (context){
                    return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                            textScaleFactor: .85
                        ),
                        child: AppCubit.get(context).internetTesting ? AppCubit.get(context).isAppWorking == true ? const AppMaintenanceScreen()  :startWidget: const InternetErrorWidget());
                  },
                ),
              );
            },

          );

        },

      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'بسم الله واستعن بالله على اول تطبيق يطلب مني',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
