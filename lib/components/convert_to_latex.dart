String convertToLatex(String input) {
  // square root with single characters
  input = input.replaceAllMapped(RegExp(r'sqrt\s*\((.*?)\)'), (match) {
    return "\\sqrt{${match[1]}}";
  });

  // arrow for chemistry
  input = input.replaceAll('->', '\\rightarrow');

  // using infinity
  input = input.replaceAll('infinity', '\\infty');

  // plus or minus operator
  input = input.replaceAll('+-', '\\pm');

  // not equal to
  input = input.replaceAll('!=', '\\ne');

  // trigonometric functions
  input = input.replaceAll("sin", "\\sin");
  input = input.replaceAll("cos", "\\cos");
  input = input.replaceAll("tan", "\\tan");
  input = input.replaceAll("sec", "\\sec");
  input = input.replaceAll("cosec", "\\cosec");
  input = input.replaceAll("cot", "\\cot");

  // superscript
  input = input.replaceAllMapped(
      RegExp(r'([a-zA-Z0-9]+)\^(?![{^_])'), (match) => '${match[1]}^');

  // subscripts
  input = input.replaceAllMapped(
      RegExp(r'([a-zA-Z0-9]+)\_()'), (match) => '${match[1]}_');

  //handling fractions of different patterns
  input = input.replaceAllMapped(
      RegExp(
          r'\((.*?)\)\s*\/\s*\((.*?)\)|([a-zA-Z0-9]+)\s*\/\s*([a-zA-Z0-9]+)|(\d+)\s*\/\s*(\d+)|\((.*?)\)\s*\/\s*([a-zA-Z0-9]+)|([a-zA-Z0-9]+)\s*\/\s*\((.*?)\)'),
      (match) {
    String? nr = match[1] ?? match[3] ?? match[5] ?? match[7] ?? match[9];
    String? dr = match[2] ?? match[4] ?? match[6] ?? match[8] ?? match[10];
    return '\\frac{$nr} {$dr}';
  });
  // greek albabets
  input = input.replaceAll("alpha", "\\alpha");
  input = input.replaceAll("beta", "\\beta");
  input = input.replaceAll("gamma", "\\gamma");
  input = input.replaceAll("rho", "\\rho");
  input = input.replaceAll("sigma", "\\sigma");
  input = input.replaceAll("delta", "\\delta");
  input = input.replaceAll("epsilon", "\\epsilon");

  // integration : format => integral(required function , lower limit , upper limit)
  input = input.replaceAllMapped(
      RegExp(r'integral\(([^,]+)?,\s*([^,]+)?,\s*(.+)?\)'), (match) {
    String integrand = match[1] ?? '';
    String lowerLimit = match[2] ?? '';
    String upperLimit = match[3] ?? '';

    if (lowerLimit.isNotEmpty && upperLimit.isNotEmpty) {
      return '\\int_{$lowerLimit}^{$upperLimit} $integrand';
    } else {
      return '\\int $integrand';
    }
  });

  // Summation : format => sum(variable , lower limit , upper limit)
  input = input.replaceAllMapped(
      RegExp(r'sum\(([^,]+)?,\s*([^,]+)?,\s*(.+)?\)'), (match) {
    String variable = match[1] ?? '';
    String lowerLimit = match[2] ?? '';
    String upperLimit = match[3] ?? '';

    if (variable.isNotEmpty && lowerLimit.isNotEmpty && upperLimit.isNotEmpty) {
      return '\\sum_{$variable = $lowerLimit}^{$upperLimit}';
    } else {
      return "\\sum";
    }
  });

  // preserving spacing exactly as is inputted
  input = input.replaceAll(' ', '~');

  // wrapping in \[...\]
  input = r"\[ " + input + r" \]";
  return input;
}
