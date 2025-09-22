<%@ page import="com.mongodb.client.MongoClient" %>
<%@ page import="com.mongodb.client.MongoClients" %>
<%@ page import="com.mongodb.client.MongoDatabase" %>
<%@ page import="com.mongodb.client.MongoCollection" %>
<%@ page import="com.mongodb.client.FindIterable" %>
<%@ page import="org.bson.Document" %>
<%@ page import="java.util.*" %>

<%
    // MongoDB 연결
    MongoClient mongoClient = MongoClients.create("mongodb://localhost:27017");
    MongoDatabase database = mongoClient.getDatabase("testdb");

    // ---------------------------
    // 1. 항구 데이터
    // ---------------------------
    MongoCollection<Document> portCollection = database.getCollection("shipping");

    List<Document> ports = Arrays.asList(
        // Japan
        new Document("country", "Japan").append("port", "Tokyo").append("lat", 35.6762).append("lon", 139.6503),
        new Document("country", "Japan").append("port", "Yokohama").append("lat", 35.4437).append("lon", 139.6380),
        new Document("country", "Japan").append("port", "Osaka").append("lat", 34.6937).append("lon", 135.5023),

        // USA (West Coast)
        new Document("country", "USA").append("port", "Los Angeles").append("lat", 33.7406).append("lon", -118.2760),
        new Document("country", "USA").append("port", "San Francisco").append("lat", 37.7749).append("lon", -122.4194),
        new Document("country", "USA").append("port", "Seattle").append("lat", 47.6062).append("lon", -122.3321),

        // Canada (West Coast)
        new Document("country", "Canada").append("port", "Vancouver").append("lat", 49.2827).append("lon", -123.1207),
        new Document("country", "Canada").append("port", "Victoria").append("lat", 48.4284).append("lon", -123.3656),
        new Document("country", "Canada").append("port", "Prince Rupert").append("lat", 54.3150).append("lon", -130.3200)
    );

    portCollection.drop();
    portCollection.insertMany(ports);

    // ---------------------------
    // 2. 컨테이너 선 데이터 (항해 중)
    // ---------------------------
    MongoCollection<Document> shipCollection = database.getCollection("ships");

    List<Document> ships = Arrays.asList(
        new Document("name", "Evergreen-1").append("status", "en route").append("lat", 30.0).append("lon", -150.0),
        new Document("name", "Hanjin-Express").append("status", "en route").append("lat", 35.0).append("lon", -170.0),
        new Document("name", "ONE-Pacific").append("status", "en route").append("lat", 40.0).append("lon", 160.0), // 동경 160°
        new Document("name", "Maersk-West").append("status", "en route").append("lat", 25.0).append("lon", -140.0),
        new Document("name", "Hyundai-Ocean").append("status", "en route").append("lat", 20.0).append("lon", -160.0)
    );

    shipCollection.drop();
    shipCollection.insertMany(ships);

    // ---------------------------
    // 3. 조회 출력 (확인용)
    // ---------------------------
    out.println("<h2>Shipping Ports Data</h2>");
    for (Document d : portCollection.find()) {
        out.println("<p>" + d.toJson() + "</p>");
    }

    out.println("<h2>Container Ships Data</h2>");
    for (Document d : shipCollection.find()) {
        out.println("<p>" + d.toJson() + "</p>");
    }

    mongoClient.close();
%>
