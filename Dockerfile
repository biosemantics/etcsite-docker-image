FROM ubuntu
MAINTAINER Thomas Rodenhausen <thomas.rodenhausen@gmail.com>
LABEL Description="This image is used to setup the Explorer of Taxon Concepts / the etcsite project"

ARG matrixGenerationVersion=0.1.56-SNAPSHOT
ARG micropieVersion=0.1.5-SNAPSHOT
ARG etcsiteVersion=0.0.1-SNAPSHOT

USER root

### Apt installations
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq mysql-server
RUN apt-get install -yq \
    vim \
    wget \
    graphviz \
    jetty9 \
    apache2 \
    git \
    openjdk-8-jdk \
    maven \
    python-pip \
    make \
    wordnet \
    libdbi-perl \
    libdbd-mysql-perl

### Get source of related projects
RUN git clone -b dongfang https://github.com/biosemantics/etc-site.git /root/git/etc-site
RUN git clone https://github.com/biosemantics/charaparser.git /root/git/charaparser
RUN git clone https://github.com/biosemantics/euler.git /root/git/euler
RUN git clone https://github.com/biosemantics/oto2.git /root/git/oto2
RUN git clone https://github.com/biosemantics/matrix-generation.git /root/git/matrix-generation
RUN git clone -b micropie-58-characters https://github.com/biosemantics/micropie2.git /root/git/micropie2
RUN git clone https://github.com/biosemantics/common.git /root/git/common
RUN git clone https://github.com/EulerProject/EulerX.git /root/git/eulerx
RUN git clone https://github.com/biosemantics/schemas.git /root/git/schemas

### Setup MySQL
COPY build_mysql_db.sh /opt/build_mysql_db.sh
RUN chmod +x /opt/build_mysql_db.sh
RUN /opt/build_mysql_db.sh

### Setup Apache2
RUN a2enmod proxy_http
COPY etcsiteJetty.conf /etc/apache2/sites-available/etcsiteJetty.conf
RUN a2ensite etcsiteJetty

### Setup etcsite directory
RUN mkdir -p /var/lib/etcsite/data/alignment
RUN mkdir -p /var/lib/etcsite/data/keyGeneration
RUN mkdir -p /var/lib/etcsite/data/matrixGeneration
RUN mkdir -p /var/lib/etcsite/data/matrixReview
RUN mkdir -p /var/lib/etcsite/data/matrixReview/matrix-review
RUN mkdir -p /var/lib/etcsite/data/ontologize
RUN mkdir -p /var/lib/etcsite/data/ontologize/collections
RUN mkdir -p /var/lib/etcsite/data/ontologize/context
RUN mkdir -p /var/lib/etcsite/data/profiles
RUN mkdir -p /var/lib/etcsite/data/public
RUN mkdir -p /var/lib/etcsite/data/taxonomyComparison
RUN mkdir -p /var/lib/etcsite/data/textCapture/charaparser
RUN mkdir -p /var/lib/etcsite/data/textCapture/glossaries
RUN mkdir -p /var/lib/etcsite/data/textCapture/oto2/context
RUN mkdir -p /var/lib/etcsite/data/users
RUN mkdir -p /var/lib/etcsite/data/visualization
RUN mkdir -p /var/lib/etcsite/help
RUN cp -R /root/git/etc-site/src/main/resources/edu/arizona/biosemantics/etcsitehelp/help/* /var/lib/etcsite/help
RUN mkdir -p /var/lib/etcsite/log
RUN mkdir -p /var/lib/etcsite/resources/keyGeneration
RUN mkdir -p /var/lib/etcsite/resources/matrixGeneration/classpath
RUN mvn -f /root/git/matrix-generation/pom.xml package dependency:copy-dependencies
RUN cp /root/git/matrix-generation/target/lib/* /var/lib/etcsite/resources/matrixGeneration/classpath
RUN cp /root/git/matrix-generation/target/matrix-generation-${matrixGenerationVersion}.jar /var/lib/etcsite/resources/matrixGeneration/classpath
RUN mkdir -p /var/lib/etcsite/resources/ontologize/known_relations
RUN cp /root/git/oto2/ontologize2/src/main/resources/edu/arizona/biosemantics/oto2/ontologize2/classes.json /var/lib/etcsite/resources/ontologize/known_relations
RUN cp /root/git/oto2/ontologize2/src/main/resources/edu/arizona/biosemantics/oto2/ontologize2/parts.json /var/lib/etcsite/resources/ontologize/known_relations
RUN cp /root/git/oto2/ontologize2/src/main/resources/edu/arizona/biosemantics/oto2/ontologize2/synonyms.json /var/lib/etcsite/resources/ontologize/known_relations
RUN mkdir -p /var/lib/etcsite/resources/ontologize/ontologies
RUN mkdir -p /var/lib/etcsite/resources/ontologize/ontologies/graphs
RUN wget --no-check-certificate -P /var/lib/etcsite/resources/ontologize/ontologies http://purl.obolibrary.org/obo/bspo.owl
RUN wget --no-check-certificate -P /var/lib/etcsite/resources/ontologize/ontologies http://purl.obolibrary.org/obo/caro.owl
RUN wget --no-check-certificate -P /var/lib/etcsite/resources/ontologize/ontologies http://purl.obolibrary.org/obo/chebi.owl
RUN wget --no-check-certificate -P /var/lib/etcsite/resources/ontologize/ontologies http://purl.obolibrary.org/obo/cl.owl
RUN wget --no-check-certificate -P /var/lib/etcsite/resources/ontologize/ontologies http://purl.obolibrary.org/obo/envo.owl
RUN wget --no-check-certificate -P /var/lib/etcsite/resources/ontologize/ontologies http://purl.obolibrary.org/obo/go.owl
RUN wget --no-check-certificate -P /var/lib/etcsite/resources/ontologize/ontologies http://purl.obolibrary.org/obo/hao.owl
RUN wget --no-check-certificate -P /var/lib/etcsite/resources/ontologize/ontologies http://purl.obolibrary.org/obo/pato.owl
RUN wget --no-check-certificate -P /var/lib/etcsite/resources/ontologize/ontologies http://purl.obolibrary.org/obo/po.owl
RUN wget --no-check-certificate -P /var/lib/etcsite/resources/ontologize/ontologies http://purl.obolibrary.org/obo/poro.owl
RUN wget --no-check-certificate -P /var/lib/etcsite/resources/ontologize/ontologies http://purl.obolibrary.org/obo/ro.owl
RUN wget --no-check-certificate -P /var/lib/etcsite/resources/ontologize/ontologies http://purl.obolibrary.org/obo/spd.owl
RUN wget --no-check-certificate -P /var/lib/etcsite/resources/ontologize/ontologies http://purl.obolibrary.org/obo/uberon.owl
RUN cp /root/git/oto2/ontologize2/src/main/resources/edu/arizona/biosemantics/oto2/ontologize2/ModifierOntology.owl /var/lib/etcsite/resources/ontologize/ontologies
RUN mvn -f /root/git/common/ontology/graph/pom.xml package dependency:copy-dependencies
RUN java -Xmx2g -cp /root/git/common/ontology/graph/target/classes:/root/git/common/ontology/graph/target/dependency/* edu.arizona.biosemantics.common.ontology.graph.Main /var/lib/etcsite/resources/ontologize/ontologies /var/lib/etcsite/resources/ontologize/ontologies/graphs
RUN mkdir -p /var/lib/etcsite/resources/shared/ontologies
RUN cp /var/lib/etcsite/resources/ontologize/ontologies/bspo.owl /var/lib/etcsite/resources/shared/ontologies
RUN cp /var/lib/etcsite/resources/ontologize/ontologies/hao.owl /var/lib/etcsite/resources/shared/ontologies
RUN cp /var/lib/etcsite/resources/ontologize/ontologies/pato.owl /var/lib/etcsite/resources/shared/ontologies
RUN cp /var/lib/etcsite/resources/ontologize/ontologies/po.owl /var/lib/etcsite/resources/shared/ontologies
RUN cp /var/lib/etcsite/resources/ontologize/ontologies/poro.owl /var/lib/etcsite/resources/shared/ontologies
RUN cp /var/lib/etcsite/resources/ontologize/ontologies/ro.owl /var/lib/etcsite/resources/shared/ontologies
RUN cp /var/lib/etcsite/resources/ontologize/ontologies/spd.owl /var/lib/etcsite/resources/shared/ontologies
RUN mkdir -p /var/lib/etcsite/resources/shared/wordnet/wn21
RUN cp -R /root/git/charaparser/wordnet/wn21/* /var/lib/etcsite/resources/shared/wordnet/wn21
RUN mkdir -p /var/lib/etcsite/resources/shared/wordnet/wn31
RUN cp -R /root/git/charaparser/wordnet/wn31/* /var/lib/etcsite/resources/shared/wordnet/wn31
RUN mkdir -p /var/lib/etcsite/resources/taxonomyComparison/euler/EulerX
RUN cp -R /root/git/eulerx/* /var/lib/etcsite/resources/taxonomyComparison/euler/EulerX
RUN mkdir -p /var/lib/etcsite/resources/textCapture/io
RUN cp /root/git/schemas/semanticMarkupInput.xsd /var/lib/etcsite/resources/textCapture/io
RUN cp /root/git/schemas/semanticMarkupOutput.xsd /var/lib/etcsite/resources/textCapture/io
RUN mkdir -p /var/lib/etcsite/resources/textCapture/micropie/classpath
RUN mvn -f /root/git/micropie2/pom.xml package dependency:copy-dependencies
RUN cp /root/git/micropie2/target/dependency/* /var/lib/etcsite/resources/textCapture/micropie/classpath
RUN cp /root/git/micropie2/target/micropie-${micropieVersion}.jar /var/lib/etcsite/resources/textCapture/micropie/classpath
RUN mkdir -p /var/lib/etcsite/resources/textCapture/micropie/models
RUN cp -R /root/git/micropie2/models/* /var/lib/etcsite/resources/textCapture/micropie/models
RUN mkdir -p /var/lib/etcsite/resources/textCapture/perl/edu/arizona/biosemantics/semanticmarkup/markupelement/description/ling/learn/lib/perl/
RUN cp -R /root/git/charaparser/src/main/perl/edu/arizona/biosemantics/semanticmarkup/markupelement/description/ling/learn/lib/perl/* /var/lib/etcsite/resources/textCapture/perl/edu/arizona/biosemantics/semanticmarkup/markupelement/description/ling/learn/lib/perl/
RUN mkdir -p /var/lib/etcsite/resources/visualization
RUN mkdir -p /var/lib/etcsite/temp/captcha
RUN mkdir -p /var/lib/etcsite/temp/compressedFiles

### Setup remaining charparser requirements
RUN wget http://cpansearch.perl.org/src/GRANTM/Encoding-FixLatin-1.04/lib/Encoding/FixLatin.pm -P /usr/lib/x86_64-linux-gnu/perl5/5.22/Encoding

### Setup euler requirements
RUN wget http://www.dlvsystem.com/files/dlv.x86-64-linux-elf-static.bin -P /opt/reasoners/dlv
RUN wget -O /opt/reasoners/gringo-4.5.4-linux-x86_64.tar.gz "https://downloads.sourceforge.net/project/potassco/gringo/4.5.4/gringo-4.5.4-linux-x86_64.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fpotassco%2Ffiles%2Fgringo%2F4.5.4%2F&ts=1484341313&use_mirror=master"
RUN wget -O /opt/reasoners/claspD-1.1.4-x86-linux.tar.gz "http://downloads.sourceforge.net/project/potassco/claspD/1.1.4/claspD-1.1.4-x86-linux.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fpotassco%2Ffiles%2FclaspD%2F1.1.4%2F&ts=1483579150&use_mirror=master"
RUN wget http://www.cs.unm.edu/%7Emccune/mace4/download/LADR-2009-11A.tar.gz -P /opt/reasoners
RUN tar zxvf /opt/reasoners/gringo-4.5.4-linux-x86_64.tar.gz -C /opt/reasoners
RUN rm -R /opt/reasoners/gringo-4.5.4-linux-x86_64.tar.gz
RUN tar zxvf /opt/reasoners/claspD-1.1.4-x86-linux.tar.gz -C /opt/reasoners/
RUN rm -R /opt/reasoners/claspD-1.1.4-x86-linux.tar.gz
#Does not compile and not really needed: http://satlug.satlug.narkive.com/j0vbWA1w/prover9-problem
#RUN tar zxvf /opt/reasoners/LADR-2009-11A.tar.gz -C /opt/reasoners
#RUN rm /opt/reasoners/LADR-2009-11A.tar.gz
#RUN make all -C /opt/reasoners/LADR-2009-11A
#RUN ln -s /opt/reasoners/LADR-2009-11A/bin/mace4 /usr/local/bin/mace4
#RUN ln -s /opt/reasoners/LADR-2009-11A/bin/prover9 /usr/local/bin/prover9
RUN ln -s /opt/reasoners/dlv/dlv.x86-64-linux-elf-static.bin /usr/local/bin/dlv
RUN ln -s /opt/reasoners/gringo-4.5.4-linux-x86_64/gringo /usr/local/bin/gringo
RUN ln -s /opt/reasoners/claspD-1.1.4/claspD-1.1.4 /usr/local/bin/claspD
RUN ln -s /opt/eulerx/src-el/euler2 /usr/local/bin/euler2
RUN ln -s /opt/eulerx/src-el/y2d /usr/local/bin/y2d
RUN ln -s /opt/eulerx/src-el/euler /usr/local/bin/euler
RUN chmod +x /opt/reasoners/dlv/dlv.x86-64-linux-elf-static.bin
RUN pip install --no-cache-dir pyyaml
RUN pip install --no-cache-dir docopt

### Setup etcsite webapp
RUN mvn -f /root/git/etc-site/pom.xml package
RUN mkdir /var/lib/jetty9/webapps/etcsite
RUN cp /root/git/etc-site/target/etc-site-${etcsiteVersion}.war /var/lib/jetty9/webapps/etcsite
RUN cd /var/lib/jetty9/webapps/etcsite/; jar -xfv /var/lib/jetty9/webapps/etcsite/etc-site-${etcsiteVersion}.war
RUN rm /var/lib/jetty9/webapps/etcsite/etc-site-${etcsiteVersion}.war
COPY configs /opt/configs
RUN rsync -a /opt/configs/* /var/lib/jetty9/webapps/etcsite/WEB-INF/classes

#Reduce image size
RUN rm -R /root/git
RUN rm -R /tmp/*
RUN rm -R /root/.m2
RUN apt-get remove -yq \
    git \
    vim \
    wget \
    maven \
    wget \
    python-pip \
    make \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 8080

COPY start.sh /opt/start.sh
RUN chmod +x /opt/start.sh
ENTRYPOINT ["/opt/start.sh"]
