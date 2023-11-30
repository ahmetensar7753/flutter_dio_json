import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_json/model/araba_model.dart';

class LocalJson extends StatefulWidget {
  const LocalJson({Key? key}) : super(key: key);

  @override
  State<LocalJson> createState() => _LocalJsonState();
}

class _LocalJsonState extends State<LocalJson> {
  String _title = 'Local Json Islemleri';

  late final Future<List<Araba>> _listeyiDoldur;

  @override
  void initState() {
    super.initState();
    _listeyiDoldur = arabalarJsonOku();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        setState(() {
          _title = 'Buton Tıklandı';
        });
      }),
      body: FutureBuilder<List<Araba>>(
        future: _listeyiDoldur,
        /* initialData: [ //inital data : future (gerçek liste) oluşana kadar ekranda gösterilecek datalar.
          Araba(
              arabaAdi: 'aaa',
              ulke: 'bbb',
              kurulusYil: 1922,
              model: [Model(modelAdi: 'modelAdi', fiyat: 52, benzinli: false)])
        ], */
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Araba> arabaListesi = snapshot.data!;
            return ListView.builder(
                itemCount: arabaListesi.length,
                itemBuilder: (context, index) {
                  Araba oankiAraba = arabaListesi[index];
                  return ListTile(
                    title: Text(oankiAraba.arabaAdi),
                    subtitle: Text(oankiAraba.ulke),
                    leading: CircleAvatar(
                      child: Text(
                        oankiAraba.model[0].fiyat.toString(),
                      ),
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<List<Araba>> arabalarJsonOku() async {
    try {
      await Future.delayed(const Duration(seconds: 5));
      String okunanString = await DefaultAssetBundle.of(context)
          .loadString('assets/data/arabalar.json');

      var jsonObject = jsonDecode(okunanString);

      List<Araba> tumArabalar = (jsonObject as List)
          .map((arabaMap) => Araba.fromMap(arabaMap))
          .toList();

      debugPrint(tumArabalar.length.toString());

      return tumArabalar;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error(e.toString());
    }
  }
}
