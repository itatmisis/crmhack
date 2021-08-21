import 'package:flutter/material.dart';
import 'package:frontend/api_entities.dart';
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
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: ListView(
          children: [
            _buildFirstRow(context),
            _buildSecondRow(context),
            _buildThirdRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstRow(BuildContext context) {
    // TODO: fix row overflow with wrap
    return Row(
      // body: Wrap(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // alignment: WrapAlignment.spaceBetween,
      // direction: Axis.horizontal,
      // TODO: use correct icons
      children: [
        _buildSimpleMetric(context, Icons.access_time, "Темп речи", "Быстро",
            "Необходимо говорить медленнее"),
        _buildSimpleMetric(context, Icons.handyman_sharp, "Общая вежливость",
            "75%", "Обратите внимание на тон речи"),
        _buildSimpleMetric(
            context,
            Icons.share_outlined,
            "Конструктивность диалога",
            "80%",
            "Не отвлекайтесь от темы разговора"),
        _buildSimpleMetric(context, Icons.waves, "Степень зашумленности фона",
            doubleToPercent(this.processedAudio.noise), "Шум в пределах нормы"),
      ],
    );
  }

  Widget _buildSimpleMetric(BuildContext context, IconData icon, String title,
      String body, String hint) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(
              icon,
              color: favoriteBlueColor,
            )),
        Column(
          // mainAxisAlignment: MainAxisAlignment.start,
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
              // textAlign: TextAlign.left,
            ),
            Text(
              hint,
              style: TextStyle(color: Colors.grey, fontSize: 10),
              // textAlign: TextAlign.left,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildSecondRow(BuildContext context) {
    // TODO: fix row overflow with wrap
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCircleDiagramMetric(
            context, "Позитивная вежливость в разговоре", 0.9),
        _buildCircleDiagramMetric(
            context, "Доброжелательность в разговоре", 0.5),
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
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: SizedBox(
          width: 300,
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Container(
                height: 210,
                child: SfCircularChart(
                    annotations: <CircularChartAnnotation>[
                      CircularChartAnnotation(
                          widget: Container(
                              child: Text(doubleToPercent(percent),
                                  style: TextStyle(
                                      color: favoriteBlueColor, fontSize: 35))))
                    ],
                    title: ChartTitle(text: ''),
                    series: <DoughnutSeries<_PieData, String>>[
                      DoughnutSeries<_PieData, String>(
                          radius: "95%",
                          // explode: true,
                          // explodeOffset: '50%',
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
    // TODO: fix row overflow with wrap
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCircleDiagramMetric(
            context, "Правильная интонация в разговоре", 0.95),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildLineDiagramMetric(
                context, "Конструктивность в разговоре", 0.4),
            _buildLineDiagramMetric(context, "Формальность в разговоре", 0.8),
          ],
        ),
        _buildCircleDiagramMetric(context, "Чистота речи в разговоре", 0.2),
        _buildCircleDiagramMetric(context, "Общая оценка разговора", 0.8),
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
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doubleToPercent(percent),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: favoriteBlueColor,
                  fontSize: 25),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 20),
            ),
            Container(
              width: 210,
              child: Text(""), // TODO
            )
          ],
        ),
      ),
    );
  }
}

class _PieData {
  _PieData(this.xData, this.yData, this.text);

  final String xData;
  final num yData;
  final String text;
}

String doubleToPercent(double val) {
  return (val * 100).toStringAsFixed(0).toString() + '%';
}
