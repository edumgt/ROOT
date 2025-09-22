<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <!-- 5초마다 새로고침 -->
  
  <title>World Shipping Ports & Ships</title>

  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
  <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
  <style>
    #map {
      height: 600px;
      width: 100%;
    }
  </style>
</head>

<body>
  <h2>World Shipping Ports & Container Ships</h2>
  <div id="map"></div>

  <script>
    // Leaflet 지도 초기화 - 태평양 중심
    var map = L.map('map').setView([25, -160], 4);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '© OpenStreetMap contributors'
    }).addTo(map);

    // 기본 아이콘
    var portIcon = new L.Icon.Default();
    var shipIcon = new L.Icon({
      iconUrl: 'https://cdn-icons-png.flaticon.com/512/77/77521.png',
      iconSize: [25, 25],
      iconAnchor: [12, 12],
      popupAnchor: [0, -10]
    });

    // ✅ Node API에서 데이터 가져오기
    async function loadData() {
      try {
        // 항구 데이터 가져오기
        const portsRes = await fetch("http://localhost:3000/api/ports");
        const ports = await portsRes.json();

        ports.forEach(function (p) {
          L.marker([p.lat, p.lon], { icon: portIcon })
            .addTo(map)
            .bindPopup("<b>Port:</b> " + p.port + "<br><b>Country:</b> " + p.country);
        });

        // 선박 데이터 가져오기
        const shipsRes = await fetch("http://localhost:3000/api/ships");
        const ships = await shipsRes.json();

        ships.forEach(function (s) {
          L.marker([s.lat, s.lon], { icon: shipIcon })
            .addTo(map)
            .bindTooltip(s.name, { permanent: true, direction: "top" });
        });

      } catch (err) {
        console.error("❌ 데이터 불러오기 실패:", err);
      }
    }

    // 실행
    loadData();
  </script>
</body>
</html>
