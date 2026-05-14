Write-Host "Iniciando despliegue completo..." -ForegroundColor Cyan

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


#Inicia la Deploy

Write-Host "Crear Namespace " -ForegroundColor Yellow
Write-Host "kubectl apply -f .\k8s\namespace.yml " -ForegroundColor Green
kubectl apply -f .\k8s\namespace.yml
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error aplicando Namespace." -ForegroundColor Red
    exit 1
}

Write-Host "Crear la Base de Datos" -ForegroundColor Yellow
Write-Host "kubectl apply -f .\k8s\database-deployment.yml" -ForegroundColor Green
kubectl apply -f .\k8s\database-deployment.yml
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error aplicando Base de Datos." -ForegroundColor Red
    exit 
}

Write-Host "Esperando pods de la base de datos " -ForegroundColor Green


$namespace = "proyecto-test-multicine"
$serviceName = "postgres-sql15-service-mae"       
$checkInterval = 5            

Write-Host "Esperando a que el servicio '$serviceName' tenga al menos un endpoint disponible..."

while ($true) {
    # Obtener los endpoints del servicio
    $endpoints = kubectl get endpoints $serviceName -n $namespace -o jsonpath="{.subsets[*].addresses[*].ip}" 2>$null

    if ($endpoints -and $endpoints -ne "") {
        Write-Host "El servicio '$serviceName' ya tiene endpoints disponibles: $endpoints"  -ForegroundColor Green
        break
    } else {
        Write-Host "Aun no hay endpoints disponibles, esperando $checkInterval segundos..." -ForegroundColor Yellow
        Start-Sleep -Seconds $checkInterval
    }
}


Write-Host "Crea la imagen del backend" -ForegroundColor Yellow
Write-Host "docker build -t proyecto-test-multicine/backend-img-mae:latest .\BackEnd" -ForegroundColor Green
docker build -t proyecto-test-multicine/backend-img-mae:latest .\BackEnd
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error al construir el backend." -ForegroundColor Red
    exit 1
}

Write-Host "Inicia el deploy y creacion de servicio  BackEnd" -ForegroundColor Yellow
Write-Host "kubectl apply -f .\k8s\backend-deployment.yml" -ForegroundColor Green
kubectl apply -f .\k8s\backend-deployment.yml
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error aplicando BackEnd." -ForegroundColor Red
    exit 1
}


$namespace = "proyecto-test-multicine"
$serviceName = "backend-mae-service"       
$checkInterval = 5            

Write-Host "Esperando a que el servicio '$serviceName' tenga al menos un endpoint disponible..."

while ($true) {
    # Obtener los endpoints del servicio
    $endpoints = kubectl get endpoints $serviceName -n $namespace -o jsonpath="{.subsets[*].addresses[*].ip}" 2>$null

    if ($endpoints -and $endpoints -ne "") {
        Write-Host "El servicio '$serviceName' ya tiene endpoints disponibles: $endpoints"  -ForegroundColor Green
        break
    } else {
        Write-Host "Aun no hay endpoints disponibles, esperando $checkInterval segundos..." -ForegroundColor Yellow
        Start-Sleep -Seconds $checkInterval
    }
}