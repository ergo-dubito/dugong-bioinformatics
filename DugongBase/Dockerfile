###########################################################################
# Dugong - Scientific Linux Containers for Bioinformatics
# ========================================================
#
# Current development is led by Fabiano Menegidio.
#
# Bioinformatician/Bioinformaticist at the Laboratory of Functional 
# and Structural Genomics of the Integrated Nucleus of Biotechnology 
# at the University of Mogi das Cruzes, Brazil.
# 
# Contact: fabiano.menegidio@biology.bio.br
# GitHub: https://github.com/fabianomenegidio
#
#
###########################################################################

FROM ubuntu:latest
MAINTAINER Fabiano Menegidio <fabiano.menegidio@biology.bio.br>

############### Metadata
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="e.g. https://github.com/fabianomenegidio/dugong-bioinformatics/tree/master/DugongGUI/XFCE"

LABEL base.image="ubuntu:latest" \
      version="2017040" \
      name="DugongSmall" \
      description="Scientific Linux Container" \
      website="https://fabianomenegidio.github.io/dugong-bioinformatics/" \
      repository="https://github.com/fabianomenegidio/dugong-bioinformatics" \
      license="MIT" \
      tags="Bioinformatics"

ENV HOME /headless
ENV STARTUPDIR /dockerstartup
WORKDIR $HOME

############### Environment config
ENV DEBIAN_FRONTEND noninteractive
ENV NO_VNC_HOME $HOME/noVNC

############### Add dependencies and update packages
RUN apt-key adv --recv-key --keyserver keyserver.ubuntu.com "A6616109451BBBF2" \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 \
    && echo "deb http://packages.linuxmint.com sarah main upstream import backport" >> /etc/apt/sources.list.d/mint.list \
    && echo 'deb http://nebc.nerc.ac.uk/bio-linux/ unstable bio-linux' >> /etc/apt/sources.list.d/biolinux.list \
    && echo 'deb http://ppa.launchpad.net/nebc/bio-linux/ubuntu precise main' >> /etc/apt/sources.list.d/biolinux.list \
    && echo 'deb-src http://ppa.launchpad.net/nebc/bio-linux/ubuntu precise main' >> /etc/apt/sources.list.d/biolinux.list \
    && echo 'deb http://cran.r-project.org/bin/linux/ubuntu precise/' >> /etc/apt/sources.list.d/biolinux.list \
    && apt-get update \
    && apt-get install -y --allow-unauthenticated --force-yes bio-linux-keyring \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

############### Add all install scripts for further steps
ENV INST_SCRIPTS $HOME/install
ADD .config/install/ $INST_SCRIPTS/
RUN find $INST_SCRIPTS -name '*.sh' -exec chmod a+x {} +

############### Installation of essential packages and dependencies
RUN $INST_SCRIPTS/essentials.sh \
    && $INST_SCRIPTS/bioinformatics.sh \
    && $INST_SCRIPTS/tools.sh \
    && locale-gen en_US.UTF-8


############### http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8
ENV LANG C.UTF-8

############### Configure startup Dugong
ADD .config/scripts $STARTUPDIR
ADD .config/scripts/.bashrc $HOME/.bashrc
RUN chmod +X /dockerstartup/*.sh && chmod 755 /dockerstartup/*.sh \
    && /dockerstartup/generate_container_user.sh \
    && /bin/bash /headless/install/set_user_permission.sh /dockerstartup /headless

VOLUME ["/data", "/config"]
RUN chown -R dugong:dugong /data && \
    chown -R dugong:dugong /config

ENTRYPOINT ["tini", "--"]
CMD ["--tail-log"]
EXPOSE 22

WORKDIR /data
USER dugong
