FROM tomcat:jre25-temurin-noble
ADD **/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8082
CMD ["catalina.sh", "run"]


