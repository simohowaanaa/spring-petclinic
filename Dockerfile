FROM eclipse-temurin:17-jdk AS build

WORKDIR /workspace

COPY .mvn/ .mvn/
COPY mvnw pom.xml ./

RUN chmod +x mvnw && ./mvnw -B dependency:go-offline

COPY src/ src/

RUN ./mvnw -B package -DskipTests

FROM eclipse-temurin:17-jre

WORKDIR /app

RUN useradd --system --no-create-home --uid 10001 appuser

COPY --from=build /workspace/target/*.jar /app/app.jar

USER 10001

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]