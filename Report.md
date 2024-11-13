# Docker CI/CD Pipeline

## Stage 1: Local Testing

### Files Created:
1. **Dockerfile**

    I use `dotnet/sdk` image for  **Build Stage** 
    and `dotnet/aspnet` image for **Run Stage**

2. **docker-compose.yml**


## Testing containerized application locally

- **Building image**  
  ![Image 1](./images/BuildImageLocal.png)

- **Run built image**  
  ![Image 2](./images/RunBuildLocal.png)

- **Docker Desktop**  
  ![Image 3](./images/DockDeskApprove.png)

- **Browsing localhost:5001/swagger**  
  ![Image 4](./images/DepCheckLocal.png)


- **docker-compose Check**
   ![Image 4](./images/DockCompBuild.png)


- **Browsing localhost:5001/swagger (docker-compose)**  

   ![Image 5](./images/DepCheckLocalCompose.png)

## Stage 2: Deploying

## Azure CI/CD Pipeline

**Pipeline file**:  `azure-pipelines.yml`. 

The pipeline is divided into two stages:

1. **Build_Push**
2. **Deploy**

Results after executing the code

## Result of ci/cd pipline.

- **Successfull run.**
   ![Image 5](./images/Pipeline.png)

- **Deployed Infrastructure**
   ![Image 6](./images/TFInfra.png)

- **Deployed application in App service**
  ![Image 7](./images/DeployedPage.png)
  