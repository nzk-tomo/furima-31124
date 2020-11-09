addEventListener("turbolinks:load", () => {
  let price = document.getElementById("item-price"),
      tax = document.getElementById("add-tax-price"),
      profit = document.getElementById("profit")
  if(price){
    price.addEventListener("input",() => {
      e = price.value.replace( /[０-９]/g,function(s){
        return String.fromCharCode(s.charCodeAt(0) - 0xFEE0)
      })
      tax.innerHTML = Math.floor(e * 0.1).toLocaleString()
      profit.innerHTML = Math.floor(e * 0.9).toLocaleString()
      })
  }
})