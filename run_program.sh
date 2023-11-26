#!/bin/bash

echo "Selecciona una opción:"
echo "1. Crear entorno virtual con una versión específica de Python"
echo "2. Activar entorno virtual"
echo "3. Instalar dependencias desde requirements.txt"
echo "4. Visualizar dependencias de requirements.txt"
echo "5. Ejecutar programa"
echo "6. Desactivar entorno virtual"
echo "7. Salir"

read opcion

case $opcion in
    1)
        # Crear entorno virtual con una versión específica de Python
        read -p "Ingresa la versión de Python (por ejemplo, 3.8): " python_version
        python$python_version -m venv environment
        echo "Entorno virtual creado con Python $python_version en ./environment."
        ;;
    2)
        # Activar entorno virtual
        source ./environment/bin/activate || . ./environment/bin/activate
        echo "Entorno virtual activado."
        ;;
    3)
        # Instalar dependencias desde requirements.txt
        if [ -n "$VIRTUAL_ENV" ]; then
            pip install -r requirements.txt
            echo "Dependencias instaladas."
        else
            echo "Error: Debes estar en un entorno virtual para instalar dependencias."
        fi
        ;;
    4)
        # Visualizar dependencias de requirements.txt
        if [ -n "$VIRTUAL_ENV" ]; then
            cat requirements.txt
        else
            echo "Error: Debes estar en un entorno virtual para visualizar dependencias."
        fi
        ;;
    5)
        # Ejecutar programa
        python3 ./source/app.py
        ;;
    6)
        # Desactivar entorno virtual
        deactivate
        echo "Entorno virtual desactivado."
        ;;
    7)
        # Salir
        echo "Saliendo del script."
        exit 0
        ;;
    *)
        # Opción no válida
        echo "Opción no válida. Por favor, elige 1, 2, 3, 4, 5, 6 o 7."
        ;;
esac