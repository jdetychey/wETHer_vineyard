import { createStore, applyMiddleware, compose } from 'redux';
import thunk from 'redux-thunk';
import Web3 from 'web3';
import { routerMiddleware } from 'react-router-redux';
import createReducer from './createReducer';

export function configureStore(initialState, history) {
  const web3 = new Web3();

  const store = createStore(createReducer(), initialState, compose(
    applyMiddleware(
      routerMiddleware(history),
      thunk.withExtraArgument({ web3 }),
    ),

    process.env.NODE_ENV === 'development' &&
    typeof window === 'object' &&
    typeof window.devToolsExtension !== 'undefined' // eslint-disable-line
      ? window.devToolsExtension() // eslint-disable-line
      : f => f
  ));

  if (process.env.NODE_ENV === 'development') {
    if (module.hot) {
      module.hot.accept('./createReducer', () => store.replaceReducer(require('./createReducer').default));  //eslint-disable-line
    }
  }

  return store;
}
