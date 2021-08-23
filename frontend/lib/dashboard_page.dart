import 'package:flutter/material.dart';
import 'package:frontend/api_entities.dart';
import 'package:frontend/graph_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

const favoriteBlueColor = Color.fromRGBO(75, 123, 236, 1);

class DashboardPage extends StatelessWidget {
  final ProcessAudioResponse processedAudio;

  DashboardPage(this.processedAudio);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Отчет по аудиозаписи"),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.open_in_new),
                label: Text('Open graph page'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GraphPage(),
                      ));
                },
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.open_in_new),
                label: Text('Open II graph page'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GraphPageTwo(),
                      ));
                },
              ),
              SizedBox(width: 10),
              ElevatedButton.icon(
                icon: Icon(Icons.open_in_new),
                label: Text('Open III graph page'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GraphPageThree(),
                      ));
                },
              ),
              SizedBox(width: 100),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: ListView(
          children: [
            _buildSecondRow(context),
            _buildThirdRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleMetric(BuildContext context, IconData icon, String title,
      String body, String hint) {
    return SizedBox(
      width: 300,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(
                icon,
                color: favoriteBlueColor,
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                Text(title),
                Icon(
                  Icons.arrow_drop_down,
                  color: favoriteBlueColor,
                )
              ]),
              Text(
                body,
                style: TextStyle(
                    color: favoriteBlueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              Text(
                hint,
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSecondRow(BuildContext context) {
    var benevolence = (this.processedAudio.politeness.positive +
            this.processedAudio.politeness.friendly) /
        2;
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      children: [
        _buildCircleDiagramMetric(context, "Позитивная вежливость в разговоре",
            this.processedAudio.politeness.positive),
        _buildChartMetric(context, "Эмоциональная динамика",
            "Статистика за разговор", this.processedAudio.bertParted),
        _buildCircleDiagramMetric(
            context, "Доброжелательность в разговоре", benevolence),
      ],
    );
  }

  Widget _buildCircleDiagramMetric(
      BuildContext context, String title, double percent) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(13.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: 200,
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Container(
                height: 200,
                child: SfCircularChart(
                    annotations: <CircularChartAnnotation>[
                      CircularChartAnnotation(
                          widget: Container(
                              child: Text(doubleToPercent(percent),
                                  style: TextStyle(
                                      color: favoriteBlueColor, fontSize: 30))))
                    ],
                    title: ChartTitle(text: ''),
                    series: <DoughnutSeries<_PieData, String>>[
                      DoughnutSeries<_PieData, String>(
                          dataSource: <_PieData>[
                            _PieData("asd", percent * 100, ""),
                            _PieData("asd", (1 - percent) * 100, ""),
                          ],
                          xValueMapper: (_PieData data, _) => data.xData,
                          yValueMapper: (_PieData data, _) => data.yData,
                          dataLabelMapper: (_PieData data, _) => data.text,
                          dataLabelSettings:
                              DataLabelSettings(isVisible: false)),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThirdRow(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      direction: Axis.horizontal,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildSimpleMetric(context, Icons.mood, "Настроение разговора",
                this.processedAudio.sentiments.predictedClass, ""),
            SizedBox(height: 15),
            _buildSimpleMetric(
                context,
                Icons.format_italic_rounded,
                "Формальность в разговоре",
                doubleToPercent(this.processedAudio.politeness.formal),
                ""),
          ],
        ),
        _buildCircleDiagramMetric(context, "Общая оценка разговора",
            this.processedAudio.politeness.average),
        _buildCircleDiagramMetric(context, "Общая вежливость",
            this.processedAudio.politeness.friendly),
        _buildCircleDiagramMetric(context, "Чистота речи в разговоре",
            this.processedAudio.politeness.clear),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildSimpleMetric(
                context,
                Icons.access_time,
                "Темп речи",
                this.processedAudio.textSpeed.speedClass,
                this.processedAudio.textSpeed.comment),
            SizedBox(height: 15),
            _buildSimpleMetric(
                context,
                Icons.waves,
                "Степень зашумленности фона",
                doubleToPercent(this.processedAudio.noise.noiseLevel),
                this.processedAudio.noise.comment),
          ],
        ),
      ],
    );
  }

  Widget _buildLineDiagramMetric(
      BuildContext context, String title, double percent) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(13.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doubleToPercent(percent),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: favoriteBlueColor,
                  fontSize: 22),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartMetric(
      BuildContext context, String title, String body, List<double> data) {
    return SizedBox(
      width: 750,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
                color: favoriteBlueColor,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          Text(
            body,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Container(
            height: 300,
            child: SfCartesianChart(
              legend: Legend(
                  isVisible: true, opacity: 0.7, position: LegendPosition.top),
              plotAreaBorderWidth: 0,
              primaryXAxis: NumericAxis(
                labelFormat: '{value}',
              ),
              series: convertChartData(data),
              tooltipBehavior: TooltipBehavior(enable: true),
            ),
          )
        ],
      ),
    );
  }

  static List<LineSeries<double, num>> convertChartData(List<double> data) {
    return <LineSeries<double, num>>[
      LineSeries<double, num>(
        dataSource: data,
        xValueMapper: (double data, int index) => index,
        yValueMapper: (double data, int index) => data,
        name: "Эмоциональность диалога",
      ),
    ];
  }
}

String doubleToPercent(double val) {
  return (val * 100).toStringAsFixed(0).toString() + '%';
}

class _PieData {
  _PieData(this.xData, this.yData, this.text);

  final String xData;
  final num yData;
  final String text;
}
