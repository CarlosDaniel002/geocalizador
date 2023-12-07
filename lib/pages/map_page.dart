//Carlos Daniel Taveras Liranzo
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

const MAPBOX_ACCESS_TOKEN ="pk.eyJ1IjoiY2FybG9zZGFuaWVsMDAyIiwiYSI6ImNscHVsd2piZzBsY3QyanBsMGpnbDJ5cHEifQ.s8yyDQH657PPLSADsCh1xQ";

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? markerPosition;

  @override
  Widget build(BuildContext context) {
    final Map<String,dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;

    final String nombre = args["nombre"];
    final String apellido = args["apellido"];
    final double latitud = args["latitud"];
    final double longitud = args["longitud"];

    markerPosition = LatLng(latitud, longitud);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mapa'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FlutterMap(
        options: MapOptions(
          center: markerPosition,
          minZoom: 5,
          maxZoom: 25,
          zoom: 18,
        ),
        nonRotatedChildren: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
            additionalOptions: const {
              'accessToken': MAPBOX_ACCESS_TOKEN,
              'id': 'mapbox/streets-v12'
            },
          ),
          MarkerLayer(
            markers: [
              Marker(point: markerPosition!, builder: (builder){
                return GestureDetector(
                    onTap: () async {
                      await showModalBottomSheet(context: context, builder: (context) {
                        return BottomSeetContent(
                          nombre: nombre,
                          apellido: apellido,
                          latitud: latitud,
                          longitud: longitud,
                          );
                        }
                      );
                    },
                    child: const Icon(
                      Icons.person_pin,
                      color: Colors.blueAccent,
                      size: 30,
                    ),
                  );
                }
              )
            ],
          )

        ],
      ),
    );
  }
}

class BottomSeetContent  extends StatelessWidget{
  final String nombre;
  final String apellido;
  final double latitud;
  final double longitud;

  const BottomSeetContent({
    required this.nombre,
    required this.apellido,
    required this.latitud,
    required this.longitud,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        Text('$nombre $apellido'),
        const SizedBox(height: 10),
        FutureBuilder(future: placemarkFromCoordinates(latitud, longitud), builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const CircularProgressIndicator();
          }
          else if(snapshot.hasError){
            return const Text('Error obteniendo la ubicacion');
          }
          else if(snapshot.hasData && snapshot.data!.isNotEmpty){
            final Placemark placemark = snapshot.data!.first;
            return Text('${placemark.locality}, ${placemark.country}');
          }
          else{
            return const Text('Ubicacion desconocida');
          }
        })
      ]),
    );
  }
}