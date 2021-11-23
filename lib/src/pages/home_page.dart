import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/datos_censo.dart';
import 'package:formvalidation/src/models/datos_vivienda_model.dart';
import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:formvalidation/src/providers/constantes.dart';
import 'package:formvalidation/src/providers/visita_provider.dart';
import 'package:formvalidation/src/utils/number.dart';
import 'package:formvalidation/src/widgets/app_alertdialog.dart';
import 'package:formvalidation/src/widgets/loader.dart';
import 'package:formvalidation/src/widgets/progress_bar.dart';
import 'package:intl/intl.dart';


import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    int _currentIndex = 0;

final _prefs = new PreferenciasUsuario();

  final VisitaProvider provider = new VisitaProvider();
  Future _future;
  final formKey = GlobalKey<FormState>();
  // Map<String, dynamic> mapInsert = new Map<String, dynamic>();
  // VisitaBloc bloc;
  // VisitaProvider provider = new VisitaProvider();
  // PageController controller = PageController();
  String viviendaId;

  DatosViviendaModel datosVivienda;

  List<SalesData> data = [ ];

  // @override
  // void initState() {
  //   super.initState();
  //   // _future = provider.getDatosCenso();
  // }

     @override
  void initState() {
    super.initState();
    _future = provider.getProductividad1();
  }

  @override
  Widget build(BuildContext context) {

  //  bloc = LocalProvider.visitaBloc(context);
    return Scaffold(
      appBar: _crearAppBar(context),
      //body: crearBody(context),
      body: FutureBuilder(
            future: _future,
            builder:  (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.hasData){
               // List<SalesData> data= snapshot.data;
                data = [];
   
               for (var item in snapshot.data) {
                data.add(SalesData.fromJson(item));
              }

                print("Todo ${data.toString()}");
                
              }

              return Stack(
                children: <Widget>[
                  _crearBody(context),

                

                ],
              );
            },
      ),
    //   bottomNavigationBar: BottomNavigationBar(
        
    //     backgroundColor: Colors.green, selectedItemColor: Colors.white,
    //   //currentIndex: 0, // this will be set when a new tab is tapped
    //    currentIndex: _currentIndex,
    //     onTap: onTabTapped,
    //    items: [
    //      BottomNavigationBarItem(
    //        icon: new Icon(Icons.home),
    //        title: new Text('Home'),
    //      ),
    //      BottomNavigationBarItem(
    //        icon: new Icon(Icons.menu),
    //        title: new Text('Gestion'),
           
    //       // backgroundColor: Color(colors.accents),
    //      ),
         
    //    ],
    //  ),
   
    );
  }


    Widget _crearAppBar(context){
    return AppBar(
        title: Text('Inicio', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (choice) => choiceAction(choice, context),
            icon: Icon(Icons.perm_identity),
            itemBuilder: (BuildContext context){
              return ConstPopUp().retrieveListaPop().map((String choice){
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice, style: ConstPopUp.salir != choice ? TextStyle(fontWeight: FontWeight.normal ) : TextStyle(color: Colors.green, fontWeight: FontWeight.w600),),
                  );
              }).toList();
            }      
         )
          
          /*IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
             
              },
            )*/


          /*CircleAvatar(
            backgroundImage: Icons.perm_identity,
            child: PopupMenuButton(
              itemBuilder: (BuildContext context){
                return ConstPopUp().retrieveListaPop().map((String choice){
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              }
            ),
          )*/
        ] 
      );
  }

  void choiceAction(String choice, BuildContext context){
    if(choice == ConstPopUp.salir){

      final bloc = LocalProvider.of(context);
     bloc.changeEmail("");

      //elimino el token que habia usado para loguearme
      final _prefs = new PreferenciasUsuario();
      print( _prefs.token.toString());
      _prefs.token="null";
      _prefs.infoUser ="";
      print( _prefs.token.toString());
     // Navigator.pushNamed(context, 'login');
     Navigator.pushReplacementNamed(context, 'login');
    }
     
  }
void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

   Widget _crearBody(context){

     return /*Column(

       children: [*/
          Container(
     height: 500,
      //width: 200,
       child: Center(
        child:SfCircularChart(
       
        title: ChartTitle(text: 'Mi Productividad'),
        legend: Legend(isVisible: true),
        series: <PieSeries<SalesData, String>>[
       PieSeries<SalesData, String>(
         explode: true,
         explodeIndex: 0,
         dataSource: data,
         xValueMapper: (SalesData data, _) => data.title.toString(),
         yValueMapper: (SalesData data, _) => data.data,
         dataLabelMapper: (SalesData data, _) => data.data.toString(),
         dataLabelSettings: DataLabelSettings(
           isVisible: true,
         //  labelPosition: ChartDataLabelPosition.outside
           //,offset: Offset(0, 30),
           
)),
         
        ]
       )
       ),
     );
    /* SfCartesianChart(
               primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(text: 'Visitas'),
              // Enable legend
              legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              
              series: <ChartSeries<SalesData, String>>[
                LineSeries<SalesData, String>(
                    dataSource: data,
                    xValueMapper: (SalesData data, _) => data.title,
                    yValueMapper: (SalesData data, _) =>data.data,
                    name: 'Sales',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true))
              ]),
               Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              //Initialize the spark charts widget
              child: SfSparkLineChart.custom(
                //Enable the trackball
                trackball: SparkChartTrackball(
                    activationMode: SparkChartActivationMode.tap),
                //Enable marker
                marker: SparkChartMarker(
                    displayMode: SparkChartMarkerDisplayMode.all),
                //Enable data label
                labelDisplayMode: SparkChartLabelDisplayMode.all,
              //  xValueMapper: (int index) => data[index].year,
              //  yValueMapper: (int index) => data[index].sales,
                dataCount: 5,
              ),
            ),
          )*/

     /*  ],
     );*/
     
     
     
    
  

   // List<SalesData> data = provider.getProductividad1();
    // return Column(children: [
    //       //Initialize the chart widget
    //       SfCartesianChart(
    //           primaryXAxis: CategoryAxis(),
    //           // Chart title
    //           title: ChartTitle(text: 'Half yearly sales analysis'),
    //           // Enable legend
    //           legend: Legend(isVisible: true),
    //           // Enable tooltip
    //           tooltipBehavior: TooltipBehavior(enable: true),
              
    //           series: <ChartSeries<SalesData, String>>[
    //             LineSeries<SalesData, String>(
    //                 dataSource: data,
    //                 xValueMapper: (SalesData sales, _) => sales.title,
    //                 yValueMapper: (SalesData sales, _) => sales.data,
    //                 name: 'Sales',
    //                 // Enable data label
    //                 dataLabelSettings: DataLabelSettings(isVisible: true))
    //           ]),
    //       Expanded(
    //         child: Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           //Initialize the spark charts widget
    //           child: SfSparkLineChart.custom(
    //             //Enable the trackball
    //             trackball: SparkChartTrackball(
    //                 activationMode: SparkChartActivationMode.tap),
    //             //Enable marker
    //             marker: SparkChartMarker(
    //                 displayMode: SparkChartMarkerDisplayMode.all),
    //             //Enable data label
    //             labelDisplayMode: SparkChartLabelDisplayMode.all,
    //           //  xValueMapper: (int index) => data[index].year,
    //           //  yValueMapper: (int index) => data[index].sales,
    //             dataCount: 5,
    //           ),
    //         ),
    //       )
    //     ]
    // );
  
  
  
  }

}

class ConstPopUp {
  static const String salir = 'Cerrar sesión';
  String userInfo;

  final _prefs = new PreferenciasUsuario();


  List<String> listaPop = new List();
  
  List<String> retrieveListaPop(){
    listaPop.add("Version: 2.0");
    listaPop.add(_prefs.infoUser);
    listaPop.add(salir);
    return listaPop;
  }
  
  

}