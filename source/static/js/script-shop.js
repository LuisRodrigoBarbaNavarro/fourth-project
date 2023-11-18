/* Rodrigo Barba - Shinia */

/**
 * @fileoverview Documento de JavaScript para shop.html
 */

/* Verificación de inicio de sesión */

var authenticatedUser = localStorage.getItem("authenticatedUser");

if (!authenticatedUser) {
  // El usuario no ha iniciado sesión, redirige a la página de error
  window.location.href = "../html/error.html";
} else {
  if (authenticatedUser === "rodrigobarba") {
    var element = document.getElementsByClassName("admin-link");
    for (var i = 0; i < element.length; i++) {
      element[i].style.display = "none";
    }
  }
}

// Establecer un temporizador de 10 segundos para cerrar la sesión
setTimeout(function () {
  // Limpiar la sesión local y redirigir a la página de inicio de sesión
  localStorage.removeItem("authenticatedUser");
  window.location.href = "../html/index.html";
}, 999999999); // 10000 milisegundos = 10 segundos

// Cerrar sesión cuando se presiona el botón de cerrar sesión
function logout() {
  localStorage.removeItem("authenticatedUser");
  window.location.href = "../html/index.html";
}

/* Verificación de inicio de sesión */

/* Funciones de la calculadora */

const display = document.getElementById("display");
let currentInput = "0";

function appendToDisplay(value) {
  if (currentInput === "0") {
    currentInput = value;
  } else {
    currentInput += value;
  }
  display.textContent = currentInput;
}

function calculateResult() {
  try {
    currentInput = eval(currentInput);
    display.textContent = currentInput;
  } catch (error) {
    currentInput = "Error";
    display.textContent = "Error";
  }
}

function clearDisplay() {
  currentInput = "0";
  display.textContent = currentInput;
}

const blurToggle = document.getElementById("blurToggle");
const content = document.querySelector(".content-blur");

blurToggle.addEventListener("click", () => {
  content.classList.toggle("blur");
});

document.addEventListener("click", function (e) {
  const calculator = document.getElementById("collapseCalculator");
  const calculatorButton = document.querySelector(".btn-calculator");

  if (
    calculator &&
    !calculator.contains(e.target) &&
    e.target !== calculatorButton
  ) {
    calculator.classList.remove("show");
    content.classList.remove("blur");
  }
});

/* Funciones de la calculadora */

/* Funciones de la tienda */

// Arreglo de productos en el cart
const cart = [];

document.addEventListener("DOMContentLoaded", function () {
  const productList = JSON.parse(localStorage.getItem("products"));

  // Obtiene el contenedor donde se mostrará el catálogo y el resumen de compra.
  const productListContainer = document.getElementById("productList");

  if (productList && productList.length > 0) {
    // Genera las tarjetas de productos en el catálogo y las agrega al contenedor.
    productList.forEach((product) => {
      const card = document.createElement("div");
      card.classList.add("col-md-6", "mb-4");
      card.innerHTML = `
            <div class="card card-custom">
                <img src="${product.imageUrl}" class="card-img-top card-img-custom" alt="Producto ${product.id}">
                <div class="card-body text-center" style="background-color: #80C2AF; color: white;">
                    <h5 class="card-title">Producto ${product.id}</h5>
                    <h5 class="card-title">${product.name}</h5>
                    <p class="card-text">Descripción: ${product.description}</p>
                    <p class="card-text">Precio: $${product.price}</p>
                    <div class="input-group">
                        <span class="input-group-btn">
                            <button type="button" class="btn btn-danger btn-number" data-type="minus" data-field="inputQuantity${product.id}"><i class="fa-solid fa-minus"></i></button>
                        </span>
                        <input type="text" id="inputQuantity${product.id}" class="form-control input-number" value="1" min="1" max="10">
                        <span class="input-group-btn">
                            <button type="button" class="btn btn-success btn-number" data-type="plus" data-field="inputQuantity${product.id}"><i class="fa-solid fa-plus"></i></button>
                        </span>
                    </div>
                    <button class="btn btn-success add-to-cart" data-product-id="${product.id}" style="margin-top: 20px">Agregar al cart</button>
                </div>
            </div>
        `;
      productListContainer.appendChild(card);

      // Obtiene la cantidad de productos a agregar al cart y manda llamar la función para agregar el producto al cart.
      const btnAdd = card.querySelector(".add-to-cart");
      btnAdd.addEventListener("click", function () {
        const quantity = parseInt(
          document.getElementById(`inputQuantity${product.id}`).value
        );

        if (quantity > 0) {
          addProduct(product, quantity);
        }
      });
    });
  } else {
    productListContainer.innerHTML = `
            <div class="col-md-12 text-center">
                <img src="../img/flower-error-2.svg" alt="Empty cart" width=60>
                <h3 class="mt-3" style="color: #80C2AF;">No hay productos disponibles.</h3> 
            </div>
        `;
  }

  // Almacena en el arreglo los productos agregados al cart y actualiza la cantidad de productos en el carrito en caso de que se agregue más de uno del mismo producto.
  function addProduct(product, quantity) {
    const cartProduct = cart.find((item) => item.product.id === product.id);

    if (cartProduct) {
      cartProduct.quantity += quantity;
    } else {
      cart.push({ product, quantity });
    }

    updateCheckoutCart();
  }

  // Eventos para incrementar y decrementar la cantidad de productos en el cart.
  const btnNumberButtons = document.querySelectorAll(".btn-number");
  btnNumberButtons.forEach(function (button) {
    button.addEventListener("click", function (e) {
      e.preventDefault();

      const fieldName = this.getAttribute("data-field");
      const type = this.getAttribute("data-type");
      const input = document.getElementById(fieldName);
      const currentVal = parseInt(input.value);

      if (!isNaN(currentVal)) {
        if (type === "minus") {
          if (currentVal > input.min) {
            input.value = currentVal - 1;
          }
        } else if (type === "plus") {
          if (currentVal < input.max) {
            input.value = currentVal + 1;
          }
        }
      }
    });
  });

  // Elimina un producto del carrito cuando se presiona el botón de eliminar.
  const checkoutCart = document.getElementById("checkoutCart");
  checkoutCart.addEventListener("click", function (e) {
    if (e.target.classList.contains("btnDelete")) {
      const id =
        e.target.parentElement.parentElement.firstElementChild.textContent;
      const index = cart.findIndex((item) => item.product.id === id);

      cart.splice(index, 1);
      updateCheckoutCart();
    }
  });

  // Actualiza el resumen de compra en el carrito cuando se agrega un producto o se cambia la cantidad de productos.
  function updateCheckoutCart() {
    checkoutCart.innerHTML = "";
    let subtotal = 0;

    cart.forEach((item) => {
      const row = document.createElement("tr");
      row.innerHTML = `
                <td>Producto ${item.product.id}</td>
                <td>${item.product.name}</td>
                <td>${item.quantity}</td>
                <td>$${item.product.price}</td>
                <td>$${item.product.price * item.quantity}</td>
                <td><button type="button" class="btn btn-danger btn-sm btnDelete">Eliminar</button></td>
            `;
      checkoutCart.appendChild(row);

      subtotal += item.product.price * item.quantity;
    });

    totalCheckout.textContent = `$${subtotal.toFixed(2)}`;
  }
});

// Botón para comprar productos y mandarlos al recibo.
const btnBuy = document.querySelector(".btn-comprar");
btnBuy.addEventListener("click", function () {
  if (cart.length > 0) {
    localStorage.removeItem("data-cart");

    const cartProducts = JSON.stringify(cart);
    localStorage.setItem("data-cart", cartProducts);

    window.location.href = "receipt.html";
  } else {
    alert("El cart está vacío.");
  }
});

/* Funciones de la tienda */
