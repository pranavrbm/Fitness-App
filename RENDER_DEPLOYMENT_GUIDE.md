# Deployment Guide for Render

## Prerequisites

1. Render account (render.com)
2. GitHub repository with code pushed
3. MongoDB Atlas account (free tier available)

## Step-by-Step Setup

### 1. Prepare MongoDB Atlas

- Go to MongoDB Atlas (https://www.mongodb.com/cloud/atlas)
- Create a free cluster
- Create a database user and get the connection string
- Copy the connection string (looks like: `mongodb+srv://user:password@cluster.mongodb.net/fitness_app?retryWrites=true&w=majority`)

### 2. Push Code to GitHub

```bash
git add .
git commit -m "Add Render deployment configuration"
git push origin main
```

### 3. Deploy to Render

- Sign in to Render (https://dashboard.render.com)
- Click "New +" → "Blueprint"
- Connect your GitHub repository
- Select the branch (main)
- Render will auto-detect render.yaml
- Add environment variables:
    - `MONGODB_URI`: Your MongoDB Atlas connection string
    - `SPRING_PROFILES_ACTIVE`: render
    - `PORT`: will be auto-assigned by Render

### 4. Service URLs After Deployment

Once deployed, you'll get URLs like:

- API Gateway: `https://api-gateway-xxxxx.onrender.com`
- Activity Service: `https://activity-service-xxxxx.onrender.com`
- User Service: `https://user-service-xxxxx.onrender.com`
- AI Service: `https://ai-service-xxxxx.onrender.com`
- Frontend: `https://fitness-frontend-xxxxx.onrender.com`

### 5. Update Frontend Config

The frontend needs to know the API Gateway URL. Set this environment variable:

- `VITE_API_URL`: `https://api-gateway-xxxxx.onrender.com`

## Architecture on Render

| Service          | Type       | Port | Purpose                      |
| ---------------- | ---------- | ---- | ---------------------------- |
| config-server    | Web        | 8888 | Centralized configuration    |
| eureka-server    | Web        | 8761 | Service discovery            |
| api-gateway      | Web        | 8080 | Entry point, routes requests |
| activity-service | Web        | 8080 | Activity management          |
| user-service     | Web        | 8080 | User management              |
| ai-service       | Web        | 8080 | AI features                  |
| fitness-frontend | Static     | 3000 | React + Vite app             |
| fitness-db       | PostgreSQL | -    | Database                     |

## Key Changes for Render

1. **Dockerfiles**: Each service has a multi-stage build (Maven compile → Java runtime)
2. **Profiles**: Added `application-render.yaml` for each service with:
    - MongoDB URI from environment
    - Service URLs from environment variables
    - Dynamic port binding
3. **render.yaml**: Defines all services, their dependencies, and environment variables
4. **No local Eureka/Config**: Services use environment variables for service-to-service communication

## Simplified Deployment (Costs)

If you want to reduce costs, you can deploy only:

- API Gateway (entry point)
- One or two microservices
- Frontend
- Skip Config Server and Eureka (use environment variables only)

## Monitoring & Logs

In Render Dashboard:

- Click on each service to see logs
- Check "Events" for deployment status
- Monitor "Metrics" for performance

## Troubleshooting

### Services can't connect to MongoDB

- Verify MongoDB Atlas connection string
- Check if IP whitelist includes Render's IP ranges
- Ensure database name matches

### Services can't reach each other

- Check `fromService` references in render.yaml
- Verify service names match exactly
- Check environment variable names

### Frontend can't reach API

- Verify `VITE_API_URL` environment variable is set correctly
- Check CORS configuration in API Gateway
- Test from browser DevTools console

## Next Steps

1. Commit all files to GitHub
2. Sign up for Render (free tier available)
3. Create a new Blueprint and connect your repository
4. Set MongoDB URI environment variable
5. Deploy!
