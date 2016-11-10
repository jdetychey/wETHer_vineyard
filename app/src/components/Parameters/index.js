import React from 'react';
import RaisedButton from 'material-ui/RaisedButton';
import { css } from 'aphrodite';
import styles from '../../styles';
import { push } from 'react-router-redux';
import { connect } from 'react-redux';
import MenuItem from 'material-ui/MenuItem';
import Paper from 'material-ui/Paper';
import RadioButton from 'material-ui/RadioButton';
import {parametersStore} from './actions';
import { Field, reduxForm, propTypes as ReduxFormPropTypes } from 'redux-form';
import {SelectField,TextField,RadioButtonGroup,DatePicker } from 'redux-form-material-ui'
import jsSHA from 'jssha';
import InsurancePool from 'contracts/InsurancePool.sol';
import InsuranceQuote from 'contracts/InsuranceQuote.sol';
import Web3 from 'web3';

const provider = new Web3.providers.HttpProvider('http://localhost:8545')
const web3 = new Web3();
web3.setProvider(provider);
InsurancePool.setProvider(provider);
InsuranceQuote.setProvider(provider);

class Parameters extends React.Component {

  handleSubmit = async (values) => {
    const insurancePool = InsurancePool.deployed();
    //console.log(web3.eth.getBalance(web3.eth.coinbase)); //THIS WORKS

    const url = `json(https://api.darksky.net/forecast/e5fa70950b02e623da2a1c7159f8ee93/${this.props.latitude},${this.props.longitude}).daily.data[0].precipProbability`;

    const shaObj = new jsSHA("SHA3-256", "TEXT");
    shaObj.update(url);
    const hash = shaObj.getHash("HEX");

    const result = await insurancePool.setQuote(hash, url, this.props.latitude, this.props.longitude, {from:web3.eth.accounts[0], gas:5000000, value: web3.toWei(1,'ether')});
    //console.log(values);
    this.props.storeParameters(result, values.insureagainst, values.date.toString(), values.amount, values.crop );



    this.props.changeRoute('/premium');
  }


  render() {
    const { handleSubmit, pristine, submitting, valid } = this.props;

    return (
      <div className={css(styles.home, styles.parameters)}>
        <Paper zDepth={1} className={css(styles.parampaper)}>
          <form onSubmit={handleSubmit(this.handleSubmit)}>
            <Field name="insureagainst" component={RadioButtonGroup}>
              <RadioButton value="rain" label="Insure against rain"/>
              <RadioButton value="drought" label="Insure against drought"/>
              <RadioButton value="hail" label="Insure against hail"/>
            </Field>
            <Field name="date" component={DatePicker} autoOk hintText="On date"/>
            <Field name="amount" component={TextField} hintText="Estimated value of your crops"/>
            <Field name="crop" component={SelectField} hintText="What crop do you have">
              <MenuItem value="Sugar cane" primaryText="Sugar cane"/>
              <MenuItem value="Maize" primaryText="Maize"/>
              <MenuItem value="Rice" primaryText="Rice"/>
              <MenuItem value="Wheat" primaryText="Wheat"/>
              <MenuItem value="Potatoes" primaryText="Potatoes"/>
              <MenuItem value="Sugar beet" primaryText="Sugar beet"/>
              <MenuItem value="Soybeans" primaryText="Soybeans"/>
              <MenuItem value="Cassava" primaryText="Cassava"/>
            </Field>
            <div>
              <RaisedButton type="submit" label="GET QUOTE" disabled={pristine || submitting || !valid}  secondary={true} fullWidth={true} />
            </div>
          </form>
        </Paper>
      </div>
    );
  }
}

Parameters.propTypes = {
  ...ReduxFormPropTypes
};

const validate = (values) => {
  const errors = {};
  const requiredFields = ['rain', 'gender'];
  requiredFields.forEach((field) => {
    if (!values[field]) {
      errors[field] = 'Required';
    }
  });
  return errors;
};

const mapStateToProps = state => ({
  latitude: state.location.latitude,
  longitude: state.location.longitude,
});

function mapDispatchToProps(dispatch) {
  return {
    changeRoute: url => dispatch(push(url)),
    storeParameters: (result, insureagainst, date, amount, crop ) => dispatch(parametersStore(result, insureagainst, date, amount, crop)),
    // storeLocation: (lat,lng) => dispatch(locationStore(lat,lng)),
    dispatch,
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(reduxForm({ form: 'parameters', validate })(Parameters));
