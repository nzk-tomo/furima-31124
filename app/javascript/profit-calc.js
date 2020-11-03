addEventListener('load', () => {
  let price = document.getElementById("item-price"),
      tax = document.getElementById("add-tax-price"),
      profit = document.getElementById("profit")
  price.addEventListener("input",() => {
    let e = document.getElementById("item-price").value;
    tax.innerHTML = Math.floor(e * 0.1).toLocaleString()
    profit.innerHTML = Math.floor(e * 0.9).toLocaleString()
  })
})