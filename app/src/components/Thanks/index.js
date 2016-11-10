import React from 'react';
import RaisedButton from 'material-ui/RaisedButton';
import { css } from 'aphrodite';
import styles from '../../styles';
import { push } from 'react-router-redux';
import { connect } from 'react-redux';
import DatePicker from 'material-ui/DatePicker';
import MenuItem from 'material-ui/MenuItem';
import Paper from 'material-ui/Paper';
import Divider from 'material-ui/Divider';
import RadioButton from 'material-ui/RadioButton';
// import {locationStore} from './actions';
import { Field, reduxForm, propTypes as ReduxFormPropTypes } from 'redux-form';
import {SelectField,TextField,RadioButtonGroup } from 'redux-form-material-ui'
import InsurancePool from 'contracts/InsurancePool.sol';
import Web3 from 'web3';
import {Table, TableBody, TableHeader, TableHeaderColumn, TableRow, TableRowColumn} from 'material-ui/Table';

const provider = new Web3.providers.HttpProvider('http://localhost:8545')
const web3 = new Web3();
web3.setProvider(provider);
InsurancePool.setProvider(provider);

class Thanks extends React.Component {


  handleThisTap = () => {
    //this.props.storeLocation(this.state.center.lat, this.state.center.lng);
    this.props.changeRoute('/');
  };

  render() {

    return (
      <div>
      <div className={css(styles.home, styles.parameters)}>
        <Paper zDepth={1} className={css(styles.parampaper)}>
          <h2 className={css(styles.papertitle)}>Thanks!</h2>
          <Table>
            <TableBody displayRowCheckbox={false}>
            <TableRow>
              <TableRowColumn>Premium:</TableRowColumn>
              <TableRowColumn>{this.props.parameters.premium}</TableRowColumn>
            </TableRow>
            <TableRow>
              <TableRowColumn>Crop:</TableRowColumn>
              <TableRowColumn>{this.props.parameters.crop}</TableRowColumn>
            </TableRow>
            <TableRow>
              <TableRowColumn>Principal:</TableRowColumn>
              <TableRowColumn>{this.props.parameters.amount}</TableRowColumn>
            </TableRow>
            <TableRow>
              <TableRowColumn>Risk:</TableRowColumn>
              <TableRowColumn>{this.props.parameters.insureagainst}</TableRowColumn>
            </TableRow>
            <TableRow>
              <TableRowColumn>Date:</TableRowColumn>
              <TableRowColumn>{this.props.parameters.date}</TableRowColumn>
            </TableRow>
            </TableBody>
          </Table>
          <p className={css(styles.resulthash)}>Registered on the Ethereum blockchain at address {this.props.parameters.result}.</p>
        </Paper>
      </div>
      <div className={css(styles.premiumCoverButtonDiv)}>
        <RaisedButton label="Another policy" secondary={true} fullWidth={true} onTouchTap={this.handleThisTap} />
      </div>
      </div>
    );
  }
}

const mapStateToProps = state => ({
  location: state.location,
  parameters: state.parameters,
});


function mapDispatchToProps(dispatch) {
  return {
    changeRoute: url => dispatch(push(url)),
    // storeLocation: (lat,lng) => dispatch(locationStore(lat,lng)),
    dispatch,
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(Thanks);
