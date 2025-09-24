@echo off
REM Script para crear PR de release v1.0.0
REM Este script facilita el push de la rama y la creación del PR

echo 🚀 Preparando PR de Release v1.0.0...

REM Verificar que estamos en la rama correcta
git branch --show-current | findstr "release/v1.0.0" >nul
if errorlevel 1 (
    echo ❌ Error: No estás en la rama release/v1.0.0
    echo 💡 Ejecuta: git checkout release/v1.0.0
    pause
    exit /b 1
)

echo ✅ Rama correcta: release/v1.0.0

REM Verificar que hay un commit
git log --oneline -1 | findstr "Release v1.0.0" >nul
if errorlevel 1 (
    echo ❌ Error: No se encontró el commit de release v1.0.0
    echo 💡 Ejecuta: git commit -m "Release v1.0.0..."
    pause
    exit /b 1
)

echo ✅ Commit de release encontrado

REM Verificar si hay un remote configurado
git remote -v | findstr "origin" >nul
if errorlevel 1 (
    echo ⚠️  No hay remote 'origin' configurado
    echo 💡 Configura el remote con: git remote add origin <URL_DEL_REPOSITORIO>
    echo 💡 Ejemplo: git remote add origin https://github.com/tu-usuario/mindcompanion.git
    pause
    exit /b 1
)

echo ✅ Remote 'origin' configurado

REM Push de la rama
echo 📤 Haciendo push de la rama release/v1.0.0...
git push -u origin release/v1.0.0

if errorlevel 1 (
    echo ❌ Error en el push
    pause
    exit /b 1
)

echo ✅ Push exitoso

echo.
echo 🎉 ¡Rama pushada exitosamente!
echo.
echo 📋 Próximos pasos:
echo 1. Ve a GitHub/GitLab a tu repositorio
echo 2. Crea un Pull Request desde release/v1.0.0 hacia main
echo 3. Copia el contenido de PR_TEMPLATE.md como descripción del PR
echo 4. El pipeline CI/CD se ejecutará automáticamente
echo 5. Si golden tests fallan, aplica el label 'update-goldens'
echo 6. Cuando el pipeline esté verde, haz merge a main
echo 7. ¡El release automático se creará!
echo.
echo 📄 Template del PR disponible en: PR_TEMPLATE.md
echo.

pause
