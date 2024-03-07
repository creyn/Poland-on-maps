FROM rocker/geospatial:4.3.2
LABEL authors="creyn"

# package 'sf' should be preinstalled in 'rocker/geospatial'
RUN R -e "install.packages('giscoR', repos='http://cran.us.r-project.org')"
RUN R -e "install.packages('here', repos='http://cran.us.r-project.org')"
