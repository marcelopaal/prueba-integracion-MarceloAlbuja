Write-Host "Iniciando eliminación del ambiente" -ForegroundColor Cyan

docker info > $null 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error con Docker" -ForegroundColor Red
    exit 1
}

kubectl cluster-info > $null 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error con Kubernetes" -ForegroundColor Red
    exit 1
}

docker info > $null 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker no está corriendo." -ForegroundColor Red
    exit 1
}

Write-Host "Eliminando recursos de Kubernetes..." -ForegroundColor Cyan
kubectl delete -f .\k8s\ --ignore-not-found

if ($LASTEXITCODE -eq 0) {
    Write-Host "Recursos Kubernetes eliminados." -ForegroundColor Green
} else {
    Write-Host "Algunos recursos no pudieron eliminarse." -ForegroundColor Yellow
}

#Esperar a que los pods terminen
Start-Sleep -Seconds 5

Write-Host "Eliminando imágenes Docker..." -ForegroundColor Yellow

$images = @("proyecto-test-multicine/backend-img-mae:latest","postgres:16-alpine")

foreach ($image in $images) {
    docker image inspect $image > $null 2>&1
    if ($LASTEXITCODE -eq 0) {
        docker rmi -f $image
        Write-Host "Imagen eliminada: $image" -ForegroundColor Green
    } else {
        Write-Host "Imagen no encontrada: $image" -ForegroundColor Gray
    }
}

Write-Host "Limpieza completada correctamente." -ForegroundColor Green