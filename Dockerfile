FROM maven:3.8.4-openjdk-11 AS build
WORKDIR /usr/src/project
COPY . .
RUN mvn -B -DskipTests clean package
 
FROM adoptopenjdk/openjdk11:jre-11.0.9.1_1-alpine
RUN apk add dumb-init
WORKDIR /app
RUN addgroup --system javauser && adduser -S -s /bin/false -G javauser javauser
COPY --from=build /usr/src/project/target/my-app-1.0-SNAPSHOT.jar java-application.jar
RUN chown -R javauser:javauser /app
USER javauser
ENTRYPOINT [ "executable" ] "dumb-init" "java" "-jar" "java-application.jar"