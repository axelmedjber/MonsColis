#!/usr/bin/env pwsh

# Check prerequisites
function Check-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

Write-Host "🔍 Checking prerequisites..." -ForegroundColor Blue

$missing = @()
if (-not (Check-Command "node")) { $missing += "Node.js" }
if (-not (Check-Command "flutter")) { $missing += "Flutter" }
if (-not (Check-Command "docker")) { $missing += "Docker" }
if (-not (Check-Command "git")) { $missing += "Git" }

if ($missing.Count -gt 0) {
    Write-Host "❌ Missing required tools: $($missing -join ', ')" -ForegroundColor Red
    Write-Host "Please install them and try again." -ForegroundColor Yellow
    exit 1
}

# Setup backend
Write-Host "🔧 Setting up backend..." -ForegroundColor Blue
Set-Location backend
Copy-Item .env.example .env
npm install

# Start Docker services
Write-Host "🐳 Starting Docker services..." -ForegroundColor Blue
docker-compose up -d

# Run database migrations
Write-Host "📦 Running database migrations..." -ForegroundColor Blue
npm run migrate

# Setup mobile app
Write-Host "📱 Setting up mobile app..." -ForegroundColor Blue
Set-Location ../mobile
flutter pub get

# Verify setup
Write-Host "✅ Verifying setup..." -ForegroundColor Blue
Set-Location ../backend
$backendHealth = npm run test
Set-Location ../mobile
$mobileHealth = flutter test

if ($backendHealth -and $mobileHealth) {
    Write-Host "✨ Setup completed successfully!" -ForegroundColor Green
    Write-Host @"
    
Next steps:
1. Configure environment variables in backend/.env
2. Add Firebase configuration in mobile/android/app/google-services.json
3. Start the backend: cd backend && npm run dev
4. Start the mobile app: cd mobile && flutter run

For more information, check the README.md
"@ -ForegroundColor Yellow
} else {
    Write-Host "⚠️ Setup completed with warnings. Please check the logs above." -ForegroundColor Yellow
}
