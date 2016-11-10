import React from 'react';
import RaisedButton from 'material-ui/RaisedButton';
import { css } from 'aphrodite';
import styles from '../../styles';
import { push } from 'react-router-redux';
import { connect } from 'react-redux';
import {withGoogleMap,GoogleMap, Circle } from "react-google-maps";
import canUseDOM from "can-use-dom";
import raf from "raf";
import {locationStore} from './actions';

const geolocation = (
  canUseDOM && navigator.geolocation ?
  navigator.geolocation :
  ({
    getCurrentPosition(success, failure) {
      failure(`Your browser doesn't support geolocation.`);
    },
  })
);

const GeolocationExampleGoogleMap = withGoogleMap(props => (
  <GoogleMap
    defaultZoom={16}
    center={props.center}
  >
    {props.center && (
      <Circle
        center={props.center}
        radius={props.radius}
        options={{
          fillColor: `#FFEB3B`,
          fillOpacity: 0.20,
          strokeColor: `#FF9800`,
          strokeOpacity: 1,
          strokeWeight: 1,
        }}
      />
    )}
  </GoogleMap>
));

class Location extends React.Component {

  state = {
    center: null,
    content: null,
    radius: 50,
  };

  isUnmounted = false;

  componentDidMount() {
    const tick = () => {
      if (this.isUnmounted) {
        return;
      }
      this.setState({ radius: Math.max(this.state.radius - 20, 0) });

      if (this.state.radius > 200) {
        raf(tick);
      }
    };
    geolocation.getCurrentPosition((position) => {
      if (this.isUnmounted) {
        return;
      }
      this.setState({
        center: {
          lat: position.coords.latitude,
          lng: position.coords.longitude,
        },
        content: `Your plot`,
      });

      raf(tick);
    }, (reason) => {
      if (this.isUnmounted) {
        return;
      }
      this.setState({
        center: {
          lat: 53.3765952,
          lng: -6.2707478,
        },
        content: `Error: The Geolocation service failed (${reason}).`,
      });
    });
  }

  componentWillUnmount() {
    this.isUnmounted = true;
  }


  handleThisTap = () => {
    if(this.state.center){
      this.props.storeLocation(this.state.center.lat, this.state.center.lng);
    };
    this.props.changeRoute('/parameters');
  };

  render() {
    return (
        <div>
        <GeolocationExampleGoogleMap
          containerElement={
            <div />
          }
          mapElement={
            <div style={{ height: `100vh` }} />
          }
          center={this.state.center}
          content={this.state.content}
          radius={this.state.radius}
        />
          <div className={css(styles.homeCoverButtonDiv)}>
          <RaisedButton label="THIS IS CORRECT, CONTINUE" secondary={true} fullWidth={true} onTouchTap={this.handleThisTap} />
          </div>
        </div>
      )
    }
}

function mapDispatchToProps(dispatch) {
  return {
    changeRoute: url => dispatch(push(url)),
    storeLocation: (lat,lng) => dispatch(locationStore(lat,lng)),
    dispatch,
  };
}

export default connect(null, mapDispatchToProps)(Location);
