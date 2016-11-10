import React from 'react';
import ReactDOM from 'react-dom';
import injectTapEventPlugin from 'react-tap-event-plugin';
import { browserHistory, Router, Route, IndexRoute } from 'react-router'
import { syncHistoryWithStore } from 'react-router-redux';
import { Provider } from 'react-redux'
import App from './App';
import { configureStore } from './util/configureStore'
import './index.css';
import Home from './components/Home';
import Location from './components/Location';
import Parameters from './components/Parameters';
import Premium from './components/Premium';
import MyPremiums from './components/MyPremiums';
import Thanks from './components/Thanks';

injectTapEventPlugin();

const initialState = window.INITIAL_STATE || {}; //eslint-disable-line
const history = browserHistory;
const store = configureStore(initialState, history);
const syncedHistory = syncHistoryWithStore(history, store);

  ReactDOM.render(
    <Provider store={store}>
      <Router history={syncedHistory}>
        <Route path="/" component={App}>
          <IndexRoute component={Home} />
          <Route path="location" component={Location} />
          <Route path="parameters" component={Parameters} />
          <Route path="premium" component={Premium} />
          <Route path="thanks" component={Thanks} />
          <Route path="my" component={MyPremiums} />
        </Route>
      </Router>
    </Provider>,
    document.getElementById('root')
  );
