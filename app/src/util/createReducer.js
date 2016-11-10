import { combineReducers } from 'redux';
import { routerReducer } from 'react-router-redux';
import { reducer as formReducer } from 'redux-form';
import location from '../components/Location/reducer'
import parameters from '../components/Parameters/reducer'

export default function createReducer() {
  return combineReducers({
    location,
    parameters,
    routing: routerReducer,
    form: formReducer
  });
}
