String mapStyle = ''' 
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "saturation": 25
      }
    ]
  },
  {
    "elementType": "geometry.fill",
    "stylers": [
      {
        "saturation": 5
      },
      {
        "lightness": -5
      }
    ]
  },
  {
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#c0c0c0"
      },
      {
        "saturation": 10
      },
      {
        "lightness": -10
      },
      {
        "weight": 0.5
      }
    ]
  },
  {
    "elementType": "labels.text",
    "stylers": [
      {
        "color": "#797979"
      },
      {
        "saturation": -5
      },
      {
        "lightness": -30
      },
      {
        "visibility": "simplified"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#929000"
      }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#797979"
      }
    ]
  },
  {
    "featureType": "administrative.neighborhood",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9d5700"
      }
    ]
  },
  {
    "featureType": "administrative.province",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#919191"
      },
      {
        "weight": 1.5
      }
    ]
  },
  {
    "featureType": "poi.attraction",
    "elementType": "labels.text",
    "stylers": [
      {
        "color": "#797979"
      }
    ]
  },
  {
    "featureType": "poi.business",
    "elementType": "labels.text",
    "stylers": [
      {
        "color": "#797979"
      }
    ]
  },
  {
    "featureType": "poi.government",
    "elementType": "labels.text",
    "stylers": [
      {
        "color": "#797979"
      }
    ]
  },
  {
    "featureType": "poi.medical",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#f9b6bb"
      }
    ]
  },
  {
    "featureType": "poi.medical",
    "elementType": "labels.text",
    "stylers": [
      {
        "color": "#797979"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#a0dc92"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text",
    "stylers": [
      {
        "color": "#797979"
      }
    ]
  },
  {
    "featureType": "poi.place_of_worship",
    "elementType": "labels.text",
    "stylers": [
      {
        "color": "#797979"
      }
    ]
  },
  {
    "featureType": "poi.school",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#c6cbff"
      }
    ]
  },
  {
    "featureType": "poi.school",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#797979"
      }
    ]
  },
  {
    "featureType": "poi.sports_complex",
    "elementType": "labels.text",
    "stylers": [
      {
        "color": "#797979"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text",
    "stylers": [
      {
        "color": "#919191"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#ffe44f"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#dcbb00"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#a9a9a9"
      }
    ]
  },
  {
    "featureType": "transit.station.bus",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#000000"
      }
    ]
  },
  {
    "featureType": "transit.station.rail",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#000000"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#6ccafc"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#5133d3"
      }
    ]
  }
]

''';

String API_KEY = "AIzaSyB108SjYU07nAyB7X_vuvUnZk6c9mP6FBA";