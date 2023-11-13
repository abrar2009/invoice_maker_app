String numberToWords(int number) {
  var units = ['Zero', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine'];
  var teens = ['Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'];
  var tens = ['Ten', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'];
  var thousands = [''] + [' Thousand', 'Lakh', 'Crore'];

  String convertLessThanOneThousand(int num) {
    if (num == 0) {
      return '';
    } else if (num < 10) {
      return units[num];
    } else if (num < 20) {
      return teens[num - 11];
    } else if (num < 100) {
      return tens[(num / 10).floor() - 1] + ' ' + convertLessThanOneThousand(num % 10);
    } else {
      return units[(num / 100).floor()] + ' Hundred ' + convertLessThanOneThousand(num % 100);
    }
  }

  String toWords(int num) {
    if (num == 0) {
      return 'Zero Rupees';
    }

    var result = '';
    var count = 0;
    while (num > 0) {
      if (num % 1000 != 0) {
        var part = convertLessThanOneThousand(num % 1000);
        result = part + thousands[count] + ' ' + result;
      }
      num ~/= 1000;
      count++;
    }

    return result.trim() + ' Rupees Only';
  }

  return toWords(number);
}
