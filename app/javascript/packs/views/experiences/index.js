import { Maps } from '../../lib/maps';

let URLParamsParser = window.URLSearchParams;

// Polyfill for old browsers.
if (!URLParamsParser) {
  URLParamsParser = function (locationSearch) {
    this.get = (key) => this.queryParams[key];
    this.queryParams = locationSearch
      .slice(1)
      .split('&')
      .map(param => param.split('='))
      .reduce((acc, value) => {
        return acc.concat(value);
      }, [])
      .reduce((acc, currValue, currIdx, ary) => {
        if (currIdx % 2 == 0) {
          acc[currValue] = ary[currIdx + 1];
        }
        return acc;
      }, {});
  }
}

$(function () {
  function getSearchParams() {
    const { search: search } = location;
    return new URLParamsParser(search);
  }

  if (getSearchParams().get('view') == 'map') {
    $("#list").hide();
    $.get('/experiences' + window.location.search, {}, (points) => {
      const lat = getSearchParams().get('lat');
      const long = getSearchParams().get('long');
      let zoom = getSearchParams().get('zoom') || 13;
      if (long == '-98.5556199') {
        zoom = 4;
      }

      Maps.loadMapWithPoints(lat, long, zoom, points);
      $("#mapContainer").fadeIn(500);
    }, 'json');
  } else {
    $("#mapContainer").hide();
  }
});
