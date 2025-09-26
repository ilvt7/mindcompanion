#!/bin/bash

# Script para crear PR de release v1.0.0
# Este script facilita el push de la rama y la creación del PR

echo "🚀 Preparando PR de Release v1.0.0..."

# Verificar que estamos en la rama correcta
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "release/v1.0.0" ]; then
    echo "❌ Error: No estás en la rama release/v1.0.0"
    echo "💡 Ejecuta: git checkout release/v1.0.0"
    exit 1
fi

echo "✅ Rama correcta: release/v1.0.0"

# Verificar que hay un commit
if ! git log --oneline -1 | grep -q "Release v1.0.0"; then
    echo "❌ Error: No se encontró el commit de release v1.0.0"
    echo "💡 Ejecuta: git commit -m \"Release v1.0.0...\""
    exit 1
fi

echo "✅ Commit de release encontrado"

# Verificar si hay un remote configurado
if ! git remote -v | grep -q "origin"; then
    echo "⚠️  No hay remote 'origin' configurado"
    echo "💡 Configura el remote con: git remote add origin <URL_DEL_REPOSITORIO>"
    echo "💡 Ejemplo: git remote add origin https://github.com/tu-usuario/mindcompanion.git"
    exit 1
fi

echo "✅ Remote 'origin' configurado"

# Push de la rama
echo "📤 Haciendo push de la rama release/v1.0.0..."
git push -u origin release/v1.0.0

if [ $? -ne 0 ]; then
    echo "❌ Error en el push"
    exit 1
fi

echo "✅ Push exitoso"

echo ""
echo "🎉 ¡Rama pushada exitosamente!"
echo ""
echo "📋 Próximos pasos:"
echo "1. Ve a GitHub/GitLab a tu repositorio"
echo "2. Crea un Pull Request desde release/v1.0.0 hacia main"
echo "3. Copia el contenido de PR_TEMPLATE.md como descripción del PR"
echo "4. El pipeline CI/CD se ejecutará automáticamente"
echo "5. Si golden tests fallan, aplica el label 'update-goldens'"
echo "6. Cuando el pipeline esté verde, haz merge a main"
echo "7. ¡El release automático se creará!"
echo ""
echo "📄 Template del PR disponible en: PR_TEMPLATE.md"
echo ""
