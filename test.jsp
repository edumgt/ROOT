<%@ page import="com.mongodb.client.*, org.bson.Document" %>
<%@ page import="java.util.*" %>

<%
    // 1. MongoDB 클라이언트 생성
    MongoClient mongoClient = MongoClients.create("mongodb://localhost:27017");

    // 2. DB와 Collection 선택
    MongoDatabase database = mongoClient.getDatabase("testdb");
    MongoCollection<Document> collection = database.getCollection("users");

    // 3. 샘플 데이터 삽입 (없을 경우)
    Document doc = new Document("name", "tester")
                        .append("age", 30)
                        .append("email", "hong001@test.com");
    collection.insertOne(doc);

    // 4. 데이터 조회
    FindIterable<Document> cursor = collection.find();

    out.println("<h2>MongoDB users collection</h2>");
    for (Document d : cursor) {
        out.println("<p>" + d.toJson() + "</p>");
    }

    // 5. 연결 종료
    mongoClient.close();
%>
