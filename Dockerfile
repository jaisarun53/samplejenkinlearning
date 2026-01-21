FROM tomcat:jre25-temurin-noble
ADD **/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
