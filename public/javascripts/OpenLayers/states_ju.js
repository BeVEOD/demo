$(window).load(function() {
function loadFeatures(data) {
    var features = new OpenLayers.Format.GeoJSON().read(data);
    Control.states.addFeatures(features);
};

loadFeatures(
	hash_regions =
	{
		"type": "FeatureCollection",
		"features":
			<% Region.all().each{ |m_region| %>
			[{
				"type": "Feature",
				"id": "<%= m_region.sid %>",
				"geometry": {
					"type": "MultiPolygon",
					"coordinates": [
						[
							[
								<% m_region.bounds { |m_bounds| %>
								["<%= m_bounds.lng %>", "<%= m_bounds.lat %>"],
								<% } %>

							]
						]
					]}
				"properties": {
					"STATE_NAME": "<%= m_region.name %>",
					"STATE_CA": "<%= m_region.ca %>",
					"STATE_OBJECTIVE_LEVEL": "<%= m_region.objective_level %>",
				}
			}],
			<% } %>
	}
)