/* Rodrigo Barba - Shinia */

/**
 * @fileoverview Documento de JavaScript para receipt.html
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

/* Generación de recibo de compra */

document.addEventListener("DOMContentLoaded", function () {
  // Recupera los datos del carrito desde el almacenamiento local y además obtiene los elementos del DOM que se van a actualizar.
  const dataCart = localStorage.getItem("data-cart");
  const listGroup = document.querySelector(".list-group");
  const footerLeft = document.getElementById("footer-left");
  const footerRight = document.getElementById("footer-right");

  // Si existen los datos del carrito y el elemento del DOM, entonces se recorren los productos y se agregan al listado.
  if (dataCart && listGroup) {
    const cart = JSON.parse(dataCart);

    // Recorre los productos del carrito y los agrega al listado
    cart.forEach((item) => {
      const listItem = document.createElement("a");
      listItem.setAttribute("href", "#");
      listItem.classList.add("list-group-item", "list-group-item-action");

      const itemContent = `
          <div class="d-flex w-100 justify-content-between">
            <h5 class="mb-1">${item.product.name}</h5>
            <small>Precio: $${item.product.price}</small>
          </div>
          <p class="mb-1">Cantidad: ${item.quantity}</p>
          <small>Precio total: $${item.product.price * item.quantity}</small>
        `;

      listItem.innerHTML = itemContent;
      listGroup.appendChild(listItem);
    });

    // Calcula el total de productos y el total a pagar.
    let total = 0;
    cart.forEach((item) => {
      total += item.product.price * item.quantity;
    });

    // Obtiene la fecha actual y la formatea.
    const date = new Date();
    const todayDate = `${date.getDate()}/${
      date.getMonth() + 1
    }/${date.getFullYear()}`;

    // Muestra la fecha y el total en el footer del recibo.
    footerLeft.innerHTML = `<p>Fecha: ${todayDate}</p>`;
    footerRight.innerHTML = `<p><i class="fa-solid fa-money-bill" style="padding-right: 10px"></i>Total: $${total.toFixed(
      2
    )}</p>`;
  }
});

/* Generación de recibo de compra */