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
    MongoCollection<Document> collection = database.getCollection("shipping");

    // 샘플 데이터 (미국, 일본, 캐나다 항구 3곳씩)
    List<Document> ports = Arrays.asList(
        // 미국
        new Document("country", "USA").append("port", "Los Angeles").append("lat", 33.7406).append("lon", -118.2760),
        new Document("country", "USA").append("port", "New York").append("lat", 40.7128).append("lon", -74.0060),
        new Document("country", "USA").append("port", "Seattle").append("lat", 47.6062).append("lon", -122.3321),

        // 일본
        new Document("country", "Japan").append("port", "Tokyo").append("lat", 35.6762).append("lon", 139.6503),
        new Document("country", "Japan").append("port", "Yokohama").append("lat", 35.4437).append("lon", 139.6380),
        new Document("country", "Japan").append("port", "Osaka").append("lat", 34.6937).append("lon", 135.5023),

        // 캐나다
        new Document("country", "Canada").append("port", "Vancouver").append("lat", 49.2827).append("lon", -123.1207),
        new Document("country", "Canada").append("port", "Montreal").append("lat", 45.5019).append("lon", -73.5674),
        new Document("country", "Canada").append("port", "Halifax").append("lat", 44.6488).append("lon", -63.5752)
    );

    // 기존 데이터 삭제 후 삽입 (중복 방지용)
    collection.drop();
    collection.insertMany(ports);

    // 데이터 조회
    FindIterable<Document> cursor = collection.find();

    out.println("<h2>Shipping Ports Data</h2>");
    for (Document d : cursor) {
        out.println("<p>" + d.toJson() + "</p>");
    }

    mongoClient.close();
%>
