FROM jolielang/jolie:latest


RUN apk update
RUN apk add git
RUN apk add bash

RUN git clone https://github.com/DM848/DM848-project.git

WORKDIR DM848-project/src/embedding_jolie

RUN ls

RUN java -version


CMD ["jolie", "cloud_server.ol"]
