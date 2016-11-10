import {STORE_PARAMETERS} from './constants';

const initialState = {
  result: null,
  insureagainst: null,
  date: null,
  amount: null,
  crop: null,
};

export default function reducer(state = initialState, action) {
  switch (action.type) {
    case STORE_PARAMETERS:
      return {
        ...state,
        result: action.payload.result,
        insureagainst: action.payload.insureagainst,
        date: action.payload.date,
        amount: action.payload.amount,
        crop: action.payload.crop,
        premium: action.payload.premium,
      };
    default:
      return state;
  }
}
