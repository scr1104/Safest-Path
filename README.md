# safestpath - Currently in development
This flutter app finds the user the statistically safest path for walking in the Toronto Area.
 - utilizing crime data from government sources such as the Toronto Police Service
 - Custom apis written in Flask backend
## TODO - Flutter Frontend
 - [x] implement basic map with self location
 - [x] implement button to center map at self location 
 - [x] implement target location by searching 
 - [x] implement target location by aiming
 - [ ] implement 'start nav'
 - [ ] implement crime data sourcing and storage (Flask backend)
 - [ ] implement data wrangling  
 - [ ] implement custom path with local crime heatmap generation
   - [ ] custom path
   - [ ] heatmap
     - [x] detect onscreenmove
     - [ ] generate heatmap circles dynamically 
 - [ ] implement path directing in background
 - [ ] Stylings
   - [ ] custom google maps style from https://mapstyle.withgoogle.com/
   - [ ] _mapOverlay styling
 - [ ] deploy on google playstore + appstore

## TODO - Flask backend
 - [ ] store data in sqlite db
 - [ ] implement retrieval apis
 - [ ] restrict usage

## Known Issues
 - [x] google maps custom styling not applied
 - [ ] custom styling has wierd font
 - [ ] perhaps replace all `GoogleMapController mapController` usages with `Completer<GoogleMapController> _asyncMapController`

## Potential Future Features
 - [ ] extend the app beyond Toronto
 - [ ] find safest bus/bike routes
 - [ ] dark theme
## Credits
| Role          | Individual  |
| ------------- | -----:      |
| Programmer    | [Jefferson Li](https://www.linkedin.com/in/jeffersonlii/)|
| Data Scientist| [Chaerin Song](https://www.linkedin.com/in/chaerin-song-377323123/)|
| UI UX Designer| [Chaerin Song](https://www.linkedin.com/in/chaerin-song-377323123/)|
