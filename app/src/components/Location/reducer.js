import {STORE_LOCATION} from './constants';

const initialState = {
  latitude:53.3766032,
  longitude:-6.270619399999999
};

export default function reducer(state = initialState, action) {
  switch (action.type) {
    case STORE_LOCATION:
      return {
        ...state,
        latitude: action.payload.latitude,
        longitude: action.payload.longitude
      };
    default:
      return state;
  }
}
