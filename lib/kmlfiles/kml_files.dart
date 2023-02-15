class KML {

  String descp = '''
  <?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>
	<name>iitbhu.kml</name>
	<StyleMap id="msn_ylw-pushpin">
		<Pair>
			<key>normal</key>
			<styleUrl>#sn_ylw-pushpin</styleUrl>
		</Pair>
		<Pair>
			<key>highlight</key>
			<styleUrl>#sh_ylw-pushpin</styleUrl>
		</Pair>
	</StyleMap>
	<Style id="sh_ylw-pushpin">
		<IconStyle>
			<scale>1.3</scale>
			<Icon>
				<href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
			</Icon>
			<hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
		</IconStyle>
		<LineStyle>
			<color>ffff0000</color>
		</LineStyle>
		<PolyStyle>
			<color>8000aa00</color>
		</PolyStyle>
	</Style>
	<Style id="sn_ylw-pushpin">
		<IconStyle>
			<scale>1.1</scale>
			<Icon>
				<href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
			</Icon>
			<hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
		</IconStyle>
		<LineStyle>
			<color>ffff0000</color>
		</LineStyle>
		<PolyStyle>
			<color>8000aa00</color>
		</PolyStyle>
	</Style>
	<Placemark>
		<name>IIT (BHU) - Varanasi</name>
		<LookAt>
			<longitude>82.99366038693375</longitude>
			<latitude>25.2655362538145</latitude>
			<altitude>0</altitude>
			<heading>2.412259465760821</heading>
			<tilt>8.603376224459003</tilt>
			<range>4687.179091316924</range>
			<gx:altitudeMode>relativeToSeaFloor</gx:altitudeMode>
		</LookAt>
		<styleUrl>#msn_ylw-pushpin</styleUrl>
		<Polygon>
			<tessellate>1</tessellate>
			<outerBoundaryIs>
				<LinearRing>
					<coordinates>
						83.00123279485558,25.2781681151048,0 82.99835683702007,25.27879146128146,0 82.99462418544991,25.27879002525849,0 82.99204706309092,25.27808682309367,0 82.98854333444943,25.27799826115599,0 82.98469953042211,25.27488344226763,0 82.98393388721479,25.27153602417494,0 82.98238583198209,25.26717633600999,0 82.98167273069899,25.26168054910791,0 82.98098700637111,25.25330259139632,0 82.9812403307092,25.25315558928095,0 82.98451944105223,25.25319139530716,0 82.9862648558309,25.25322896573163,0 82.98872047393019,25.25278957410483,0 82.98971491665179,25.25300930565336,0 82.99444479774232,25.25249638954573,0 82.99532923556409,25.25389041499657,0 82.99596906099094,25.25537140753499,0 82.99675373595818,25.25783967006648,0 82.99625593859369,25.25859415487767,0 82.99931173859366,25.27053259706091,0 83.0007725590275,25.27546635017814,0 83.00193143086885,25.27766901671769,0 83.00123279485558,25.2781681151048,0 
					</coordinates>
				</LinearRing>
			</outerBoundaryIs>
		</Polygon>
	</Placemark>
</Document>
</kml>


  ''';

  iitbhu() {
    return '''
<?xml version="1.0" encoding="UTF-8"?>
  <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
    <Document>
            <name>Network Links</name>
          <visibility>0</visibility>
          <open>0</open>
          <description>Network link example 2</description>
          <NetworkLink>
            <name>View Centered Placemark</name>
            <visibility>0</visibility>
            <open>0</open>
            <description>The view-based refresh allows the remote server to calculate
                the center of your screen and return a placemark.</description>
            <refreshVisibility>0</refreshVisibility>
            <flyToView>0</flyToView>
            <Link>
              <href>http://lg1/cgi-bin/viewCenteredPlacemark.py</href>
              <refreshInterval>2</refreshInterval>
              <viewRefreshMode>onStop</viewRefreshMode>
              <viewRefreshTime>1</viewRefreshTime>
            </Link>
          </NetworkLink>
      <name>iitbhu</name>
        $descp
    </Document>
  </kml>
''';
  }
}
