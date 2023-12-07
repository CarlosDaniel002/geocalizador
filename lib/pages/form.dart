// ignore_for_file: unused_field, prefer_final_fields, sort_child_properties_last

import 'package:flutter/material.dart';
class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final GlobalKey<FormState> _fomrKey = GlobalKey<FormState>();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apellidoController = TextEditingController();
  TextEditingController _latitudController = TextEditingController();
  TextEditingController _longitudController = TextEditingController();

  String _nombre = '';
  String _apellido = '';
  late double _latitud;
  late double _longitud;

  void _handleMap(){
    try {
      if (_latitud >= -90 && _latitud<=90 && _longitud >= -180 && _longitud<=180){
        Navigator.of(context).pushNamed('/map', arguments: {
          'nombre': _nombre,
          'apellido': _apellido,
          'latitud': _latitud,
          'longitud': _longitud
        });
      }
      else{
        showDialog(context: context, builder: (BuildContext context){
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Las coordenadas deben estar dentro del rango valido'),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: const Text('Aceptar'))
            ],
          );
        });
      }
    }
    catch (e) {
      print('Error al enviar los datos al MapPages $e');

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _fomrKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: Image.network("https://scx2.b-cdn.net/gfx/news/hires/2018/location.jpg"),
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nombreController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Nombre'), validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Por favor Ingrese su nombre';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _nombre = value;
                      });
                    },
                  ),
                  TextFormField(
                  controller: _apellidoController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Apellido'), validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Por favor Ingrese su Apellido';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _apellido = value;
                      });
                    },
                  ),
                  TextFormField(
                  controller: _latitudController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Latitud'), validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Por favor Ingrese la latitud del lugar deseado';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        try {
                          final double parsedValued = double.parse(value);
                          setState(() {
                            _latitud = parsedValued;
                          });
                        } catch (e) {
                          print('Error al convertir a double $e');
                          setState(() {
                            _latitud = 0.0;
                          });
                        }
                      });
                    },
                  ),
                  TextFormField(
                  controller: _longitudController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Longitud'), validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Por favor Ingrese la longitud del lugar deseado';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        try {
                          final double parsedValued = double.parse(value);
                          setState(() {
                            _longitud = parsedValued;
                          });
                        } catch (e) {
                          print('Error al convertir a double $e');
                          setState(() {
                            _longitud = 0.0;
                          });
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if(_fomrKey.currentState!.validate()){
                        _handleMap();
                      }
                    }, child: const Text('Ver en el Mapa'),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}