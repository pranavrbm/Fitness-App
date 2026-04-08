#!/bin/bash

# Quick verification script to validate Render deployment setup

echo "✓ Checking Render deployment files..."

files=(
  "render.yaml"
  "eureka/Dockerfile"
  "configserver/Dockerfile"
  "gateway/Dockerfile"
  "activityservice/Dockerfile"
  "userservice/Dockerfile"
  "aiservice/Dockerfile"
  "fitness-app-frontend/Dockerfile"
  "configserver/src/main/resources/application-render.yaml"
  "eureka/src/main/resources/application-render.yaml"
  "gateway/src/main/resources/application-render.yaml"
  "activityservice/src/main/resources/application-render.yaml"
  "userservice/src/main/resources/application-render.yaml"
  "aiservice/src/main/resources/application-render.yaml"
)

missing=0
for file in "${files[@]}"; do
  if [ -f "$file" ]; then
    echo "  ✓ $file"
  else
    echo "  ✗ MISSING: $file"
    ((missing++))
  fi
done

echo ""
if [ $missing -eq 0 ]; then
  echo "✓ All deployment files present!"
  echo ""
  echo "Next steps:"
  echo "1. Push to GitHub: git push origin main"
  echo "2. Go to https://dashboard.render.com"
  echo "3. Click 'New +' → 'Blueprint'"
  echo "4. Connect your GitHub repo"
  echo "5. Render will auto-detect render.yaml"
  echo "6. Add MongoDB Atlas connection string as MONGODB_URI"
  echo "7. Click Deploy!"
else
  echo "✗ Missing $missing file(s)!"
  exit 1
fi
