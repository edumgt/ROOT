<%@ page import="com.mongodb.client.*" %>
<%@ page import="org.bson.Document" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <!-- 5초마다 새로고침 -->
  <meta http-equiv="refresh" content="5">
  <title>World Shipping Ports & Ships</title>

  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
  <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
  <style>
    #map { height: 600px; width: 100%; }
  </style>
</head>
<body>
<h2>World Shipping Ports & Container Ships</h2>

<div id="map"></div>

<script>
  // JSP → JavaScript로 항구/선박 데이터 전달
  var ports = [
    <%
      MongoClient mongoClient = MongoClients.create("mongodb://localhost:27017");
      MongoDatabase database = mongoClient.getDatabase("testdb");

      // 항구 데이터
      MongoCollection<Document> portCollection = database.getCollection("shipping");
      for (Document d : portCollection.find()) {
        String country = d.getString("country");
        String port = d.getString("port");
        Double lat = d.getDouble("lat");
        Double lon = d.getDouble("lon");
    %>
      { country: "<%=country%>", port: "<%=port%>", lat: <%=lat%>, lon: <%=lon%> },
    <% } %>
  ];

  var ships = [
    <%
      // 선박 데이터
      MongoCollection<Document> shipCollection = database.getCollection("ships");
      for (Document d : shipCollection.find()) {
        String name = d.getString("name");
        String status = d.getString("status");
        Double lat = d.getDouble("lat");
        Double lon = d.getDouble("lon");
    %>
      { name: "<%=name%>", status: "<%=status%>", lat: <%=lat%>, lon: <%=lon%> },
    <% } 
      mongoClient.close();
    %>
  ];
</script>

<script>
  // Leaflet 지도 초기화 - 태평양 중심
  var map = L.map('map').setView([25, -160], 3);

  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '© OpenStreetMap contributors'
  }).addTo(map);

  // 기본 아이콘 복사
  var portIcon = new L.Icon.Default();
  var shipIcon = new L.Icon({
    iconUrl: 'https://cdn-icons-png.flaticon.com/512/77/77521.png', // 간단한 배 아이콘
    iconSize: [25, 25],
    iconAnchor: [12, 12],
    popupAnchor: [0, -10]
  });

  // 항구 마커 (기본 아이콘)
  ports.forEach(function(p) {
    L.marker([p.lat, p.lon], {icon: portIcon})
      .addTo(map)
      .bindPopup("<b>Port:</b> " + p.port + "<br><b>Country:</b> " + p.country);
  });

  // 선박 마커 (배 아이콘)
  ships.forEach(function(s) {
    L.marker([s.lat, s.lon], {icon: shipIcon})
      .addTo(map)
      .bindPopup("<b>Ship:</b> " + s.name + "<br>Status: " + s.status);
  });
</script>

</body>
</html>
