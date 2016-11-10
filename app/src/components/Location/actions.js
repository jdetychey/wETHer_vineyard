import { STORE_LOCATION } from './constants';

export function locationStore(lat, long) {
  return (dispatch) => {
    dispatch({
      type: STORE_LOCATION,
      payload: {
        latitude: lat,
        longitude: long
      }
    });
  };
}
