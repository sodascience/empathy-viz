FROM rocker/shiny-verse:4.3.0
LABEL Name=empathyapp Version=0.0.1
RUN sudo rm -rf /srv/shiny-server/*
COPY ./ /srv/shiny-server/
RUN sudo mv /srv/shiny-server/survey-app.R /srv/shiny-server/app.R
RUN sudo chown -R shiny:shiny /srv/shiny-server/
RUN install2.r --error --skipinstalled --ncpus -1 \
    shinyjs \
    shinyRadioMatrix \
    shinyWidgets \
    writexl \
    readxl \
    hash \
    reshape \
    bslib \
    gridExtra \
    && rm -rf /tmp/downloaded_packages \
    && strip /usr/local/lib/R/site-library/*/libs/*.so
CMD ["usr/bin/shiny-server"]


