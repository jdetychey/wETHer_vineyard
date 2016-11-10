import React from 'react';
import RaisedButton from 'material-ui/RaisedButton';
import { css } from 'aphrodite';
import styles from '../../styles';
import { push } from 'react-router-redux';
import { connect } from 'react-redux';

class Home extends React.Component {

  handleThisTap = () => {
    this.props.changeRoute('/location');
  };

  render() {
    return (
        <div className={css(styles.home)}>
          <div className={css(styles.homeCoverButtonDiv)}>
            <RaisedButton label="COVER ME" secondary={true} fullWidth={true} onTouchTap={this.handleThisTap} />
          </div>
        </div>
      )
    }
}

function mapDispatchToProps(dispatch) {
  return {
    changeRoute: url => dispatch(push(url)),
    dispatch,
  };
}

export default connect(null, mapDispatchToProps)(Home);
