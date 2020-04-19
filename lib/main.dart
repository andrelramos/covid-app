import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() => runApp(CovidApp());

class CovidListState extends State<CovidList> {

  Future<List<String>> _getCovidData() async {
    var api_url = 'https://covid19-brazil-api.now.sh/api/report/v1';
    var response = await http.get(api_url);

    List<String> data = [];
    
    if(response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      for (var state in jsonResponse["data"]) {
        data.add("${state['state']}: ${state['cases']}");
      }
    }

    return data;
  }

  Widget _buildCovidItens() {
    return FutureBuilder<List>(
      future: _getCovidData(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        var covid_data = snapshot.data;

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: covid_data.length,
          itemBuilder: (context, i ) {
            if (i <=  covid_data.length) {}  
            return ListTile(
              title: Text(covid_data[i])
            );
          },
        );
      },
    ); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Casos de Covid-19 por estado'),
      ),
      body: _buildCovidItens(),
    );
  }

}

class CovidList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CovidListState();
}

class CovidApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Covid App",
      home: CovidList()
    );
  }

}
