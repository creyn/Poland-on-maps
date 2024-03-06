https://rocker-project.org/

># The Rocker Project
>Docker Containers for the R Environment
>## 🚀Getting Started
>Ensure you have [Docker installed](https://docs.docker.com/get-started/) and start R inside a container with:
```
docker run --rm -ti r-base
```
>Or get started with an RStudio® instance:
```
docker run --rm -ti -e PASSWORD=yourpassword -p 8787:8787 rocker/rstudio
```
>and point your browser to `localhost:8787`. Log in with user/password `rstudio`/`yourpassword`.
>For more information and further options, see [the image descriptions](https://rocker-project.org/images).

