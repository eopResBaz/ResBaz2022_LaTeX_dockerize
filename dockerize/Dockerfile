FROM debian:buster

RUN apt -y update
#RUN python3 -m pip install --upgrade pip
RUN apt -y install vim 
RUN apt -y install make
RUN apt -y install texlive-full
RUN apt -y install biber
RUN apt -y install bibutils
RUN apt -y install python-pygments
RUN apt -y install cysignals-tools
RUN apt -y install sagemath
RUN apt -y install python-sagetex
RUN apt -y install sagetex
RUN apt -y install bsdmainutils
RUN apt -y install rsync

COPY notebook2022-tools /tools
RUN dpkg -i /tools/*deb

WORKDIR /results
ENTRYPOINT ["/usr/bin/make"]

# then do something locally like

# source commands.sh
# create pdf

###############################################################################

# commands.sh contains the following function:
# create() { docker run --rm -v $(pwd):/results notebook2022:latest "$@"; }

