ARG IMAGE=intersystemsdc/irishealth-ml-community
FROM $IMAGE as builder

WORKDIR /home/irisowner/irisdev
#RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp

## Embedded Python environment
ENV IRISUSERNAME "_SYSTEM"
ENV IRISPASSWORD "SYS"
ENV IRISNAMESPACE $NAMESPACE
ENV PYTHON_PATH=/usr/irissys/bin/
ENV PATH "/usr/irissys/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/irisowner/bin:/home/irisowner/dev/python"

# run iris and initial 
RUN --mount=type=bind,src=.,dst=. \
    iris start IRIS && \
	iris session IRIS < iris.script && \
    iris stop IRIS quietly

FROM $IMAGE as final

ADD --chown=${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} https://github.com/grongierisc/iris-docker-multi-stage-script/releases/latest/download/copy-data.py /irisdev/app/copy-data.py

RUN --mount=type=bind,source=/,target=/builder/root,from=builder \
    cp -f /builder/root/usr/irissys/iris.cpf /usr/irissys/iris.cpf && \
    python3 /irisdev/app/copy-data.py -c /usr/irissys/iris.cpf -d /builder/root/ 