import { STORE_PARAMETERS } from './constants';

export function parametersStore(result, insureagainst, date, amount, crop, premium) {
  return (dispatch) => {
    dispatch({
      type: STORE_PARAMETERS,
      payload: {
        result, insureagainst, date, amount, crop, premium
      }
    });
  };
}
