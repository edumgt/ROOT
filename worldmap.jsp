<%@ page import="com.mongodb.client.*" %>
<%@ page import="org.bson.Document" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>World Shipping Ports</title>
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
  <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
  <style>
    #map { height: 600px; width: 100%; }
  </style>
</head>
<body>
<h2>World Shipping Ports</h2>

<div id="map"></div>

<script>
  // JSP → JavaScript로 데이터 전달
  var ports = [
    <% 
      MongoClient mongoClient = MongoClients.create("mongodb://localhost:27017");
      MongoDatabase database = mongoClient.getDatabase("testdb");
      MongoCollection<Document> collection = database.getCollection("shipping");

      for (Document d : collection.find()) {
        String country = d.getString("country");
        String port = d.getString("port");
        Double lat = d.getDouble("lat");
        Double lon = d.getDouble("lon");
    %>
      { country: "<%=country%>", port: "<%=port%>", lat: <%=lat%>, lon: <%=lon%> },
    <% 
      }
      mongoClient.close();
    %>
  ];
</script>

<script>
  // Leaflet 지도 초기화
  var map = L.map('map').setView([20, 0], 2); // 세계 지도 중심

  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '© OpenStreetMap contributors'
  }).addTo(map);

  // 포트 마커 추가
  ports.forEach(function(p) {
    L.marker([p.lat, p.lon]).addTo(map)
      .bindPopup("<b>" + p.port + "</b><br>" + p.country);
  });
</script>

</body>
</html>
