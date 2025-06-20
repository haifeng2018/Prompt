class AmountUtil {
  getRoundUp(value?: number, digit?: number) {
    return value ? value.toFixed(digit) : '0'
  }

  getRoundUpNoZero(value?: number, digit?: number): string {
    if (!value) {
      return '0'
    }
    //四舍五入并去除多余的0
    let result: number = parseFloat(value.toFixed(digit))
    //添加千分位符号
    return result.toLocaleString()
  }
}

export default new AmountUtil()