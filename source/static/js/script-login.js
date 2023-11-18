/*
Rodrigo Barba - Shinia
*/

/**
 * @fileoverview Archivo JS para la página de inicio de sesión
 */

function authenticate() {
    var username = document.getElementById("usernameInput").value;
    var password = document.getElementById("passwordInput").value;

    // Define usuarios y contraseñas válidos
    var validUsers = {
        "rodrigobarba": "123",
        "administrador": "12345"
    };

    if (validUsers[username] && validUsers[username] === password) {
        // Autenticación exitosa, almacena la sesión local
        localStorage.setItem("authenticatedUser", username);
        // Autenticación exitosa, redirige a la página deseada
        window.location.href = "../html/dashboard.html";
    } else {
        // Autenticación fallida, muestra un mensaje de error
        alert("Credenciales incorrectas. Por favor, inténtalo de nuevo.");
    }
}