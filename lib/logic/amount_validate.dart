String validateAmount(String amount) {
  if (double.tryParse(amount) == null) {
    return '红包金额不合法';
  }
  double amountValue = double.parse(amount);
  if (amountValue <= 0) {
    return '红包金额必须大于 0';
  }
  if (amountValue > 200) {
    return '单个红包金额不得超过 200 元';
  }
  return '';
}
