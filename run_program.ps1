Write-Host "Selecciona una opción:"
Write-Host "1. Crear entorno virtual con una versión específica de Python"
Write-Host "2. Activar entorno virtual"
Write-Host "3. Instalar dependencias desde requirements.txt"
Write-Host "4. Visualizar dependencias de requirements.txt"
Write-Host "5. Ejecutar programa"
Write-Host "6. Desactivar entorno virtual"
Write-Host "7. Salir"

$opcion = Read-Host "Ingresa el número de la opción"

switch ($opcion) {
    1 {
        # Crear entorno virtual con una versión específica de Python
        $python_version = Read-Host "Ingresa la versión de Python (por ejemplo, 3.8)"
        python -m venv environment
        Write-Host "Entorno virtual creado con Python $python_version en ./environment."
    }
    2 {
        # Activar entorno virtual
        .\environment\Scripts\Activate
        Write-Host "Entorno virtual activado."
    }
    3 {
        # Instalar dependencias desde requirements.txt
        if (Test-Path variable:VIRTUAL_ENV) {
            pip install -r requirements.txt
            Write-Host "Dependencias instaladas."
        } else {
            Write-Host "Error: Debes estar en un entorno virtual para instalar dependencias."
        }
    }
    4 {
        # Visualizar dependencias de requirements.txt
        if (Test-Path variable:VIRTUAL_ENV) {
            Get-Content requirements.txt
        } else {
            Write-Host "Error: Debes estar en un entorno virtual para visualizar dependencias."
        }
    }
    5 {
        # Ejecutar programa
        python .\source\app.py
    }
    6 {
        # Desactivar entorno virtual
        Deactivate
        Write-Host "Entorno virtual desactivado."
    }
    7 {
        # Salir
        Write-Host "Saliendo del script."
        exit 0
    }
    default {
        # Opción no válida
        Write-Host "Opción no válida. Por favor, elige 1, 2, 3, 4, 5, 6 o 7."
    }
}