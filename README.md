# Proyecto de Aplicación Flask: Flora Vibrante 🌷

Este proyecto consiste en una aplicación de gestión de ventas y compras para una florería llamada 'Flora Vibrante'. La aplicación está desarrollada utilizando el framework Flask de Python y establece una comunicación con una base de datos para almacenar y recuperar información relevante.

---

### Funcionalidades Relevantes 🌱

La aplicación incluye las siguientes funcionalidades:

**Gestión de Ventas y Compras:** Permite realizar el registro y seguimiento de las transacciones de ventas y compras de la florería.

**Gestión de Usuarios:** Permite realizar el registro, edición y eliminación de usuarios dentro de la aplicación.

**Gestión de Productos:** Permite realizar el registro, edición y eliminación de products dentro de la aplicación.

**Gestión de Recibos:** Permite visualizar los recibos de compra por parte de los usuarios.

**Base de Datos:** Se han modelado entidades y tablas en la base de datos para almacenar información sobre clientes, productos, ventas y compras.

**Comunicación con el Servidor:** El servidor de la aplicación se encarga de manejar las solicitudes y respuestas entre la base de datos y las vistas de la aplicación. Garantiza la obtención y envío de información relevante de manera eficiente.

---

### Estructura del Proyecto 🌱

La estructura del proyecto sigue un diseño organizado en varios directorios:

- **`database/`:** Contiene scripts y archivos relacionados con la configuración y gestión de la base de datos MySQL.

- **`environment/ (No Incluido)`:** Incluye archivos relacionados con la configuración del entorno de desarrollo, como variables de entorno.

- **`source/`:** Es el directorio principal que contiene el código fuente de la aplicación Flask.

  - **`static/`:** Contiene archivos estáticos como hojas de estilo (CSS) e imágenes.

  - **`templates/`:** Almacena las plantillas HTML utilizadas por las vistas.

     - **`auth/`:** Aquí se encuentran los archivos de las vistas de autentificación.
       
     - **`public/`:** Aquí se encuentran los archivos de las vistas generales.

  - **`models/`:** Contiene los modelos de la aplicación.

    - **`entities/`:** Aquí se encuentran los archivos que modelan las entidades y tablas de la base de datos.

---

### Requisitos del Sistema 🌱

Asegúrese de tener instalados los siguientes requisitos antes de ejecutar la aplicación:

1. **Python 3.x:** Si no tiene instalado Python, puede descargarlo desde el sitio oficial [python.org](https://www.python.org/downloads/).

2. **MySQL:** Para instalar MySQL, siga las instrucciones específicas para su sistema operativo desde el [sitio oficial de MySQL](https://dev.mysql.com/downloads/).

---
