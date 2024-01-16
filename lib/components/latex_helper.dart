import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

DataTable table = DataTable(
  dataRowHeight: 100,
  columnSpacing: 16,
  columns: const [
    DataColumn(label: Text('Input')),
    DataColumn(label: Text('         Output')),
  ],
  rows: [
    buildDataRow("sqrt(x)", r"\[\sqrt{x}\]"),
    buildDataRow("->", r"\[\rightarrow\]"),
    buildDataRow("infinity", r"\[\infty\]"),
    buildDataRow("+-", r"\[\pm\]"),
    buildDataRow("!=", r"\[\ne\]"),
    buildDataRow("sin cos tan ...", r"\[\sin \cos \tan..\]"),
    buildDataRow("x^y", r"\[ x^y \]"),
    buildDataRow("x_n", r"\[ x_n \]"),
    buildDataRow("(num) / (den)", r"\[\frac{num}{den}\]"),
    buildDataRow("alpha beta gamma ...",
        r"\[ \alpha \beta \gamma \epsilon \rho \sigma \delta \]"),
    buildDataRow("integral(func, a, b)", r"\[\int_{a}^{b} func\]"),
    buildDataRow("sum(k, a, b)", r"\[\sum_{k= a}^{b}\]"),
  ],
);

DataRow buildDataRow(String input, String output) {
  return DataRow(cells: [
    DataCell(Container(
      width: 200,
      child: Text(
        input,
        style: const TextStyle(fontSize: 17),
        overflow: TextOverflow.ellipsis,
      ),
    )),
    DataCell(Container(
      width: 100,
      child: TeXView(
        child: TeXViewDocument(output,
            style: const TeXViewStyle(textAlign: TeXViewTextAlign.left)),
      ),
    )),
  ]);
}
