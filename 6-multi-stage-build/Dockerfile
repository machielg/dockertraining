ARG WAR=target/api-0.0.2-SNAPSHOT.war
# Using "as" to name the stage so it can be referenced by name later on.
FROM amd64/maven:3.6.3-jdk-11-slim AS buildstage
WORKDIR /project
COPY ./code /project
RUN mvn clean install

FROM tomcat:9-jre11
# An argument without a value but with the same name as earlier declared will make it available in this stage
ARG WAR
# copy the artifact from the stage named "buildstage"
COPY --from=buildstage /project/${WAR} /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
